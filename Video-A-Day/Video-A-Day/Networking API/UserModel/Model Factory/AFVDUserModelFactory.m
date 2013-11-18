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
    
    [[AFVDUserModelDatasource sharedDataSource] loginUserWithUsername:userName password:password completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDUserModel *model = nil;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
            setAccessToken(networkCallback.responseData[@"access_token"]);
        }
        
        completion(model, getAccessToken, networkCallback);
    }];
}

#pragma mark - Fetch user image
- (void)fetchUserProfileImage:(NSString *)userName accessToken:(NSString *)accessToken profileImageId:(NSString *)profileImageId completion:(AFVDUserProfileImageCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] fetchUserProfileImage:userName accessToken:accessToken profileImageId:profileImageId completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        UIImage *userProfileImage = nil;
        
        if(networkCallback.success) {
            userProfileImage = [self userProfileImageForData:networkCallback.responseData];
        }
        
        completion(userProfileImage, networkCallback);
    }];
}

#pragma mark - User model
- (AFVDUserModel *)userModelForData:(NSDictionary *)data {
    
    AFVDUserModel *model = [[AFVDUserModel alloc] init];
    
    NSDictionary *userDictionary = data[@"User"];
    
    //User info
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"email"] forKey:@"email"];
    [model setValue:userDictionary[@"relationships"] forKey:@"relationships"];
    
    return model;
}

#pragma mark - User profile image
- (UIImage *)userProfileImageForData:(NSDictionary *)data {
    
    UIImage *userProfileImage = nil;
    
    return userProfileImage;
}

@end
