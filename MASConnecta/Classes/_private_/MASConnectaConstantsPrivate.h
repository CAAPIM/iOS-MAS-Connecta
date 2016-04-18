//
//  MASConnectaConstantsPrivate.h
//  MASConnecta
//
//  Created by Britton Katnich on 2016-03-05.
//  Copyright © 2016 CA Technologies. All rights reserved.
//

#import "MASConnecta.h"
#import "MASConnectaService.h"
#import "MASMessage+MASConnectaPrivate.h"
#import "NSString+MASConnecta.h"


///--------------------------------------
/// @name Payload
///--------------------------------------

# pragma mark - Payload

static NSString *const MASConnectaMessagePayloadKey = @"Payload";

static NSString *const MASConnectaMessagePayloadContentEncodingKey = @"ContentEncoding";
static NSString *const MASConnectaMessagePayloadContentTypeKey = @"ContentType";
static NSString *const MASConnectaMessagePayloadDisplayNameKey = @"DisplayName";
static NSString *const MASConnectaMessagePayloadForwardedTimeKey = @"ForwardedTime";
static NSString *const MASConnectaMessagePayloadProcessedTimeKey = @"ProcessedTime";
static NSString *const MASConnectaMessagePayloadSenderIdKey = @"SenderId";
static NSString *const MASConnectaMessagePayloadSenderTypeKey = @"SenderType";
static NSString *const MASConnectaMessagePayloadSentTimeKey = @"SentTime";
static NSString *const MASConnectaMessagePayloadVersionKey = @"Version";
