//
//  MASUser+Connecta.m
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASUser+Connecta.h"

#import <objc/runtime.h> //Used for the dynamic getter and setter inside a Category.
#import "MASConnectaConstantsPrivate.h"
#import "NSError+MASConnectaPrivate.h"

static void *messageQueuePropertyKey;
static void *topicQueuePropertyKey;


@implementation MASUser (Connecta)


# pragma mark - Public methods

- (BOOL)validateParameters:(NSArray *)parameters withError:(NSError **)error
{
    for (NSObject *param in parameters) {
        
        if ([param isKindOfClass:[NSString class]]) {
            
            if ([(NSString *)param length] < 1) {
               
                if (error)
                {
                    *error = [NSError errorForConnectaErrorCode:MASConnectaErrorParameterInvalidOrNil errorDomain:kSDKErrorDomain];
                }
                
                return NO;
            }

        }else if ([param isKindOfClass:[MASObject class]]) {
            
            if (![(MASObject *)param objectId]) {
                
                if (error)
                {
                    *error = [NSError errorForConnectaErrorCode:MASConnectaErrorRecipientInvalidOrNil errorDomain:kSDKErrorDomain];
                }
                
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
    
    if (!message || !user) {
        
        localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorParameterInvalidOrNil errorDomain:kSDKErrorDomain];
        
        if (completion) {
            
            completion (NO, localizedError);
        }
        
        return;
    }
    
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
    
    if (!message || !user || !topic) {
        
        localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorParameterInvalidOrNil errorDomain:kSDKErrorDomain];
        
        if (completion) {
            
            completion (NO, localizedError);
        }
        
        return;
    }
    
    if ([self validateParameters:@[message,user,topic] withError:&localizedError]) {
        
        [self sendMessage:message toObject:user onTopic:topic completion:completion];
        
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
        
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorMessageObjectNotSupported errorDomain:kSDKErrorDomain];
        
        completion(NO, localizedError);
        
        return;
    }
    
    //
    // Validating Sender User (CurrentUser)
    //
    if (!self.objectId) {
        
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserInvalidOrNil errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Check if the session is locked
    //
    if (self.isSessionLocked)
    {
        
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserSessionIsCurrentlyLocked errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    
    //
    // Validating Recipient User
    //
    if (!object.objectId) {

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorRecipientInvalidOrNil errorDomain:kSDKErrorDomain];
        
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
        
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserNotAuthenticated errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Check if the session is locked
    //
    if (self.isSessionLocked)
    {

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserSessionIsCurrentlyLocked errorDomain:kSDKErrorDomain];
        
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
                
                NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorConnectingMQTT errorDomain:kSDKErrorDomain];
                
                
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
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserNotAuthenticated errorDomain:kSDKErrorDomain];
        
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

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserInvalidOrNil errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }

    //
    // Check if the session is locked
    //
    if (self.isSessionLocked)
    {

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserSessionIsCurrentlyLocked errorDomain:kSDKErrorDomain];
        
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
                            NSError *localizedError = [NSError errorForConnectaMQTTSubscriptionWithQoS:grantedQos];
                            
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
                
                NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorConnectingMQTT errorDomain:kSDKErrorDomain];
                
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
                    NSError *localizedError = [NSError errorForConnectaMQTTSubscriptionWithQoS:grantedQos];
                    
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
    
    formattedTopic = [[formattedTopic componentsSeparatedByString:@"/custom"] firstObject];
    
    formattedTopic = [NSString stringWithFormat:@"%@/custom/#",formattedTopic];

    [self startListeningToMessagesFromTopic:formattedTopic completion:completion];
}


# pragma mark - Stop Listening

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
        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserNotAuthenticated errorDomain:kSDKErrorDomain];
        
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

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserInvalidOrNil errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Check if the session is locked
    //
    if (self.isSessionLocked)
    {

        NSError *localizedError = [NSError errorForConnectaErrorCode:MASConnectaErrorUserSessionIsCurrentlyLocked errorDomain:kSDKErrorDomain];
        
        if (completion) completion(NO,localizedError);
        
        return;
    }
    
    //
    // Subscribe to a Topic
    //
    [[MASMQTTClient sharedClient] unsubscribeFromTopic:topic withCompletionHandler:^(BOOL completed, NSError * _Nullable error) {
        
        //
        // Notify
        //
        if (completion) completion(completed, error);

    }];
    
}

- (void)stopListeningToMyMessages:(void (^)(BOOL success, NSError *error))completion
{
    //
    // Applying format to Topic and Message
    //
    NSString *formattedTopic = [NSString structureTopic:self.objectId forObject:self];
    
    formattedTopic = [[formattedTopic componentsSeparatedByString:@"/custom"] firstObject];
    
    formattedTopic = [NSString stringWithFormat:@"%@/custom/#",formattedTopic];

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
