//
//  AFVDKeychain.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/1/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDKeychain.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import <Security/Security.h>

//Keys
NSString *const kIdentityTokenIdentifier = @"com.apple.%@.UbiquityIdentityToken";
NSString *const kBundleKeyName           = @"CFBundleName";

//Access Token handling
NSString *const kAFVDAccessToken                    = @"userAccessToken";
NSString *const kAFVDAccessTokenExpiry              = @"userAccessTokenExpiry";

@implementation AFVDKeychain

#pragma mark - Init
- (instancetype)init {
    
    self = [super init];
    if(self) {
        
        [self registerForNotifications];
        [self loadiCloudToken];
    }
    return self;
}

#pragma mark - Register for notifications
- (void)registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudAccountAvailabilityChanged:)name:NSUbiquityIdentityDidChangeNotification object:nil];
}

#pragma mark - Access token
- (void)setAccessToken:(NSString *)accessToken andExpiryDate:(NSString *)expiryDate {
    
    _accessToken    = accessToken;
    _expiryDate     = expiryDate;
    [SSKeychain setPassword:accessToken forService:kAFVDAccessToken account:iCloudTokenName()];
    [SSKeychain setPassword:expiryDate forService:kAFVDAccessTokenExpiry account:iCloudTokenName()];

}

- (void)loadAccessToken {
    
    _accessToken    = [SSKeychain passwordForService:kAFVDAccessToken account:iCloudTokenName()];
    _expiryDate     = [SSKeychain passwordForService:kAFVDAccessTokenExpiry account:iCloudTokenName()];
}

- (void)iCloudAccountAvailabilityChanged:(NSNotification *)notification {
    BOOL accountStillActive = NO;
    
    for (NSDictionary* account in [SSKeychain allAccounts]) {
        if ([account[@"acct"] isEqualToString:iCloudTokenName()]) {
            accountStillActive = YES;
        }
    }
    if (!accountStillActive) {
        _accessToken    = nil;
        _expiryDate     = nil;
    }
}

#pragma mark - iCloud token handling
#pragma mark - Retrieve token 
- (void)loadiCloudToken {
    [self loadAccessToken];
}

#pragma mark - Utility methods
#pragma mark - iCloud token name
NSString *iCloudTokenName(void) {
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleKeyName];
    NSString *tokenName = [NSString stringWithFormat:kIdentityTokenIdentifier, appName];
    
    return tokenName;
}

#pragma mark - Singleton instance
+ (instancetype)keychain {
    static dispatch_once_t pred;
    static AFVDKeychain *_singletonInstance = nil;
    
    dispatch_once(&pred, ^{
        _singletonInstance = [[AFVDKeychain alloc] init];
    });
    
	return _singletonInstance;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
