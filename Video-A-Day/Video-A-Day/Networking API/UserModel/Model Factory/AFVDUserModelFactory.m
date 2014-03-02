//
//  AFVDUserModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDKeychain.h"
#import "AFVDUserModelDatasource.h"
#import "AFVDUserModelFactory.h"

@implementation AFVDUserModelFactory

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDUserModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] fetchUserModelWithUserName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDUserModel *model = nil;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - User login / fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDUserLoginSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] postLoginUserWithUsername:userName password:password accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDUserModel *model = nil;
        
        NSString *accessToken;
        NSString* expiryDate;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
            accessToken = networkCallback.responseData[@"access_token"];
            expiryDate = networkCallback.responseData[@"expiry_date"];
            [[AFVDKeychain keychain] setAccessToken:accessToken andExpiryDate:expiryDate];
        }
        
        success(model, accessToken, networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - User logout
- (void)fetchLogoutUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] postLogoutUserWithUsername:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
 
        failure(error);
    }];
}

#pragma mark - Deactivate user
- (void)fetchDeactivateUser:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] postDeactivateUser:userName password:password accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create user
- (void)createUserWithUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFVDUserCreationSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] postCreateUsername:userName password:password displayName:displayName email:email profileImage:profileImage success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Update user
- (void)updateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFVDUserCreationSuccess)success failure:(AFVDBaseNetworkFailure)failure {

    [[AFVDUserModelDatasource sharedDataSource] postUpdateUserWithUsername:userName accessToken:accessToken displayName:displayName email:email profileImage:profileImage success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFVDUsernameAvailabilitySuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] checkIfUsernameIsAvailable:userName success:^(AFVDBaseNetworkModel *networkCallback) {
        
        BOOL isUsernameAvailable = networkCallback.success;
        
        success(networkCallback, isUsernameAvailable);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Update token
- (void)fetchUserUpdateTokenWithUsername:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDUserUpdateTokenSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDUserModelDatasource sharedDataSource] postUpdateTokenWithUsername:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        NSString *accessToken;
        
        if(networkCallback.success) {
            accessToken = networkCallback.responseData[@"access_token"];
            [AFVDKeychain keychain].accessToken = accessToken;
        }
        
        success(accessToken, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - User model
- (AFVDUserModel *)userModelForData:(NSDictionary *)data {
    
    AFVDUserModel *model = [[AFVDUserModel alloc] init];
    
    NSDictionary *userDictionary = data[@"User"];
    
    //User info
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"email"] forKey:@"email"];
    [model setValue:userDictionary[@"profile_image"] forKey:@"userImageUrl"];
    [model setValue:userDictionary[@"display_name"] forKey:@"displayName"];
    
    NSArray *relationshipsArray = userDictionary[@"relationships"];
    [model setValue:relationshipsArray forKey:@"relationships"];

    BOOL isDeactivated = [userDictionary[@"deactivated"] boolValue];
    model.isDeactivated = isDeactivated;
    
    return model;
}

@end
