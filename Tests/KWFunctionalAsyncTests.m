//
//  KWFunctionalAsyncTests.m
//  Kiwi
//

#import "Kiwi.h"
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse.h"
#import "TimeTraveler.h"

SPEC_BEGIN(FunctionalAsyncTests)

describe(@"Asynchronous Tests", ^{
    __block TimeTraveler *timeTraveler;
    
    beforeEach(^{
        timeTraveler = [[TimeTraveler alloc] initWithMessage:@"Taking off!"
                                                      andURL:[NSURL URLWithString:@"http://example.com"]];
    });
    
    describe(@"shouldEventually Async Verifier", ^{
        it(@"eventually updates the message after a delay", ^{
            NSString *newMessage = @"I have traveled in time!";
            
            [timeTraveler sendMessage:newMessage afterDelay:0.9];
            
            [[expectFutureValue(timeTraveler.message) shouldEventually] equal:newMessage];
        });
        
        context(@"when using network stubs", ^{
            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFile:@"example.json"
                                                                              contentType:@"text/json"
                                                                             responseTime:0.9];
                    return response;
                }];
            });
            
            it(@"eventually equals the sample response message", ^{
                [timeTraveler fetchAsynchronousUsingMessage:@"I did it!"];

                [[expectFutureValue(timeTraveler.message) shouldEventually] equal:@"I did it!"];
            });
            
            it(@"fails when the sample response message is different from the expected message", ^{
                [timeTraveler fetchAsynchronousUsingMessage:@"I did it!"];

                [[expectFutureValue(timeTraveler.message) shouldNotEventually] equal:@"Taking off!"];
            });
        });
    });
    
    describe(@"shouldEventuallyBeforeTimingOutAfter Async Verifier", ^{        
        it(@"eventually updates the message after a delay", ^{
            NSString *newMessage = @"I have traveled in time!";
            
            [timeTraveler sendMessage:newMessage afterDelay:0.4];
            
            [[expectFutureValue(timeTraveler.message) shouldEventuallyBeforeTimingOutAfter(0.5)] equal:newMessage];
        });
        
        context(@"when using network stubs", ^{
            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFile:@"example.json"
                                                                              contentType:@"text/json"
                                                                             responseTime:0.4];
                    return response;
                }];
            });
            
            it(@"eventually equals the sample response message", ^{
                [timeTraveler fetchAsynchronousUsingMessage:@"I did it!"];

                [[expectFutureValue(timeTraveler.message) shouldEventuallyBeforeTimingOutAfter(0.5)] equal:@"I did it!"];
            });
            
            it(@"fails when the sample response message is different from the expected message", ^{
                [timeTraveler fetchAsynchronousUsingMessage:@"I did it!"];

                [[expectFutureValue(timeTraveler.message) shouldNotEventuallyBeforeTimingOutAfter(0.5)] equal:@"Taking off!"];
            });
        });
    });    
});

SPEC_END
