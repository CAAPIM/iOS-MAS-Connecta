//
//  NSError+MASConnectaPrivate.m
//  MASConnecta
//
//  Created by Hun Go on 2016-11-17.
//  Copyright © 2016 CA Technologies. All rights reserved.
//

#import "NSError+MASConnectaPrivate.h"

@implementation NSError (MASConnectaPrivate)

+ (NSError *)errorForConnectaErrorCode:(MASConnectaError)errorCode errorDomain:(NSString *)errorDomain
{
    return [self errorForConnectaErrorCode:errorCode info:nil errorDomain:errorDomain];
}


+ (NSError *)errorForConnectaErrorCode:(MASConnectaError)errorCode info:(NSDictionary *)info errorDomain:(NSString *)errorDomain
{
    //
    // Standard error key/values
    //
    NSMutableDictionary *errorInfo = [NSMutableDictionary new];
    if(![info objectForKey:NSLocalizedDescriptionKey])
    {
        errorInfo[NSLocalizedDescriptionKey] = [self descriptionForConnectaErrorCode:errorCode];
    }
    
    [errorInfo addEntriesFromDictionary:info];
    
    return [NSError errorWithDomain:errorDomain code:errorCode userInfo:errorInfo];
}


+ (NSString *)descriptionForConnectaErrorCode:(MASConnectaError)errorCode
{
    //
    // Detect code and respond appropriately
    //
    switch(errorCode)
    {
            //
            // MQTT
            //
        case MASConnectaErrorConnectingMQTT: return NSLocalizedString(@"Connection Failed with MQTT Server", @"Connection Failed with MQTT Server");
        case MASConnectaErrorSubscribingMQTT: return NSLocalizedString(@"Error Subscribing to Topic", @"Error Subscribing to topic");
            
            //
            // Validation
            //
        case MASConnectaErrorMessageObjectNotSupported: return @"";
        case MASConnectaErrorRecipientInvalidOrNil: return @"";
        case MASConnectaErrorParameterInvalidOrNil: return NSLocalizedString(@"Parameter cannot be empty or nil", @"Parameter cannot be empty or nil");
            
            //
            // User
            //
        case MASConnectaErrorUserInvalidOrNil: return NSLocalizedString(@"A user does not exist", @"A user does not exist");
        case MASConnectaErrorUserNotAuthenticated: return NSLocalizedString(@"A user is not authenticated", @"A user is not authenticated");
        case MASConnectaErrorUserSessionIsCurrentlyLocked: return NSLocalizedString(@"User session is currently locked.", @"User session is currently locked.");
            
            //
            // Default
            //
        default: return [NSString stringWithFormat:@"Unrecognized error code of value: %ld", (long)errorCode];
    }
}

@end
