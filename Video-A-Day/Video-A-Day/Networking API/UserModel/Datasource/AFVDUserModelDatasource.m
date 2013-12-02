//
//  AFVDUserModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDKeychain.h"
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

//User logout endpoint
NSString *kAFVDUserLogoutEndpointURL                    = @"/user/logout/";

//Username check endpoint
NSString *kAFVDUserNameCheckEndpointURL                 = @"/user/check_username";

//Deactivate user endpoint
NSString *kAFVDDeactivateUserEndpointURL                = @"/user/removeUser/";

@implementation AFVDUserModelDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDUserModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User login
- (void)postLoginUserWithUsername:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{kAFVDUserModelParameterKeyUserName : userName,
                                         kAFVDUserModelParameterKeyPassword : password}];
    
    if(accessToken) {
        [parameters setObject:kAFVDUserModelParameterKeyAcessToken forKey:accessToken];
    }
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDUserLoginEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User logout
- (void)postLogoutUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDUserLogoutEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create User
- (void)postCreateUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSString *profileImageString = [profileImage base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName,
                                 kAFVDUserModelParameterKeyDisplayName : displayName,
                                 kAFVDUserModelParameterKeyPassword : password,
                                 kAFVDUserModelParameterKeyEmail : email,
                                 kAFVDUserModelParameterKeyProfileImage : profileImageString};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDCreateUserModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Update user
- (void)postUpdateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage relationships:(NSSet *)relationships success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
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
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDUpdateUserModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDUserModelParameterKeyUserName : userName};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDUserNameCheckEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Deactivate user
- (void)postDeactivateUser:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{kAFVDUserModelParameterKeyUserName : userName,
                                         kAFVDUserModelParameterKeyPassword : password}];
    
    if(accessToken) {
        [parameters setObject:kAFVDUserModelParameterKeyAcessToken forKey:accessToken];
    }
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDDeactivateUserEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end