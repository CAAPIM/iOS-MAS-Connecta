//
//  MASUser+Connecta.m
//  MASConnecta
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASUser+Connecta.h"

#import <objc/runtime.h> //Used for the dynamic getter and setter inside a Category.
#import "MASConnectaConstantsPrivate.h"

#define kSDKErrorDomain     @"com.ca.MASConnecta:ErrorDomain"

static void *messageQueuePropertyKey;
static void *topicQueuePropertyKey;


typedef NS_ENUM (NSUInteger, MASConnectaError)
{
    MASConnectaErrorUserNotAuthenticated = 101,
    MASConnectaErrorConnectingMQTT = 102,
    MASConnectaErrorSubscribingMQTT = 103,
    MASConnectaErrorMessageObjectNotSupported = 104,
    MASConnectaErrorUserInvalidOrNil = 105,
    MASConnectaErrorRecipientInvalidOrNil = 106,
};


@implementation MASUser (Connecta)


# pragma mark - Public methods

- (BOOL)validateParameters:(NSArray *)parameters withError:(NSError **)error
{
    for (NSObject *param in parameters) {
        
        //Check if any parameter is Nil
        if (!param) {

            NSString *message = NSLocalizedString(@"Parameter cannot be empty or nil", @"Parameter cannot be empty or nil");
            *error = [NSError errorWithDomain:kSDKErrorDomain
                                         code:MASConnectaErrorMessageObjectNotSupported
                                     userInfo:@{ NSLocalizedDescriptionKey : message }];

            return NO;
            
        }else if ([param isKindOfClass:[NSString class]]) {
            
            if ([(NSString *)param length] < 1) {
            
                NSString *message = NSLocalizedString(@"Parameter cannot be empty or nil", @"Parameter cannot be empty or nil");
                *error = [NSError errorWithDomain:kSDKErrorDomain
                                             code:MASConnectaErrorMessageObjectNotSupported
                                         userInfo:@{ NSLocalizedDescriptionKey : message }];
                
                return NO;
            }

        }else if ([param isKindOfClass:[MASObject class]]) {
            
            if (![(MASObject *)param objectId]) {
                
                NSString *message = NSLocalizedString(@"Invalid recipient parameter", @"Invalid recipient parameter");
                *error = [NSError errorWithDomain:kSDKErrorDomain
                                             code:MASConnectaErrorMessageObjectNotSupported
                                         userInfo:@{ NSLocalizedDescriptionKey : message }];
                
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)sendMessage:(NSObject *)message
             toUser:(MASUser *)user
         completion:(void (^)(BOOL success, NSError *error))completion;
{
    NSError *localizedError = nil;
    
    if ([self validateParameters:@[message,user] withError:&localizedError]) {
        
        [self sendMessage:message toObject:user onTopic:nil completion:completion];
        
    }else if (completion) {
        
        completion (NO, localizedError);
    }
}


- (void)sendMessage:(NSObject *)message
             toUser:(MASUser *)user
            onTopic:(NSString *)topic
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSError *localizedError = nil;
    
    if ([self validateParameters:@[message,user,topic] withError:&localizedError]) {
        
        [self sendMessage:message toObject:user onTopic:topic completion:completion];
        
    }else if (completion) {
        
        completion (NO, localizedError);
    }
}


- (void)sendMessage:(NSObject *)message
            toGroup:(MASGroup *)group
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSError *localizedError = nil;
    
    if ([self validateParameters:@[message,group] withError:&localizedError]) {
        
        [self sendMessage:message toObject:group onTopic:nil completion:completion];
        
    }else if (completion) {
        
        completion (NO, localizedError);
    }
}


- (void)sendMessage:(NSObject *)message
           toDevice:(MASDevice *)device
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSError *localizedError = nil;
    
    if ([self validateParameters:@[message,device] withError:&localizedError]) {
        
        [self sendMessage:message toObject:device onTopic:nil completion:completion];
        
    }else if (completion) {
        
        completion (NO, localizedError);
    }
}


