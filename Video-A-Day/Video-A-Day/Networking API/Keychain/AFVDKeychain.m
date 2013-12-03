//
//  AFVDKeychain.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/1/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDKeychain.h"

//Keys
NSString *const kIdentityTokenIdentifier = @"com.apple.%@.UbiquityIdentityToken";
NSString *const kBundleKeyName           = @"CFBundleName";

//Access Token handling
NSString *const kAFVDAccessToken            = @"userAccessToken";

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
- (void)setAccessToken:(NSString *)accessToken {
    
    _accessToken = accessToken;
    
#warning TODO : Save to user defaults and / or iCloud
    
    if(_accessToken) {
        [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:kAFVDAccessToken];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAFVDAccessToken];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadAccessToken {
    
#warning TODO : Handle loading access token from iCloud
    _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAFVDAccessToken];
}

- (void)iCloudAccountAvailabilityChanged:(NSNotification *)notification {
    
#warning TODO : Handle changes
}

#pragma mark - iCloud token handling
#pragma mark - Retrieve token 
- (void)loadiCloudToken {
    
    id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    NSString *tokenName = iCloudTokenName();
    
    if(currentiCloudToken) {
        NSData *newTokenData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
        [[NSUserDefaults standardUserDefaults] setObject:newTokenData forKey:tokenName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:tokenName];
    }
    
    [self loadAccessToken];
}

#pragma mark - Saving
- (void)save {
    
    #warning TODO : Save w/ encryption
    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:kAFVDAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
