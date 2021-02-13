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
    
    // FTAuthClient
    FTAuthClient *client = [FTAuthClient shared];
    
    NSError *error;
    [client initializeAndReturnError:&error];
    [client loginWithCompletion:^(User * _Nullable user, NSError * _Nullable error) {}];
    [client logout];
    
    // Keystore
    Keystore *keystore = [[Keystore alloc] init];
    NSData *value = [keystore get:nil error:&error];
    [keystore save:nil value:nil error:&error];
    [keystore delete:nil error:&error];
    [keystore clear:&error];
    
    // SecurityConfiguration
    SecurityConfiguration* secConf = [[SecurityConfiguration alloc] initWithHost:@"" trustSystemRoots:NO];
    [secConf addIntermediatePEMWithData:nil error:&error];
    [secConf addIntermediateASN1WithData:nil error:&error];
    SecurityConfiguration *defaultConf = [client getDefaultSecurityConfiguration];
    [client setDefaultSecurityConfiguration:defaultConf];
    
    // FTAuthConfig
    FTAuthConfig *config = [[FTAuthConfig alloc] initWithGatewayURL:@"" clientID:@"" clientSecret:@"" clientType:@"" redirectURI:@"" scopes:@[] timeout:30];
    [client initializeWithConfig:config error:&error];
}

@end
