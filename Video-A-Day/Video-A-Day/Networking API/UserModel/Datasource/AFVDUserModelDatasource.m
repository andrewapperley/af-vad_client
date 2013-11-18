//
//  AFVDUserModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModelDatasource.h"

//User model endpoint
NSString *kAFVDUserModelEndpointURL                     = @"/user/info";

//User login endpoint
NSString *kAFVDUserLoginEndpointURL                     = @"/user/login/";

NSString *kAFVDUserModelParameterKeyUserName            = @"username";
NSString *kAFVDUserModelParameterKeyPassword            = @"password";
NSString *kAFVDUserModelParameterKeyAcessToken          = @"access_token";

//User profile image
NSString *kAFVDUserProfileImageURLEndpoint              = @"/profile_image";
NSString *kAFVDUserProfileImageKeyId                    = @"profile_image_id";

@implementation AFVDUserModelDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - User login
- (void)loginUserWithUsername:(NSString *)userName password:(NSString *)password completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyPassword : password};
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDUserLoginEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Fetch user image
- (void)fetchUserProfileImage:(NSString *)userName profileImageId:(NSString *)profileImageId completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserProfileImageKeyId : profileImageId};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDUserProfileImageURLEndpoint parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end