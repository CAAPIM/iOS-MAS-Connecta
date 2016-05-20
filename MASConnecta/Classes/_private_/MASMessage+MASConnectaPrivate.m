//
//  MASMessage+MASConnectaPrivate.m
//  MASConnecta
//
//  Copyright (c) 2016 CA, Inc.
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
    id json = [NSJSONSerialization JSONObjectWithData:mqttMessage.payload options:0 error:nil];
    
    //
    // Topic
    //
    NSString *topic = mqttMessage.topic;
    
    
    //
    // Retrieve data
    //
    NSString *base64String = [json objectForKey:MASConnectaMessagePayloadKey];
    NSData *payload = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];

    
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
    MASSenderType senderType = [self masSenderTypeForString:[json objectForKey:MASConnectaMessagePayloadSenderTypeKey]];

    
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
        self.payload = payload;
        self.contentType = contentType;
        self.version = @"1.0";
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
        self.payload = payload;
        self.contentType = contentType;
        self.contentEncoding = contentEncoding;
        self.version = version;
        self.topic = topic;
        self.receiverObjectId = receiverId;
        
        self.senderObjectId = senderId;
        self.senderDisplayName = senderDisplayName;
        self.senderType = senderType;
        self.sentTime = sentTime;
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


# pragma mark - Properties

- (NSDate *)payload
{
    return objc_getAssociatedObject(self, &MASMessagePayloadPropertyKey);
}


- (void)setPayload:(NSData *)payload
{
    objc_setAssociatedObject(self, &MASMessagePayloadPropertyKey, payload, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)contentType
{
    return objc_getAssociatedObject(self, &MASMessageContentTypePropertyKey);
}


- (void)setContentType:(NSString *)contentType
{
    objc_setAssociatedObject(self, &MASMessageContentTypePropertyKey, contentType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)contentEncoding
{
    return objc_getAssociatedObject(self, &MASMessageContentEncodingPropertyKey);
}


- (void)setContentEncoding:(NSString *)contentEncoding
{
    objc_setAssociatedObject(self, &MASMessageContentEncodingPropertyKey, contentEncoding, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)version
{
    return objc_getAssociatedObject(self, &MASMessageVersionPropertyKey);
}


- (void)setVersion:(NSString *)version
{
    objc_setAssociatedObject(self, &MASMessageVersionPropertyKey, version, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)topic
{
    return objc_getAssociatedObject(self, &MASMessageTopicPropertyKey);
}


- (void)setTopic:(NSString *)topic
{
    objc_setAssociatedObject(self, &MASMessageTopicPropertyKey, topic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)receiverObjectId
{
    return objc_getAssociatedObject(self, &MASMessageReceiverObjectIdPropertyKey);
}


- (void)setReceiverObjectId:(NSString *)receiverObjectId
{
    objc_setAssociatedObject(self, &MASMessageReceiverObjectIdPropertyKey, receiverObjectId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSDate *)sentTime
{
    return objc_getAssociatedObject(self, &MASMessageSentTimePropertyKey);
}


- (void)setSentTime:(NSDate *)sentTime
{
    objc_setAssociatedObject(self, &MASMessageSentTimePropertyKey, sentTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)senderObjectId
{
    return objc_getAssociatedObject(self, &MASMessageSenderObjectIdPropertyKey);
}


- (void)setSenderObjectId:(NSString *)senderObjectId
{
    objc_setAssociatedObject(self, &MASMessageSenderObjectIdPropertyKey, senderObjectId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)senderDisplayName
{
    return objc_getAssociatedObject(self, &MASMessageSenderDisplayNamePropertyKey);
}


- (void)setSenderDisplayName:(NSString *)senderDisplayName
{
    objc_setAssociatedObject(self, &MASMessageSenderDisplayNamePropertyKey, senderDisplayName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (MASSenderType)senderType
{
    NSNumber *senderTypeAsNumber = objc_getAssociatedObject(self, &MASMessageSenderTypePropertyKey);
    return [senderTypeAsNumber intValue];
}


- (void)setSenderType:(MASSenderType)senderType
{
    objc_setAssociatedObject(self, &MASMessageSenderTypePropertyKey, [NSNumber numberWithInt:senderType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
