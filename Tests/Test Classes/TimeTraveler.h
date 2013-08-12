//
//  TimeTraveler.h
//  Kiwi
//
//  Created by Daniel Dyba on 8/8/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface TimeTraveler : AFHTTPClient

@property (nonatomic, retain) NSString *message;

- (id)initWithMessage:(NSString *)aMessage andURL:(NSURL *)aURL;
- (void)sendMessage:(NSString *)aMessage
          afterDelay:(NSTimeInterval)aTimeInterval;
- (void)fetchAsynchronousUsingMessage:(NSString *)aMessage;

@end
