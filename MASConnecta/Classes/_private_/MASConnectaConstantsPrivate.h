//
//  MASConnectaConstantsPrivate.h
//  MASConnecta
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
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
