//
//  TimeTraveler.m
//  Kiwi
//
//  Created by Daniel Dyba on 8/8/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "TimeTraveler.h"

@implementation TimeTraveler

- (id)initWithMessage:(NSString *)aMessage andURL:(NSURL *)aURL {
    self = [super initWithBaseURL:aURL];
    
    if (self)
        _message = aMessage;
    
    return self;
}

- (void)fetchAsynchronousUsingMessage:(NSString *)aMessage {
    [self getPath:@"example.json"
       parameters:nil
          success: ^(AFHTTPRequestOperation *operation, id responseObject) {
              self.message = aMessage;
              NSLog(@"Success!");
          }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Failure!");
          }];
}

- (void)sendMessage:(NSString *)aMessage
          afterDelay:(NSTimeInterval)aTimerInterval {
    [self performSelector:@selector(setMessage:)
               withObject:aMessage
               afterDelay:aTimerInterval];
}

@end
