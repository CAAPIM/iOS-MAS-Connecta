//
//  MASUserMessagingTests.m
//  MASConnecta
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

#import "MASUser+Connecta.h"

#define rndValue  (((float)arc4random()/0x100000000)*10000)

#define kHost           @"mascademo.dev.ca.com"
#define kSCIMUser       @"jkirk"
#define kSCIMPassword   @"CAapiGW"

//#define kHost   @"mat-staging.ca.com"
//#define kHost   @"mat-demo.l7tech.com"
//#define kHost   @"qamosquitto.l7tech.com"

static NSString * const samplePayload = @"This is a test payload !!!";
static NSString * const sampleTopic = @"SampleTopic";
static NSString * const sampleGroup = @"ConnectaGroup";
static NSString * const sampleUserId = @"UserId";
static NSString * const sampleDeviceId = @"DeviceId";

@interface MASUserMessagingTests : XCTestCase

//@property (nonatomic, strong) MASUser *user;
//@property (nonatomic, strong) MASMQTTClient *client;

@end

@implementation MASUserMessagingTests

/**
 *  Initial Setup to be used during tests
 */
- (void)setUp
{
    [super setUp];
}


/**
 *  TearDown any object
 */
- (void)tearDown
{
//    self.user = nil;
    [super tearDown];
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

//#pragma mark - Tests for UnAuthenticated User
//
///**
// *  Test the Subscribe To Group with UnAuthenticated User
// */
//- (void)testSubscribeToGroupWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//        
//        [user startListeningToMesasgesFromGroup:sampleGroup completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe To Topic with UnAuthenticated User
// */
//- (void)testSubscribeToTopicWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//
//        [user startListeningToMessagesFromTopic:sampleTopic completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//#warning Disable
///**
// *  Test the Send Message to a User with UnAuthenticated User
// */
//- (void)SendMessageToUserWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//
//        [user sendMessage:samplePayload toUser:user completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Send Message to a Group with UnAuthenticated User
// */
//- (void)testSendMessageToGroupWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//
//        [user sendMessage:samplePayload toGroup:sampleGroup completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//                   
//#warning Disable
///**
// *  Test the Send Message to a Device with UnAuthenticated User
// */
//- (void)SendMessageToDeviceWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//
//        MASDevice *device = [[MASDevice alloc] initWithCoder:nil];
//        
//        [user sendMessage:samplePayload toDevice:device completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}


/**
 *  Test the Send Message to a Topic with UnAuthenticated User
 */
//- (void)testSendMessageToTopicWithUnAuthenticatedUser
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
//        MASUser *user = [[MASUser alloc] initWithCoder:nil];
//
//        [user sendMessage:samplePayload toTopic:sampleTopic completion:^(BOOL success, NSError *error) {
//            
//            XCTAssertFalse(success, @"Pass");
//            
//            [expectation fulfill];
//        }];
//    }];
//
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}


//#pragma mark - Tests for Authenticated User
//
///**
// *  Test the Subscribe To Group with Authenticated User
// */
//- (void)testSubscribeToGroupWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(user, @"Pass");
//                    
//                    [user startListeningToMesasgesFromGroup:sampleGroup completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//
//    }];
//
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Subscribe To Topic with Authenticated User
// */
//- (void)testSubscribeToTopicWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(user, @"Pass");
//                    
//                    [user startListeningToMessagesFromTopic:sampleTopic completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Send Message to a User with Authenticated User
// */
//- (void)testSendMessageToUserWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(user, @"Pass");
//                    
//                    [user sendMessage:samplePayload toUser:user completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Send Message to a Group with Authenticated User
// */
//- (void)testSendMessageToGroupWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(user, @"Pass");
//                    
//                    [user sendMessage:samplePayload toGroup:sampleGroup completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//#warning Disable
///**
// *  Test the Send Message to a Device with Authenticated User
// */
//- (void)SendMessageToDeviceWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(completion, @"Pass");
//                    
//                    MASDevice *device = [[MASDevice alloc] initWithCoder:nil];
//                    
//                    [user sendMessage:samplePayload toDevice:device completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//
///**
// *  Test the Send Message to a Topic with Authenticated User
// */
//- (void)testSendMessageToTopicWithAuthenticatedUser
//{
//    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
//    
//    __weak typeof(self) weakSelf = self;
//
//    [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
//        
//        [MAS start:^(BOOL completion, NSError *error) {
//            
//            XCTAssertTrue(completion, @"Pass");
//            
//            int intRndValue = (int)(rndValue + 0.5);
//            
//            NSString *clientID = [NSString stringWithFormat:@"%@_%d",[UIDevice currentDevice].identifierForVendor.UUIDString,intRndValue];
//            
//            weakSelf.client = [[MASMQTTClient alloc] initWithClientId:clientID cleanSession:YES];
//            
//            [weakSelf.client connectToHost:kHost withTLS:NO completionHandler:^(MQTTConnectionReturnCode code) {
//                
//                [MASUser authenticateWithUserName:kSCIMUser password:kSCIMPassword completion:^(MASUser *user, NSError *error) {
//                    
//                    XCTAssertTrue(user, @"Pass");
//                                        
//                    [user sendMessage:samplePayload toTopic:sampleTopic completion:^(BOOL success, NSError *error) {
//                        
//                        XCTAssertTrue(success, @"Pass");
//                        
//                        [expectation fulfill];
//                    }];
//                }];
//            }];
//        }];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10.0 handler:nil];
//}
//
//


@end
