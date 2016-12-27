//
//  MASMessage+MASConnectaPrivate.m
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASMessage+MASConnectaPrivate.h"

#import <objc/runtime.h>
#import "MASConnectaConstantsPrivate.h"


@implementation MASMessage (MASConnectaPrivate)


# pragma mark - Message

+ (MASMessage *)messageFromMQTTMessage:(MASMQTTMessage *)mqttMessage
{
    NSParameterAssert(mqttMessage);
    
    //
    // Getting only the message from the payload structure
    //
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mqttMessage.payload options:0 error:nil];
    
    //
    // Topic
    //
    NSString *topic = mqttMessage.topic;
    
    
    //
    // Retrieve data
    //
    NSData *payload;
    if ([[[topic componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"error"]) {
        
        NSString *errorMessage = [json objectForKey:MASConnectaMessageErrorKey];
        payload = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if (json && [json.allKeys containsObject:MASConnectaMessagePayloadKey]) {

        NSString *base64String = [json objectForKey:MASConnectaMessagePayloadKey];
        payload = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else {
        
        payload = mqttMessage.payload;
    }

    
    //
    // Version
    //
    NSString *version = [json objectForKey:MASConnectaMessagePayloadVersionKey];
    
    
    //
    // Content
    //
    NSString *contentEncoding = [json objectForKey:MASConnectaMessagePayloadContentEncodingKey];
    NSString *contentType = [json objectForKey:MASConnectaMessagePayloadContentTypeKey];
    
    
    //
    // Receiver
    //
    NSString *receiverId = [MASUser currentUser].objectId;
    
    
    //
    // Sender
    //
    NSString *senderDisplayName = [json objectForKey:MASConnectaMessagePayloadDisplayNameKey];
    NSString *senderId = [json objectForKey:MASConnectaMessagePayloadSenderIdKey];
    NSString *dateValue = [json objectForKey:MASConnectaMessagePayloadSentTimeKey];
    double timeInMilisInt64 = (double)[dateValue longLongValue]/1000;
    NSDate *sentTime = [NSDate dateWithTimeIntervalSince1970:timeInMilisInt64];
    MASSenderType senderType;
    if ([[[topic componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"error"]) {
    
        senderType = MASSenderTypeUnknown;
    }
    else if (json && [json.allKeys containsObject:MASConnectaMessagePayloadSenderTypeKey]){
        
        senderType = [self masSenderTypeForString:[json objectForKey:MASConnectaMessagePayloadSenderTypeKey]];
    }
    else {
        
        senderType = MASSenderTypeUnknown;
    }

    
    //
    // Create the message
    //
    MASMessage *message = [[MASMessage alloc] initWithPayload:payload
                                                  contentType:contentType
                                              contentEncoding:contentEncoding
                                                      version:version
                                                        topic:topic
                                                   receiverId:receiverId
                                                     senderId:senderId
                                            senderDisplayName:senderDisplayName
                                                   senderType:senderType
                                                     sentTime:sentTime];
    
    return message;
}

# pragma mark - Helper

+ (MASSenderType)masSenderTypeForString:(NSString *)string
{
    NSParameterAssert(string);

    NSArray *senderTypeValues = @[@"APPLICATION",@"DEVICE",@"GROUP",@"USER"];

    return (MASSenderType)[senderTypeValues indexOfObject:string];
}

# pragma mark - Lifecycle

- (instancetype)initWithPayload:(NSData *)payload
                    contentType:(NSString *)contentType
{
    self = [super init];
    
    if(self)
    {
        [self setValue:payload forKey:@"payload"];
        [self setValue:contentType forKey:@"contentType"];
        [self setValue:@"1.0" forKey:@"version"];
    }
    
    return self;
}

- (instancetype)initWithPayload:(NSData *)payload
                    contentType:(NSString *)contentType
                contentEncoding:(NSString *)contentEncoding
                        version:(NSString *)version
                          topic:(NSString *)topic
                     receiverId:(NSString *)receiverId
                       senderId:(NSString *)senderId
              senderDisplayName:(NSString *)senderDisplayName
                     senderType:(MASSenderType)senderType
                       sentTime:(NSDate *)sentTime
{
    if(self = [super init])
    {
        [self setValue:payload forKey:@"payload"];
        [self setValue:contentType forKey:@"contentType"];
        [self setValue:contentEncoding forKey:@"contentEncoding"];
        [self setValue:version forKey:@"version"];
        [self setValue:topic forKey:@"topic"];
        [self setValue:receiverId forKey:@"receiverObjectId"];
        
        [self setValue:senderId forKey:@"senderObjectId"];
        [self setValue:senderDisplayName forKey:@"senderDisplayName"];
        [self setValue:[NSNumber numberWithInteger:senderType] forKey:@"senderType"];
        [self setValue:sentTime forKey:@"sentTime"];
    }
    
    return self;
}


# pragma mark - Notifications

- (void)postReceivedNotification
{
    NSDictionary *userInfo = @
    {
        MASConnectaMessageKey : [self copy]
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MASConnectaMessageReceivedNotification
        object:nil
        userInfo:userInfo];
}


- (void)postSentNotification
{
    NSDictionary *userInfo = @
    {
        MASConnectaMessageKey : [self copy]
    };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MASConnectaMessageSentNotification
        object:nil
        userInfo:userInfo];
}
@end