#pragma mark - Private methods

- (void)sendMessage:(NSObject *)message
           toObject:(MASObject *)object
            onTopic:(NSString *)topic
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(message);
    NSParameterAssert(object);

    __block NSData *encodeData;
    __block NSString *messageType;
    
    //
    // Validate the Message object. Only NSString and MASMessage are supported
    //
    if ([message isKindOfClass:[NSString class]]) {
        
        encodeData = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
        messageType = @"text/plain";
    }
    else if ([message isKindOfClass:[MASMessage class]]) {
        
        encodeData = ((MASMessage *)message).payload;
        messageType = ((MASMessage *)message).contentType;
    }
    else if (completion) {
        
        NSString *message = NSLocalizedString(@"Message object not supported", @"Message object not supported");
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorMessageObjectNotSupported
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        completion(NO, localizedError);
        
        return;
    }
    
    //
    // Validating Sender User (CurrentUser)
    //
    if (!self.objectId) {
        
        NSString *message = NSLocalizedString(@"Current user invalid or nil. Please retrieve user data from the server and try again.", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorUserInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    
    //
    // Validating Recipient User
    //
    if (!object.objectId) {
        
        NSString *message = NSLocalizedString(@"Parameter object invalid or nil. Please retrieve object data from the server and try again..", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorRecipientInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }

    
    //
    // Applying format to Message
    //
    __block NSDate *sentTime = [NSDate new];
    __block NSString *formattedMessage = [NSString payloadWithData:encodeData
                                                              type:messageType
                                                          sentTime:sentTime
                                                            object:self
                                                          andTopic:nil];
    
    //
    // Applying format to Topic
    //
    __block NSString *formattedTopic;
    if (topic != nil && [topic length] > 0) {
        
        formattedTopic = [NSString structureTopic:topic forObject:object];
    }
    else {
        
        formattedTopic = [NSString structureTopic:object.objectId forObject:object];
    }
    
    
    //
    // Send the message
    //
    __block typeof(self) blockSelf = self;
    [self sendMessage:formattedMessage toTopic:formattedTopic completion:^(BOOL success, NSError *error)
     {
         if (success) {
             
             //
             // Create the message object
             //
             MASMessage *newMessage = [[MASMessage alloc] initWithPayload:encodeData
                                                              contentType:messageType
                                                          contentEncoding:@"UTF-8"
                                                                  version:@"1.0"
                                                                    topic:formattedTopic
                                                               receiverId:object.objectId
                                                                 senderId:blockSelf.objectId
                                                        senderDisplayName:blockSelf.userName
                                                               senderType:MASSenderTypeUser
                                                                 sentTime:sentTime];
             
             
             //
             // Post sent notification
             //
             [newMessage postSentNotification];
         }
         
         //
         // Notify
         //
         if(completion) completion(success, error);
     }];
}


- (void)sendMessage:(NSString *)message
            toTopic:(NSString *)topic
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(message);
    NSParameterAssert(topic);

    //
    // Send the message
    //
    [self sendMessage:message toTopic:topic qos:defaultQoS retain:defaultRatain completion:^(BOOL success, NSError *error)
    {
        //
        // Notify
        //
        if(completion) completion(success, error);
    }];
}


- (void)sendMessage:(NSString *)message
            toTopic:(NSString *)topic
                qos:(NSUInteger)qos
             retain:(BOOL)retain
         completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(message);
    NSParameterAssert(topic);
    
    //
    // Validate if is CurrentUser calling this method
    //
    if (!self.isCurrentUser) {
        
        NSString *message = NSLocalizedString(@"Unauthenticated user", @"unauthenticated user");
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
            code:MASConnectaErrorUserNotAuthenticated
            userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Check if messageQueue exist
    //
    if (!self.messageQueue) {
        
        self.messageQueue = [[NSMutableArray alloc] init];
    }
    
    //
    // Create the messagePayload Object
    //
    MASMQTTMessage *messagePayload = [[MASMQTTMessage alloc] initWithTopic:topic
                                                                   payload:[message dataUsingEncoding:NSUTF8StringEncoding]
                                                                       qos:qos
                                                                    retain:retain
                                                                       mid:0];
    
    //
    // Queue the messagePayload Object
    //
    [self.messageQueue addObject:messagePayload];
    
    //
    // Not Connected
    //
    if (![MASMQTTClient sharedClient].connected)
    {
        //
        // Set the username and password for the connection
        //
        [[MASMQTTClient sharedClient] setUsername:self.objectId Password:self.accessToken];

        //
        // Connect the MQTTClient with the Broker / Gateway
        //
        [[MASMQTTClient sharedClient] connectToHost:[MASConfiguration currentConfiguration].gatewayHostName
                                            withTLS:YES
                                  completionHandler:^(MQTTConnectionReturnCode code)
        {
            //
            // Accepted
            //
            if (code == ConnectionAccepted)
            {
                for (MASMQTTMessage *msm in self.messageQueue)
                {
                    [[MASMQTTClient sharedClient] publishString:msm.payloadString
                                                        toTopic:msm.topic
                                                        withQos:msm.qos
                                                         retain:msm.retained
                                              completionHandler:nil];
                }
                self.messageQueue = [[NSMutableArray alloc] init];
                
                //
                // Notify
                //
                if (completion) completion(YES, nil);
            }
            
            //
            // Not Accepted
            //
            else
            {
                // Connection failured but mosquitto will automatically reconnect
                DLog(@"Connection Failed with MQTT Server");
                 
                NSString *message = NSLocalizedString(@"Connection Failed with MQTT Server", @"Connection Failed with MQTT Server");
                NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                    code:MASConnectaErrorConnectingMQTT
                    userInfo:@{ NSLocalizedDescriptionKey : message }];
                
                //
                // Notify
                //
                if (completion) completion(NO,localizedError);
            }
        }];
    }
    
    //
    // Already Connected
    //
    else
    {
        //
        // Publish all queued messages
        //
        for (MASMQTTMessage *msm in self.messageQueue)
        {
            [[MASMQTTClient sharedClient] publishString:msm.payloadString
                                                toTopic:msm.topic
                                                withQos:msm.qos
                                                 retain:msm.retained
                                      completionHandler:nil];
        }
        self.messageQueue = [[NSMutableArray alloc] init];
        
        //
        // Notify
        //
        if (completion) completion(YES,nil);
    }
}


