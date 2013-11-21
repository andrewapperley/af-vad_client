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
NSString *kAFVDUserModelParameterKeyUserName            = @"username";
NSString *kAFVDUserModelParameterKeyAcessToken          = @"access_token";
NSString *kAFVDUserModelParameterKeyEmail               = @"email";
NSString *kAFVDUserModelParameterKeyProfileImage        = @"profile_image";
NSString *kAFVDUserModelParameterKeyDisplayName         = @"display_name";

//Create user endpoint
NSString *kAFVDCreateUserModelEndpointURL               = @"/user/";

//Update user endpoint
NSString *kAFVDUpdateUserModelEndpointURL               = @"/user/updateUser/";
NSString *kAFVDUpdateUserModelParameterKeyChanges       = @"changes";
NSString *kAFVDUpdateUserModelParameterKeyRelationships = @"relationships";

//User login endpoint
NSString *kAFVDUserLoginEndpointURL                     = @"/user/login/";
NSString *kAFVDUserModelParameterKeyPassword            = @"password";

//Username check endpoint
NSString *kAFVDUserNameCheckEndpointURL                 = @"/user/check_username";

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
- (void)postCreateUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage completion:(AFVDBaseNetworkCompletion)completion {
    
    NSString *profileImageString = [profileImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyDisplayName : displayName,
                                 kAFVDUserModelParameterKeyPassword : password,
                                 kAFVDUserModelParameterKeyEmail : email,
                                 kAFVDUserModelParameterKeyProfileImage : profileImageString};
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDCreateUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Update user
- (void)postUpdateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage relationships:(NSSet *)relationships completion:(AFVDBaseNetworkCompletion)completion {
    
    NSString *profileImageString = [profileImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    NSMutableDictionary *changes = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if(displayName) {
        [changes setObject:displayName forKey:kAFVDUserModelParameterKeyDisplayName];
    }

    if(profileImageString) {
        [changes setObject:profileImageString forKey:kAFVDUserModelParameterKeyProfileImage];
    }

    if(relationships) {
        [changes setObject:[relationships allObjects] forKey:kAFVDUpdateUserModelParameterKeyRelationships];
    }
    
    if(email) {
        [changes setObject:email forKey:kAFVDUserModelParameterKeyEmail];
    }

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userName, kAFVDUserModelParameterKeyUserName, accessToken, kAFVDUserModelParameterKeyAcessToken, nil];
    if(changes && changes.allKeys.count > 0 && changes.allValues.count > 0) {
        [parameters setObject:changes forKey:kAFVDUpdateUserModelParameterKeyChanges];
    }
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDUpdateUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
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

- (void)checkIfUsernameIsAvailable:(NSString *)userName completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDUserNameCheckEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end