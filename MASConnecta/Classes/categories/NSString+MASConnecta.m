//
//  NSString+MASConnecta.m
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "NSString+MASConnecta.h"

#import "MASConnectaConstantsPrivate.h"


@implementation NSString (MASConnecta)


# pragma mark - Public

+ (NSString *)payloadWithString:(NSObject *)message sentTime:(NSDate *)sentTime andObject:(MASObject *)masObject
{
    NSParameterAssert(message);
    NSParameterAssert(sentTime);
    NSParameterAssert(masObject);
    
    NSMutableDictionary *payloadInfo = [NSMutableDictionary new];
    
    //
    // Content
    //
    payloadInfo[MASConnectaMessagePayloadContentEncodingKey] = @"UTF-8";
    payloadInfo[MASConnectaMessagePayloadContentTypeKey] = @"text/plain";
    
    //
    // Payload & Content
    //
    NSData *encodeData;
    if ([message isKindOfClass:[NSString class]]) {
        
        encodeData = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([message isKindOfClass:[NSData class]]) {
        
        encodeData = (NSData *)message;
    }
    else if ([message isKindOfClass:[UIImage class]]) {
        
        encodeData = UIImagePNGRepresentation((UIImage *)message);
    }

    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    payloadInfo[MASConnectaMessagePayloadKey] = base64String;
    payloadInfo[MASConnectaMessagePayloadVersionKey] = @"1.0";
    payloadInfo[MASConnectaMessagePayloadDisplayNameKey] = [self displayNameForObject:masObject];
    
    //
    // Sender
    //
    payloadInfo[MASConnectaMessagePayloadSenderTypeKey] = [self senderReceiverTypeAsStringForObject:masObject];
    payloadInfo[MASConnectaMessagePayloadSenderIdKey] = masObject.objectId;
    double timestamp = [sentTime timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
    payloadInfo[MASConnectaMessagePayloadSentTimeKey] = [NSNumber numberWithLongLong:timeInMilisInt64];
    //[sentTime description];
    //[NSString stringWithFormat:@"%f",[sentTime timeIntervalSince1970]]; //Validate this --lsanches

    //
    // JSON serialization
    //
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadInfo
        options:NSJSONWritingPrettyPrinted
        error:&error];
    
    if(error)
    {
        DLog(@"Error on json serialization: %@", error.localizedDescription);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (NSString *)payloadWithData:(NSData *)message type:(NSString *)type sentTime:(NSDate *)sentTime object:(MASObject *)masObject andTopic:(NSString *)topic
{
    NSParameterAssert(message);
    NSParameterAssert(type);
    NSParameterAssert(masObject);
    
    NSMutableDictionary *payloadInfo = [NSMutableDictionary new];
    
    //
    // Version
    //
    payloadInfo[MASConnectaMessagePayloadVersionKey] = @"1.0";


    //
    // Content
    //
    payloadInfo[MASConnectaMessagePayloadContentEncodingKey] = @"UTF-8";
    payloadInfo[MASConnectaMessagePayloadContentTypeKey] = type;
    
    
    //
    // Payload
    //
    NSString *base64String = [message base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    payloadInfo[MASConnectaMessagePayloadKey] = base64String;
    payloadInfo[MASConnectaMessagePayloadDisplayNameKey] = [self displayNameForObject:masObject];
    
    
    //
    // Sender
    //
    payloadInfo[MASConnectaMessagePayloadSenderTypeKey] = [self senderReceiverTypeAsStringForObject:masObject];
    payloadInfo[MASConnectaMessagePayloadSenderIdKey] = masObject.objectId;
    
    
    //
    // SentTime (miliseconds)
    //
    double timestamp = [sentTime timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp*1000);
    payloadInfo[MASConnectaMessagePayloadSentTimeKey] = [NSNumber numberWithLongLong:timeInMilisInt64];

    
    //
    // JSON serialization
    //
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if(error)
    {
        DLog(@"Error on json serialization: %@", error.localizedDescription);
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//
//Format the topic depending on the object requesting this format
//Note: This format is compatible only with version 2.0 of the MQTT Policy on the Gateway
//
+ (NSString *)structureTopic:(NSString *)topic forObject:(MASObject *)masObject
{
    NSParameterAssert(topic);
    
    if (!masObject) {
        
        return topic;
    }
    
    NSString *structuredTopic;
    
    NSString *apiVersion = apiTopicVersion;
    NSString *objectID = masObject.objectId;
    
/*   NOTE:
 
     //
     //Version 1.0 DEPRECADED
     //

     /1.0/organization/<organizationID>/client/<clientId>/users/<userID>/custom/<developer_defined_topic> (used)
     /1.0/organization/<organizationID>/users/<userId>/custom/<developer_defined_topic> (never used)
    
     
     //
     //Version 2.0
     //
    
     /2.0/client/users/<userId>/custom/<developer_defined_topic> (used at the moment)
     /2.0/users/<userId>/custom/<developer_defined_topic> (not been used at the moment)
     /2.0/client/custom/<developer_defined_topic> (used at the moment)
     /2.0/error
     
 */
    
    //
    // MASUser
    //
    if ([masObject isKindOfClass:[MASUser class]]) {
        
        structuredTopic = [NSString stringWithFormat:@"/%@/client/users/%@/custom/%@",apiVersion,objectID,topic];
    }
    
    
    //
    // MASDevice
    //
    else if ([masObject isKindOfClass:[MASDevice class]]) {
        
        structuredTopic = [NSString stringWithFormat:@"/%@/client/devices/%@/custom/%@",apiVersion,objectID,topic];
    }
    
    
    //
    // MASApplication
    //
    else if ([masObject isKindOfClass:[MASApplication class]]) {
        
        structuredTopic = [NSString stringWithFormat:@"/%@/client/custom/%@",apiVersion,topic];
    }

    //
    // MASGroup
    //
    else if ([masObject isKindOfClass:[MASGroup class]]) {
        
        structuredTopic = [NSString stringWithFormat:@"/%@/client/groups/%@/custom/%@",apiVersion,objectID,topic];
    }

    return structuredTopic;
}


# pragma mark - Private

+ (NSString *)displayNameForObject:(MASObject *)masObject
{
    NSString *displayName = @"";
    
    //
    // MASApplication
    //
    if ([masObject isKindOfClass:[MASApplication class]])
    {
        displayName = ((MASApplication *)masObject).name;
    }
    
    //
    // MASDevice
    //
    else if ([masObject isKindOfClass:[MASDevice class]])
    {
        displayName = ((MASDevice *)masObject).name;
    }

    //
    // MASGroup
    //
    else if ([masObject isKindOfClass:[MASGroup class]])
    {
        displayName = ((MASGroup *)masObject).groupName;
    }

    //
    // MASUser
    //
    else if([masObject isKindOfClass:[MASUser class]])
    {
        displayName = ((MASUser *)masObject).userName;
    }
    
    return displayName;
}


+ (NSString *)senderReceiverTypeAsStringForObject:(MASObject *)masObject
{
    NSString *value = @"Unknown";
    
    //
    // MASApplication
    //
    if ([masObject isKindOfClass:[MASApplication class]])
    {
        value = MASSenderTypeApplicationValue;
    }
    
    //
    // MASDevice
    //
    else if ([masObject isKindOfClass:[MASDevice class]])
    {
        value = MASSenderTypeDeviceValue;
    }

    //
    // MASGroup
    //
    else if ([masObject isKindOfClass:[MASGroup class]])
    {
        value = MASSenderTypeGroupValue;
    }

    //
    // MASUser
    //
    else if([masObject isKindOfClass:[MASUser class]])
    {
        value = MASSenderTypeUserValue;
    }
    
    return value;
}


@end