# pragma mark - Listen To Messages

- (void)startListeningToMesasgesFromGroup:(MASGroup *)group
                               completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(group);
    
    //
    // Validating Recipient User
    //
    if (!group.objectId) {
        
        NSString *message = NSLocalizedString(@"Parameter Group object invalid or nil. Please retrieve object data from the server and try again..", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorRecipientInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:group.objectId forObject:self];

    return [self startListeningToMessagesFromTopic:formattedTopic completion:completion];
}


- (void)startListeningToMessagesFromDevice:(nonnull MASDevice *)device
                                completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion
{
    NSParameterAssert(device);
    
    //
    // Validating Recipient User
    //
    if (!device.objectId) {
        
        NSString *message = NSLocalizedString(@"Parameter Device object invalid or nil. Please retrieve object data from the server and try again..", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorRecipientInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:device.objectId forObject:self];
    
    return [self startListeningToMessagesFromTopic:formattedTopic completion:completion];
}


- (void)startListeningToMessagesFromTopic:(NSString *)topic
                               completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(topic);
    
    //
    // Validate if is CurrentUser calling this method
    //
    if (!self.isCurrentUser)
    {
        //
        // Error
        //
        NSString *message = NSLocalizedString(@"Unauthenticated user", @"unauthenticated user");
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
            code:MASConnectaErrorUserNotAuthenticated
            userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        //
        // Notify
        //
        if (completion) completion(NO, localizedError);
    
        return;
    }
    
    
    //
    // Validating Sender User (CurrentUser)
    //
    if (!self.objectId) {
        
        NSString *message = NSLocalizedString(@"Current user invalid or nil. Please retrieve user data from the server and try again.", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorUserInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }

    
    //
    // Check if topicQueue exist, if not empty the queue
    //
    if (!self.topicQueue) self.topicQueue = [[NSMutableArray alloc] init];
    
    //
    // Format Topic Structure
    //
    __block NSString *formattedTopic = topic; //[NSString structureTopic:topic forObject:self];
    
    //
    // Queue the Topic
    //
    [self.topicQueue addObject:formattedTopic];

    //
    // Not Connected
    //
    if (![MASMQTTClient sharedClient].connected)
    {
        //
        // Set the username and password for the connection
        //
        [[MASMQTTClient sharedClient] setUsername:self.objectId Password:self.accessToken];
        
        
        //
        // Connect the MQTTClient with the Broker / Gateway
        //
        [[MASMQTTClient sharedClient] connectToHost:[MASConfiguration currentConfiguration].gatewayHostName withTLS:YES completionHandler:^(MQTTConnectionReturnCode code)
        {
            //
            // Accepted
            //
            if (code == ConnectionAccepted)
            {
                //
                // Iterate all the topics
                //
                for (NSString *queueTopic in self.topicQueue) {
                    
                    //
                    // Subscribe to a topic
                    //
                    [[MASMQTTClient sharedClient] subscribeToTopic:queueTopic withCompletionHandler:^(NSArray *grantedQos)
                    {
                        NSOrderedSet *availableQoS = [NSOrderedSet orderedSetWithArray:@[@0,@1,@2]];
                        NSOrderedSet *receivedQoS = [NSOrderedSet orderedSetWithArray:grantedQos];
                        
                        //
                        // If the received QoS is within the availables QoS
                        //
                        if (![receivedQoS isSubsetOfOrderedSet:availableQoS])
                        {
                            //
                            // Failure
                            //
                            NSString *message = NSLocalizedString(@"Error Subscribing to Topic", @"Error Subscribing to topic");
                            NSString *fullMessage = [NSString stringWithFormat:@"%@: %@",message,grantedQos];
                            NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                code:MASConnectaErrorSubscribingMQTT
                                userInfo:@{NSLocalizedDescriptionKey : fullMessage}];
                            
                            //
                            // Notify
                            //
                            if (completion) completion(NO, localizedError);
                        }
                        
                        //
                        // If it is NOT within the available QoS
                        //
                        else
                        {
                            //
                            // Notify
                            //
                            if (completion) completion(YES, nil);
                        }
                    }];
                }
                self.topicQueue = [[NSMutableArray alloc] init];
            }
            
            //
            // Not Accepted
            //
            else
            {
                //
                // Connection failured but mosquitto will automatically reconnect
                //
                DLog(@"Connection Failed with MQTT Server");
                
                NSString *message = NSLocalizedString(@"Connection Failed with MQTT Server", @"Connection Failed with MQTT Server");
                NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                    code:MASConnectaErrorConnectingMQTT
                    userInfo:@{NSLocalizedDescriptionKey : message}];
                
                //
                // Notify
                //
                if (completion) completion(NO, localizedError);
            }
        }];
    }
    
    //
    // Already Connected
    //
    else
    {
        //
        // Iterate the topics
        //
        for (NSString *queueTopic in self.topicQueue)
        {
            //
            // Subscribe to a Topic
            //
            [[MASMQTTClient sharedClient] subscribeToTopic:queueTopic withCompletionHandler:^(NSArray *grantedQos)
            {
                NSOrderedSet *availableQoS = [NSOrderedSet orderedSetWithArray:@[@0,@1,@2]];
                NSOrderedSet *receivedQoS = [NSOrderedSet orderedSetWithArray:grantedQos];
                
                //
                // If received QoS is contained within the available QoS
                //
                if (![receivedQoS isSubsetOfOrderedSet:availableQoS])
                {
                    //
                    // Failure
                    //
                    NSString *message = NSLocalizedString(@"Error Subscribing to Topic", @"Error Subscribing to topic");
                    NSString *fullMessage = [NSString stringWithFormat:@"%@: %@",message,grantedQos];
                    NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                        code:MASConnectaErrorSubscribingMQTT
                        userInfo:@{ NSLocalizedDescriptionKey : fullMessage }];
                    
                    //
                    // Notify
                    //
                    if (completion) completion(NO,localizedError);
                }
                
                //
                // Received QoS is NOT within the available QoS
                //
                else
                {
                    //
                    // Notify
                    //
                    if (completion) completion(YES,nil);
                }
            }];
        }
        
        self.topicQueue = [[NSMutableArray alloc] init];
    }
}


