//
//  TestBindings.m
//  FTAuth-Unit-Tests
//
//  Created by Dillon Nys on 2/5/21.
//

#import <XCTest/XCTest.h>
#import <FTAuth/FTAuth-Swift.h>

@interface TestBindings : XCTestCase

@end

@implementation TestBindings

- (void)testBindings {
    XCTAssert(true);
    return;
    
    FTAuthClient *client = [FTAuthClient shared];
    
    NSError *error;
    [client initializeAndReturnError:&error];
    [client loginWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {}];
    [client logout];
    
    Keystore *keystore = [[Keystore alloc] init];
    NSData *value = [keystore get:nil error:&error];
    NSLog(@"Received value: %@", value); // silence warning
    [keystore save:nil value:nil error:&error];
    [keystore delete:nil error:&error];
    [keystore clear:&error];
}

@end
