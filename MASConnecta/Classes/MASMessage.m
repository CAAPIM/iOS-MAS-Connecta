//
//  MASMessage.m
//  MASConnecta
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASMessage.h"

#import "MASConnectaConstantsPrivate.h"


@implementation MASMessage


# pragma mark - Lifecycle

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"init is not a valid initializer, please use a factory method"
                                 userInfo:nil];
    return [super init];
}


- (instancetype)initWithPayloadData:(NSData *)payload
                           contentType:(NSString *)contentType
{
    return [self initWithPayload:payload contentType:contentType];
}

- (instancetype)initWithPayloadString:(NSString *)payload
                             contentType:(NSString *)contentType
{
    NSData *encodeData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithPayload:encodeData contentType:contentType];

}

- (instancetype)initWithPayloadImage:(UIImage *)payload
                            contentType:(NSString *)contentType
{
    NSData *encodeData = UIImagePNGRepresentation(payload);
    return [self initWithPayload:encodeData contentType:contentType];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"(%@)\n\n version: %@\n contentType: %@\n contentEncoding: %@\n payload: %@\n"
        " receiverObjectId: %@\n senderDisplayName: %@\n senderObjectId: %@\n senderType: %@\n sentTime: %@\n topic: %@",
        [self class], self.version, self.contentType, self.contentEncoding,[self payloadTypeAsString],
        self.receiverObjectId, self.senderDisplayName,self.senderObjectId, [self senderTypeAsString], self.sentTime, [self topic]];
}


# pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.contentType) [aCoder encodeObject:self.contentType forKey:MASMessageContentTypePropertyKey];
    if(self.contentEncoding) [aCoder encodeObject:self.contentEncoding forKey:MASMessageContentEncodingPropertyKey];
    if(self.payload) [aCoder encodeObject:self.payload forKey:MASMessagePayloadPropertyKey];
    if(self.version) [aCoder encodeObject:self.version forKey:MASMessageVersionPropertyKey];
    if(self.topic) [aCoder encodeObject:self.topic forKey:MASMessageTopicPropertyKey];
    
    if(self.receiverObjectId) [aCoder encodeObject:self.receiverObjectId forKey:MASMessageReceiverObjectIdPropertyKey];
    
    if(self.senderObjectId) [aCoder encodeObject:self.senderObjectId forKey:MASMessageSenderObjectIdPropertyKey];
    if(self.senderDisplayName) [aCoder encodeObject:self.senderDisplayName forKey:MASMessageSenderDisplayNamePropertyKey];
    if(self.sentTime) [aCoder encodeObject:self.sentTime forKey:MASMessageSentTimePropertyKey];
    [aCoder encodeInt:self.senderType forKey:MASMessageSenderTypePropertyKey];

    //DLog(@"\n\ncalled and self is: %@\n\n", [self debugDescription]);
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.contentType = [aDecoder decodeObjectForKey:MASMessageContentTypePropertyKey];
        self.contentEncoding = [aDecoder decodeObjectForKey:MASMessageContentEncodingPropertyKey];
        self.payload = [aDecoder decodeObjectForKey:MASMessagePayloadPropertyKey];
        self.version = [aDecoder decodeObjectForKey:MASMessageVersionPropertyKey];
        self.topic = [aDecoder decodeObjectForKey:MASMessageTopicPropertyKey];

        self.receiverObjectId = [aDecoder decodeObjectForKey:MASMessageReceiverObjectIdPropertyKey];
        
        self.senderObjectId = [aDecoder decodeObjectForKey:MASMessageSenderObjectIdPropertyKey];
        self.senderDisplayName = [aDecoder decodeObjectForKey:MASMessageSenderDisplayNamePropertyKey];
        self.sentTime = [aDecoder decodeObjectForKey:MASMessageSentTimePropertyKey];
        self.senderType = [aDecoder decodeIntForKey:MASMessageSenderTypePropertyKey];
    }
    
    //DLog(@"\n\ncalled and self is: %@\n\n", [self debugDescription]);
    
    return self;
}


# pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MASMessage *message = [[MASMessage alloc] initWithPayload:self.payload
                                                  contentType:self.contentType
                                              contentEncoding:self.contentEncoding
                                                      version:self.version
                                                        topic:self.topic
                                                   receiverId:self.receiverObjectId
                                                     senderId:self.senderObjectId
                                            senderDisplayName:self.senderDisplayName
                                                   senderType:self.senderType
                                                     sentTime:self.sentTime];
    
    return message;
}


# pragma mark - Public

- (NSString *)payloadTypeAsString
{
    //
    // Confirm there is a payload
    //
    NSString *value = nil;
    
    if(self.payload)
    {
        //
        // Check if the payload has already been converted to a string or needs
        // to be converted
        //
        if ([self.payload isKindOfClass:[NSString class]]) {
            
            value = (NSString *)self.payload;
        }
        else {
            
            // Decode the payload
            value = [[NSString alloc] initWithData:self.payload encoding:NSUTF8StringEncoding];
        }
    }
 
    return value;
}


- (UIImage *)payloadTypeAsImage
{
    UIImage *value = nil;

    //
    // Confirm there is a payload
    //
    if(self.payload)
    {
        NSData *imageData = self.payload;
        
        //
        // Check if there is metadata inside the payload. If so, change the way of loading the image
        //
        NSString *base64String = [[NSString alloc] initWithData:self.payload encoding:NSUTF8StringEncoding];
        if (base64String) {
            
            NSURL *imageUrl = [NSURL URLWithString:base64String];
            imageData = [NSData dataWithContentsOfURL:imageUrl];
        }

        UIImage *image= [UIImage imageWithData:imageData];
        
        if(image != nil){
            
            value = image;
        }
    }
    
    return value;
}


- (NSString *)senderTypeAsString
{
    return [MASMessage stringFromSenderType:self.senderType];
}


+ (NSString *)stringFromSenderType:(MASSenderType)type
{
    //
    // Detect type and responsed appropriately
    //
    switch(type)
    {
        //
        // Application
        //
        case MASSenderTypeApplication: return MASSenderTypeApplicationValue;
        
        //
        // Device
        //
        case MASSenderTypeDevice: return MASSenderTypeDeviceValue;
        
        //
        // Group
        //
        case MASSenderTypeGroup: return MASSenderTypeGroupValue;
        
        //
        // User
        //
        case MASSenderTypeUser: return MASSenderTypeUserValue;
        
        //
        // Default (unknown)
        //
        default: return @"Unknown";
    }
}

@end