- (void)startListeningToMyMessages:(void (^)(BOOL success, NSError *error))completion
{
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:self.objectId forObject:self];

    [self startListeningToMessagesFromTopic:formattedTopic completion:completion];
}


# pragma mark - Stop Listening

- (void)stopListeningToMessagesFromGroup:(MASGroup *)group
                              completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(group);
    
    //
    // Validating Recipient User
    //
    if (!group.objectId) {
        
        NSString *message = NSLocalizedString(@"Parameter Group object invalid or nil. Please retrieve object data from the server and try again..", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorRecipientInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:group.objectId forObject:self];

    [self stopListeningToMessagesFromTopic:formattedTopic completion:completion];
}


- (void)stopListeningToMessagesFromDevice:(MASDevice *)device
                               completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(device);
    
    //
    // Validating Recipient User
    //
    if (!device.objectId) {
        
        NSString *message = NSLocalizedString(@"Parameter Device object invalid or nil. Please retrieve object data from the server and try again..", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorRecipientInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:device.objectId forObject:self];
    
    [self stopListeningToMessagesFromTopic:formattedTopic completion:completion];
}


- (void)stopListeningToMessagesFromTopic:(NSString *)topic
                              completion:(void (^)(BOOL success, NSError *error))completion
{
    NSParameterAssert(topic);
    
    //
    // Validate if is CurrentUser calling this method
    //
    if (!self.isCurrentUser)
    {
        //
        // Error
        //
        NSString *message = NSLocalizedString(@"Unauthenticated user", @"unauthenticated user");
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
            code:MASConnectaErrorUserNotAuthenticated
            userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        //
        // Notify
        //
        if (completion) completion(NO, localizedError);
        
        return;
    }
    
    
    //
    // Validating Sender User (CurrentUser)
    //
    if (!self.objectId) {
        
        NSString *message = NSLocalizedString(@"Current user invalid or nil. Please retrieve user data from the server and try again.", nil);
        NSError *localizedError = [NSError errorWithDomain:kSDKErrorDomain
                                                      code:MASConnectaErrorUserInvalidOrNil
                                                  userInfo:@{ NSLocalizedDescriptionKey : message }];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    
    //
    // Subscribe to a Topic
    //
    [[MASMQTTClient sharedClient] unsubscribeFromTopic:topic withCompletionHandler:nil];
    
    //
    // Notify
    //
    if (completion) completion(YES, nil);
}

- (void)stopListeningToMyMessages:(void (^)(BOOL success, NSError *error))completion
{
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:self.objectId forObject:self];

    [self stopListeningToMessagesFromTopic:formattedTopic completion:completion];
}


# pragma mark - Properties

- (NSMutableArray *)messageQueue
{
    return objc_getAssociatedObject(self, &messageQueuePropertyKey);
}


- (void)setMessageQueue:(NSMutableArray *)messageQueue
{
    objc_setAssociatedObject(self, &messageQueuePropertyKey, messageQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSMutableArray *)topicQueue
{
    return objc_getAssociatedObject(self, &topicQueuePropertyKey);
}


- (void)setTopicQueue:(NSMutableArray *)topicQueue
{
    objc_setAssociatedObject(self, &topicQueuePropertyKey, topicQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
