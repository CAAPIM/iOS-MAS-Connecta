//
//  AppDelegate.m
//  ConnectaApp
//
//  Created by Luis Sanches on 2015-07-09.
//  Copyright (c) 2015 CA Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <MASFoundation/MASFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MAS setGatewayNetworkActivityLogging:YES];
    
//    [MAS start:^(BOOL completion, NSError *error) {
//        
//        NSLog(@"%d",completion);
//        
//        NSLog(@"\n\n(START) called with completion: %@ or error: %@\n\n",
//             (completion ? @"Yes" : @"No"), error);
//        
//        if(error)
//        {
//
//            NSLog(@"%@",error.localizedDescription);
//            
//            return;
//        }
//
//        else {
//
////            [MASUser authenticateWithUserName:@"jkirk" password:@"7layer" completion:^(MASUser *user, NSError *error) {
////                
////                if (user) {
////                    
////                    NSLog(@"Success user authentication");
////                }
////                else {
////                    
////                    NSLog(@"Failed user authentication");
////                }
////            }];
//
//        }
//        
////        [MAS deregisterWithCompletion:^(BOOL completed, NSError *error) {
////            
////            NSLog(@"%d",completed);
////        }];
//
//    }];

    return YES;
}

@end
