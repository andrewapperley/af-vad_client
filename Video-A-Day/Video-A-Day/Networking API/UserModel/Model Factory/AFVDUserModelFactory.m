//
//  AFVDUserModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModelDatasource.h"
#import "AFVDUserModelFactory.h"

@implementation AFVDUserModelFactory

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] fetchUserModelWithUserName:userName accessToken:accessToken completion:^(AFVDBaseNetworkModel *networkCallback) {
       
        AFVDUserModel *model = nil;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
        }
        
        completion(model, networkCallback);
    }];
}

#pragma mark - Fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password completion:(AFVDUserLoginCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] postLoginUserWithUsername:userName password:password completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDUserModel *model = nil;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
            setAccessToken(networkCallback.responseData[@"access_token"]);
        }
        
        completion(model, getAccessToken, networkCallback);
    }];
}

#pragma mark - Create user 
- (void)createUserWithUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage completion:(AFVDUserCreationCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] postCreateUsername:userName password:password displayName:displayName email:email profileImage:profileImage completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        completion(networkCallback);
    }];
}

#pragma mark - Updated user
- (void)updateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage relationships:(NSSet *)relationships completion:(AFVDUserCreationCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] postUpdateUserWithUsername:userName accessToken:accessToken displayName:displayName email:email profileImage:profileImage relationships:relationships completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        completion(networkCallback);
    }];
}

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName completion:(AFVDUsernameAvailabilityCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] checkIfUsernameIsAvailable:userName completion:^(AFVDBaseNetworkModel *networkCallback) {
       
        BOOL isUsernameAvailable = networkCallback.success;
        
        completion(networkCallback, isUsernameAvailable);
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
    
    NSArray *relationshipsArray = userDictionary[@"relationships"];
    NSSet *relationshipsSet = [NSSet setWithArray:relationshipsArray];
    [model setValue:relationshipsSet forKey:@"relationships"];
    
    return model;
}

@end
