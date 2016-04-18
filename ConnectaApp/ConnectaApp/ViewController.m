//
//  ViewController.m
//  SampleApp
//
//  Created by Luis Sanches on 2015-05-14.
//  Copyright (c) 2015 CA Technologies. All rights reserved.
//

#import "ViewController.h"
#import <MASConnecta/MASConnecta.h>
#import <MASConnecta/MASUser+Connecta.h>
#import <MASFoundation/MASFoundation.h>

@interface ViewController () <MASConnectaMessagingClientDelegate>

@property (nonatomic) MASMQTTClient *client;

@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UITextView *messageBoard;
@property (nonatomic, weak) IBOutlet UITextField *host;
@property (nonatomic, weak) IBOutlet UITextField *subscribe;
@property (nonatomic, weak) IBOutlet UITextField *publish;
@property (nonatomic, weak) IBOutlet UITextField *subQoS;
@property (nonatomic, weak) IBOutlet UITextField *pubQoS;
@property (nonatomic, weak) IBOutlet UISwitch *tls;

@property (nonatomic, strong) MASUser *currentUser;
@end

@implementation ViewController

#pragma mark - ViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MAS start:^(BOOL completed, NSError *error) {
        
        [MASUser loginWithUserName:@"jkirk" password:@"CAapiGW" completion:^(BOOL completed, NSError *error) {
            
            //
            //1- Create the MQTT client instance (Using TLS or not)
            //
            self.client = [MASMQTTClient sharedClient];
            
            NSLog(@"version: %@",[MASMQTTClient version]);
            
            
            //
            // 2- Define the handler that will be called when MQTT messages are received by the client. Other options are Delegation () or Notification (MASConnectaOperationDidReceiveMessageNotification)
            //
            __weak typeof(self) weakSelf = self;
            [self.client setMessageHandler:^(MASMQTTMessage *message) {
                
                // the MQTTClientDelegate methods are called from a GCD queue.
                // Any update to the UI must be done on the main queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Update MessageBoard
                    weakSelf.messageBoard.text = [NSString stringWithFormat:@"%@ \n %@",message.payloadString, weakSelf.messageBoard.text];
                });
            }];
            
            
            //
            // 3- Define the handler that will be called when MQTT broker disconnect the MQTT client
            //
            __block typeof(self.status) blockStatus = self.status;
            [self.client setDisconnectionHandler:^(NSUInteger code) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    blockStatus.textColor = [UIColor redColor];
                    blockStatus.text = NSLocalizedString(@"disconnected",);
                });
                
            }];
            
            
            //
            // 4- Connect to MQTT broker
            //
            //    [self connect:self];
            
            
            //
            // 5- Add Observers for MASConnecta Notifications
            //
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onConnectedNotification:)
                                                         name:MASConnectaOperationDidConnectNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onDisconnectedNotification:)
                                                         name:MASConnectaOperationDidDisconnectNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(onMessageReceivedNotification:)
                                                         name:MASConnectaOperationDidReceiveMessageNotification
                                                       object:nil];
            
            // Activate Debug Mode
            [self.client setDebugMode:YES];
            
            
            // Set Delegation
            [self.client setDelegate:self];
            

        }];
    }];

}


#pragma mark - IBActions

/**
 *  This method will perform the connection in case it is not yet done. It will perform the disconnection otherwise.
 */

- (IBAction)connect:(id)sender
{
    __block typeof(self.status) blockStatus = self.status;
    __weak typeof(self) weakSelf = self;
    
    if (!self.client.connected) {

        // connect the MQTT client
        [self.client connectToHost:self.host.text withTLS:YES
                 completionHandler:^(MQTTConnectionReturnCode code) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (code == ConnectionAccepted) {
                    
                    blockStatus.textColor = [UIColor blueColor];
                    blockStatus.text = NSLocalizedString(@"connected",@"connected");
                }
                else {
                    blockStatus.textColor = [UIColor redColor];
                    blockStatus.text = NSLocalizedString(@"disconnected",@"disconnected");
                }
            
                weakSelf.messageBoard.text = [NSString stringWithFormat:@"%@ \n %@",MQTTConnectionReturnMessage[code], weakSelf.messageBoard.text];
            });
        }];
    }
    else {
        
        // disconnect the MQTT client
        [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
            
            // The client is disconnected when this completion handler is called
            NSLog(@"MQTT is disconnected");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                blockStatus.textColor = [UIColor redColor];
                blockStatus.text = NSLocalizedString(@"disconnected",@"disconnected");
            });
        }];
    }
}


