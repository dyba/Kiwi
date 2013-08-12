//
//  KWProbePoller.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWProbePoller.h"
#import <CoreFoundation/CoreFoundation.h>

@interface KWTimeout : NSObject

@property (nonatomic, strong) NSDate *timeoutDate;

@end

@implementation KWTimeout

- (id)initWithTimeout:(NSTimeInterval)timeout
{
    self = [super init];
    
    if (self) {
        _timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    }
    
    return self;
}


- (BOOL)hasTimedOut {
    return [self.timeoutDate timeIntervalSinceDate:[NSDate date]] < 0;
}

@end


@interface KWProbePoller()

@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) NSTimeInterval delayInterval;
@property (nonatomic, assign) BOOL shouldWait;

@end

@implementation KWProbePoller

- (id)initWithTimeout:(NSTimeInterval)theTimeout
                delay:(NSTimeInterval)theDelay
           shouldWait:(BOOL)wait {
    self = [super init];
    if (self) {
        _timeoutInterval = theTimeout;
        _delayInterval = theDelay;
        _shouldWait = wait;
    }
    return self;
}

- (BOOL)check:(id<KWProbe>)probe {
    __block BOOL probeIsSatisfied = NO;
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:probe
                                                    selector:@selector(sample)
                                                    userInfo:nil
                                                     repeats:YES];
    CFRunLoopObserverRef probeIsSatisfiedObserver =
    CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       true,
                                       0,
                                       ^(CFRunLoopObserverRef observer,
                                         CFRunLoopActivity activity) {
                                            if ([probe isSatisfied]) {
                                                probeIsSatisfied = YES;
                                            };
                                        });
    CFRunLoopAddObserver([currentRunLoop getCFRunLoop],
                         probeIsSatisfiedObserver,
                         kCFRunLoopDefaultMode);
    [currentRunLoop addTimer:timer
                     forMode:NSDefaultRunLoopMode];
    
    KWTimeout *timeout = [[KWTimeout alloc] initWithTimeout:self.timeoutInterval];
    while ((self.shouldWait || probeIsSatisfied) && [currentRunLoop runMode:NSDefaultRunLoopMode
                                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:self.timeoutInterval]]) {
        if ([timeout hasTimedOut]) {
            return [probe isSatisfied];
        }
    }
    
    return YES;
}

@end
