//
//  MASConnectaService.m
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASConnectaService.h"

#import "MASConnectaConstantsPrivate.h"


@implementation MASConnectaService


# pragma mark - Shared Service

+ (instancetype)sharedService
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[MASConnectaService alloc] initProtected];
    });
    
    return sharedInstance;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma mark - Lifecycle

+ (NSString *)serviceUUID
{
    // DO NOT change this without a corresponding change in MASFoundation
    return @"ce68de11-609c-42cb-9fb1-96d661e9ff17";
}


# pragma mark - Public

+ (void)load
{
    [MASService registerSubclass:[self class] serviceUUID:@"ce68de11-609c-42cb-9fb1-96d661e9ff17"];
}


- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@\n\n", [super debugDescription]];
}


# pragma mark - Lifecycle

- (void)serviceDidLoad
{
    [super serviceDidLoad];
    
    //
    // Register for messages notifications
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onMessageReceived:)
        name:MASConnectaOperationDidReceiveMessageNotification
        object:nil];
}


- (void)onMessageReceived:(NSNotification *)notification
{
    //DLog(@"\n\ncalled with notification: %@\n\n", notification);

    //
    // Detect if unexpected notification received
    //
    if(![notification.name isEqualToString:MASConnectaOperationDidReceiveMessageNotification])
    {
        DLog(@"Warning received unexpected notification type: %@", notification.name);
        return;
    }
    
    //
    // Messages
    //
    MASMQTTMessage *newMessage = notification.object;
    MASMessage *message = [MASMessage messageFromMQTTMessage:newMessage];
    
    //
    // Post received notification
    //
    [message postReceivedNotification];
}

@end