/**
 *  Subscribe the client to the topic specified on the UI
 */

- (IBAction)subscribe:(id)sender
{
    
//    [MASUser subscribeToTopic:self.subscribe.text];
    
    //Subscribe to the topic with custom QoS
    __weak typeof(self) weakSelf = self;

    [self.client subscribeToTopic:self.subscribe.text withQos:[self.subQoS.text integerValue] completionHandler:^(NSArray *grantedQos) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *message = [NSString stringWithFormat:@"subscribed to topic: %@", weakSelf.subscribe.text];

            //Update MessageBoard
            weakSelf.messageBoard.text = [NSString stringWithFormat:@"%@ \n %@",message, weakSelf.messageBoard.text];
        });

        NSLog(@"subscribed to topic %@", self.subscribe.text);
    }];
}


/**
 *  Unsubscribe the client from the topic specified on the UI
 */

- (IBAction)unsubscribe:(id)sender
{
    //Subscribe to the topic with custom QoS
    __weak typeof(self) weakSelf = self;
    
    [self.client unsubscribeFromTopic:self.subscribe.text withCompletionHandler:^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = [NSString stringWithFormat:@"unsubscribed from topic: %@", weakSelf.subscribe.text];
            
            //Update MessageBoard
            weakSelf.messageBoard.text = [NSString stringWithFormat:@"%@ \n %@",message, weakSelf.messageBoard.text];
        });
        
        NSLog(@"unsubscribed from topic %@", self.subscribe.text);
    }];
}


/**
 *  Publish the message to the topic specified on the UI
 */

- (IBAction)publish:(id)sender
{
    NSString *payload = self.publish.text;

    if (!self.currentUser) {

        //Just testing methods of MASFoundation
        [MASUser logoffWithCompletion:^(BOOL completed, NSError *error) {
            
            NSLog(@"%d",completed);
            
            //Login in with a different user
            [MASUser loginWithUserName:@"jkirk" password:@"CAapiGW" completion:^(BOOL completed, NSError *error) {
                
                self.currentUser = [MASUser currentUser];
                
                [self.currentUser sendMessage:self.publish.text toTopic:self.subscribe.text completion:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        NSLog(@"Message Sent");
                    }
                    else {
                        
                        NSLog(@"Message Failure with error: %@",error.localizedDescription);
                    }
                }];
            }];
        }];
        

    }
    else {

        [self.currentUser sendMessage:self.publish.text toTopic:self.subscribe.text completion:^(BOOL success, NSError *error) {
            
            if (success) {
                
                NSLog(@"Message Sent");
            }
            else {
                
                NSLog(@"Message Failure with error: %@",error.localizedDescription);
            }
        }];

    }
    
    

    /*
    //Without MASFoundation
    [self.client publishString:payload
                       toTopic:self.subscribe.text
                       withQos:[self.pubQoS.text integerValue]
                        retain:YES
             completionHandler:^(int mid) {
                 
                 NSLog(@"Publishing QoS:%@",self.pubQoS.text);
    }];
    */
}


#pragma mark - Notifications

- (void)onConnectedNotification:(NSNotification *)notification
{
    NSLog(@"Connected Notification Message!");
}


- (void)onDisconnectedNotification:(NSNotification *)notification
{
    NSLog(@"Disconnected Notification Message!");
}


- (void)onMessageReceivedNotification:(NSNotification *)notification
{
    MASMQTTMessage *message = notification.object;
    NSLog(@"%@",[NSString stringWithFormat:@"%@",message.payloadString]);
}


#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - MQTTClient delegate methods

- (void)onConnected:(MQTTConnectionReturnCode)rc
{
    NSLog(@"Connect Delegation Message");
}


- (void)onDisconnect:(MQTTConnectionReturnCode)rc
{
    NSLog(@"Disconnect Delegation Message");
}


- (void)onMessageReceived:(MASMQTTMessage *)message
{
    NSLog(@"Message Received Delegation Message");
}


- (void)onPublishMessage:(NSNumber *)messageId
{
    NSLog(@"Publish Message Delegation Message");
}

@end
