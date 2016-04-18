//
//  MASConnectaConstants.h
//  MASConnecta
//
//  Created by Luis Sanches on 2015-08-18.
//  Copyright (c) 2015 CA Technologies. All rights reserved.
//


///--------------------------------------
/// @name Enumerations
///--------------------------------------

# pragma mark - Enumerations

/**
 * Message Sender Type
 */
typedef NS_ENUM(NSInteger, MASSenderType)
{
    /**
     * Unknown
     */
    MASSenderTypeUnknown = -1,
    
    /**
     * MASApplication
     */
    MASSenderTypeApplication,
    
    /**
     * MASDevice
     */
    MASSenderTypeDevice,
    
    /**
     * MASGroup
     */
    MASSenderTypeGroup,
    
    /**
     * MASUser
     */
    MASSenderTypeUser
};


static NSString *const MASSenderTypeApplicationValue = @"APPLICATION";
static NSString *const MASSenderTypeDeviceValue = @"DEVICE";
static NSString *const MASSenderTypeGroupValue = @"GROUP";
static NSString *const MASSenderTypeUserValue = @"USER";



///--------------------------------------
/// @name Notifications
///--------------------------------------

# pragma mark - Notifications

/**
 * The NSString constant for the message received notification.
 */
static NSString *const MASConnectaMessageReceivedNotification = @"MASConnectaMessageReceivedNotification";


/**
 * The NSString constant for the message sent notification.
 */
static NSString *const MASConnectaMessageSentNotification = @"MASConnectaMessageSentNotification";



///--------------------------------------
/// @name Notification Keys
///--------------------------------------

# pragma mark - Notification Keys

/**
 * The NSString constant for the message key object within the userInfo of the notification.
 */
static NSString *const MASConnectaMessageKey = @"MASConnectaMessageKey";
