//
//  MASMQTTClientTests.m
//  SampleConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
//#import <MASConnecta/MASConnecta.h>
//#import <MASFoundation/MASFoundation.h>

#define kHost   @"mascademo.dev.ca.com"
//#define kHost   @"mat-staging.ca.com"
//#define kHost   @"mat-demo.l7tech.com"
//#define kHost   @"qamosquitto.l7tech.com"

#define rndValue  (((float)arc4random()/0x100000000)*10000)

static NSString * const samplePayload = @"This is a test payload !!!";
static NSString * const sampleTopic = @"SampleTopic";

@interface MASMQTTClientTests : XCTestCase

//@property (nonatomic, strong) MASMQTTClient *client;

@end

@implementation MASMQTTClientTests

/**
 *  Initial Setup to be used during tests
 */
- (void)setUp
{
    [super setUp];
    
//    self.client = [MASMQTTClient sharedClient];
//
//    if (![MASMQTTClient sharedClient].connected) {
//        
//        [[MASMQTTClient sharedClient] connectToHost:kHost withTLS:NO completionHandler:nil];
//    }
    
}


/**
 *  TearDown any object
 */
- (void)tearDown
{
    [super tearDown];
    
//    self.client = nil;
}


/**
 *  Performance sample test
 */
- (void)PerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


///**
// *  Test the Init method of MQTTClient
// */
//- (void)testInit
//{
//    self.client = [[MASMQTTClient alloc] init];
//    XCTAssert(self.client, @"Pass");
//}
//
//
///**
// *  Test the sharedClient singleton
// */
//- (void)testSharedClient
//{
//    self.client = [MASMQTTClient sharedClient];
//    XCTAssert(self.client, @"Pass");
//}
//
//
///**
// *  Test the Init with ClientId and Clean Session
// */
//- (void)testInitWithClientIdAndCleanSession
//{
//    self.client = [[MASMQTTClient alloc] initWithClientId:@"sampleClientId" cleanSession:YES];
//    XCTAssert(self.client, @"Pass");
//}
//
//
///**
// *  Test the Connection Aceept scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testConnectionAccepted
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(code == ConnectionAccepted, @"Connection with Host was accepted");
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Connection Failure scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testConnectionFailed
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(code != ConnectionRefusedBadUserNameOrPassword, @"Connection with Host was failed");
//        
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Disconnection scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)Disconnect
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    if (!weakSelf.client.connected) {
//        
//        [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//            
//            XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//            
//            [weakSelf.client disconnectWithCompletionHandler:^(NSUInteger code) {
//                
//                XCTAssertFalse(weakSelf.client.connected, @"Client Disconnected");
//                
//                [expectation fulfill];
//            }];
//        }];
//    }
//    else {
//
//        [weakSelf.client disconnectWithCompletionHandler:^(NSUInteger code) {
//            
//            XCTAssertFalse(weakSelf.client.connected, @"Client Disconnected");
//            
//            [expectation fulfill];
//        }];
//
//    }
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe. Default QoS will be 0
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testSubscribe
//{
//    NSString *sampleTopic = @"testSubscribe";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withCompletionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe with QoS 0 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testSubscribeAtMostOnce
//{
//    NSString *sampleTopic = @"testSubscribeAtMostOnce";
//
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:AtMostOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe with QoS 1 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testSubscribeAtLeastOnce
//{
//    NSString *sampleTopic = @"testSubscribeAtLeastOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:AtLeastOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe with QoS 2 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testSubscribeExactlyOnce
//{
//    NSString *sampleTopic = @"testSubscribeExactlyOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:ExactlyOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Unsubscribe.
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testUnsubscribe
//{
//    NSString *sampleTopic = @"testUnsubscribe";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client unsubscribeFromTopic:sampleTopic withCompletionHandler:^{
//            
//            XCTAssertTrue(1==1, @"Client Unsubscribed");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Publish with QoS 0 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testPublishAtMostOnce
//{
//     NSString *sampleTopic = @"testPublishAtMostOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withCompletionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//                
//                [expectation fulfill];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Publish with QoS 1 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testPublishAtLeastOnce
//{
//    NSString *sampleTopic = @"testPublishAtLeastOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withCompletionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:AtLeastOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//                
//                [expectation fulfill];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the Publish with QoS 2 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testPublishExactlyOnce
//{
//    NSString *sampleTopic = @"testPublishExactlyOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withCompletionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:ExactlyOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//                
//                [expectation fulfill];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the MessageHandler with QoS 0 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testMessageHandlerAtMostOnce
//{
//    NSString *sampleTopic = @"testMessageHandlerAtMostOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:AtMostOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//                
//                [weakSelf.client setMessageHandler:^(MASMQTTMessage *message) {
//                    
//                    XCTAssertTrue([message.payloadString isEqualToString:samplePayload], @"Sample Payload");
//                    
//                    [expectation fulfill];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the MessageHandler with QoS 1 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testMessageHandlerAtLeastOnce
//{
//    NSString *sampleTopic = @"testMessageHandlerAtLeastOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:AtLeastOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:AtLeastOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//                
//                [expectation fulfill];
//            }];
//            
//            [weakSelf.client setMessageHandler:^(MASMQTTMessage *message) {
//                
//                XCTAssertTrue([message.payloadString isEqualToString:samplePayload], @"Sample Payload");
//            }];
//
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}
//
//
///**
// *  Test the MessageHandler with QoS 2 scenario
// *
// *  NOTE: A broker must be running as localhost for this test to pass
// */
//- (void)testMessageHandlerExactlyOnce
//{
//    NSString *sampleTopic = @"testMessageHandlerExactlyOnce";
//    
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//    
//    int intRndValue = (int)(rndValue + 0.5);
//    
//    NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//    
//    weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//    
//    [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//        
//        XCTAssertTrue(weakSelf.client.connected, @"Client Connected");
//        
//        [weakSelf.client subscribeToTopic:sampleTopic withQos:ExactlyOnce completionHandler:^(NSArray *grantedQos) {
//            
//            XCTAssertTrue([grantedQos count] > 0, @"Client Subscribed");
//            
//            [weakSelf.client publishString:samplePayload toTopic:sampleTopic withQos:ExactlyOnce retain:NO completionHandler:^(int mid) {
//                
//                XCTAssertTrue(mid > 0,@"Payload sent");
//
//                [expectation fulfill];
//            }];
//            
//            [weakSelf.client setMessageHandler:^(MASMQTTMessage *message) {
//                
//                XCTAssertTrue([message.payloadString isEqualToString:samplePayload], @"Sample Payload");
//                
//            }];
//
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:40.0 handler:nil];
//}

@end
