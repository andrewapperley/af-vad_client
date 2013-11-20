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
NSString *kAFVDCreateUserModelEndpointURL                     = @"/user/";
NSString *kAFVDUserModelParameterKeyUserName            = @"username";
NSString *kAFVDUserModelParameterKeyAcessToken          = @"access_token";
NSString *kAFVDUserModelParameterKeyEmail         = @"email";
NSString *kAFVDUserModelParameterKeyProfileImage         = @"profile_image";

//User login endpoint
NSString *kAFVDUserLoginEndpointURL                     = @"/user/login/";
NSString *kAFVDUserModelParameterKeyPassword            = @"password";

@implementation AFVDUserModelDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Create User
- (void)postUsername:(NSString *)userName andPassword:(NSString *)password andEmail:(NSString *)email andProfileImage:(NSData *)profileImage completion:(AFVDBaseNetworkCompletion)completion {
    
    NSString *profileImageString = [profileImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *parameters = @{
                                 kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyPassword : password,
                                 kAFVDUserModelParameterKeyEmail : email,
                                 kAFVDUserModelParameterKeyProfileImage : profileImageString
                                 };
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDCreateUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - User login
- (void)postLoginUserWithUsername:(NSString *)userName password:(NSString *)password completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyPassword : password};
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDUserLoginEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end