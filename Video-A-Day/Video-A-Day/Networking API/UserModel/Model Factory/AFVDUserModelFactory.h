//
//  AFVDUserModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModel.h"

@class AFVDBaseNetworkModel;

typedef void(^AFVDUserLoginCompletion)(AFVDUserModel *userModel, NSString *accessToken, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUserModelCompletion)(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUserCreationCompletion)(AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUsernameAvailabilityCompletion)(AFVDBaseNetworkModel *networkCallback, BOOL isUsernameAvailable);

@interface AFVDUserModelFactory : NSObject

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelCompletion)completion;

#pragma mark - Fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password completion:(AFVDUserLoginCompletion)completion;

#pragma mark - Create user
- (void)createUserWithUsername:(NSString *)userName andPassword:(NSString *)password andEmail:(NSString *)email andProfileImage:(NSData *)profileImage completion:(AFVDUserCreationCompletion)completion;

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName completion:(AFVDUsernameAvailabilityCompletion)completion;

@end
