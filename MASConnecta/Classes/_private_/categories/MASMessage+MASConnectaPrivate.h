//
//  MASMessage+MASConnectaPrivate.h
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASConnecta/MASConnecta.h>


# pragma mark - Property Constants

static NSString *const MASMessageContentTypePropertyKey = @"contentType";
static NSString *const MASMessageContentEncodingPropertyKey = @"contentEncoding";
static NSString *const MASMessagePayloadPropertyKey = @"payload";
static NSString *const MASMessageReceiverObjectIdPropertyKey = @"receiverObjectId";
static NSString *const MASMessageSenderObjectIdPropertyKey = @"senderObjectId";
static NSString *const MASMessageSenderDisplayNamePropertyKey = @"senderDisplayName";
static NSString *const MASMessageSenderTypePropertyKey = @"senderType";
static NSString *const MASMessageSentTimePropertyKey = @"sentTime";
static NSString *const MASMessageVersionPropertyKey = @"version";
static NSString *const MASMessageTopicPropertyKey = @"topic";

@interface MASMessage (MASConnectaPrivate)

# pragma mark - Message

+ (MASMessage *)messageFromMQTTMessage:(MASMQTTMessage *)mqttMessage;


# pragma mark - Lifecycle

- (instancetype)initWithPayload:(NSData *)payload
                    contentType:(NSString *)contentType;


- (instancetype)initWithPayload:(NSData *)payload
                    contentType:(NSString *)contentType
                contentEncoding:(NSString *)contentEncoding
                        version:(NSString *)version
                          topic:(NSString *)topic
                     receiverId:(NSString *)receiverId
                       senderId:(NSString *)senderId
              senderDisplayName:(NSString *)senderDisplayName
                     senderType:(MASSenderType)senderType
                       sentTime:(NSDate *)sentTime;
    

# pragma mark - Notifications

- (void)postReceivedNotification;


- (void)postSentNotification;

@end
