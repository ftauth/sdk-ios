//
//  TestBindings.m
//  FTAuth-Unit-Tests
//
//  Created by Dillon Nys on 2/5/21.
//

#import <XCTest/XCTest.h>
#import <FTAuth/FTAuth-Swift.h>

@interface MyLogger: NSObject <FTAuthLogger>

- (void)debug:(NSString *)log;
- (void)warn:(NSString *)log;
- (void)info:(NSString *)log;
- (void)error:(NSString *)log;

@end

@implementation MyLogger

- (void)debug:(NSString *)log {}
- (void)warn:(NSString *)log {}
- (void)info:(NSString *)log {}
- (void)error:(NSString *)log {}

@end

@interface TestBindings : XCTestCase

@end

@implementation TestBindings

- (void)testBindings {
    XCTAssert(true);
    return;
    
    // FTAuthLogger
    MyLogger *logger = [[MyLogger alloc] init];
    XCTAssert([logger conformsToProtocol:@protocol(FTAuthLogger)]);
    
    // FTAuthConfig
    FTAuthConfig *config = [[FTAuthConfig alloc] initWithGatewayURL:@"" clientID:@"" clientSecret:@"" clientType:@"" redirectURI:@"" scopes:@[] timeout:30];
    
    // FTAuthClient
    FTAuthClient *client = [FTAuthClient shared];
    
    NSError *error;
    [client initializeWithLogger:logger error:&error];
    [client initializeWithConfig:config logger:logger error:&error];
    [client initializeWithURL:[NSURL URLWithString:@""] logger:logger error:&error];
    [client initializeWithJSON:[@"" dataUsingEncoding:NSUTF8StringEncoding] logger:logger error:&error];
    [client loginWithProvider:ProviderFtauth completion:^(User * _Nullable user, NSError * _Nullable error) {}];
    [client logout];
    
    // Keystore
    Keystore *keystore = [[Keystore alloc] init];
    NSData *value = [keystore get:nil error:&error];
    [keystore save:nil value:nil error:&error];
    [keystore delete:nil error:&error];
    [keystore clear:&error];
    
    // SecurityConfiguration
    SecurityConfiguration* secConf = [[SecurityConfiguration alloc] initWithHost:@"" trustPublicPKI:YES];
    [secConf addIntermediatePEMWithData:nil error:&error];
    [secConf addIntermediateASN1WithData:nil error:&error];
    SecurityConfiguration *defaultConf = [client getDefaultSecurityConfiguration];
    [client setDefaultSecurityConfiguration:defaultConf];
}

@end
