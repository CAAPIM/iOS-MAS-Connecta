//
//  NSString+MASConnecta.h
//  MASConnecta
//
//  Created by Britton Katnich on 2016-03-04.
//  Copyright © 2016 CA Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MASConnecta)


# pragma mark - Public

/**
 *
 */
+ (NSString *)payloadWithString:(NSString *)message sentTime:(NSDate *)sentTime andObject:(MASObject *)masObject;



/**
 *  Message Payload Builder
 *
 *  @param message        <#message description#>
 *  @param type           <#type description#>
 *  @param sentTime       <#sentTime description#>
 *  @param masObject      <#masObject description#>
 *  @param structureTopic <#structureTopic description#>
 *  @param topic          <#topic description#>
 *  @param masObject      <#masObject description#>
 *
 *  @return The formatted Message
 */
+ (NSString *)payloadWithData:(NSData *)message type:(NSString *)type sentTime:(NSDate *)sentTime object:(MASObject *)masObject andTopic:(NSString *)topic;



/**
 *
 */
+ (NSString *)structureTopic:(NSString *)topic forObject:(MASObject *)masObject;

@end
