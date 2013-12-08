//
//  AFVDUserModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDBaseNetworkStatics.h"
#import "AFVDUserModel.h"

typedef void(^AFVDUserLoginSuccess)(AFVDUserModel *userModel, NSString *accessToken, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUserModelSuccess)(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUserCreationSuccess)(AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUsernameAvailabilitySuccess)(AFVDBaseNetworkModel *networkCallback, BOOL isUsernameAvailable);
typedef void(^AFVDUserUpdateTokenSuccess)(NSString *accessToken, AFVDBaseNetworkModel *networkCallback);

@interface AFVDUserModelFactory : NSObject

#pragma mark - Fetch user model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDUserModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - User login / fetch user model and access token
- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDUserLoginSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - User logout
- (void)fetchLogoutUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Deactivate user
- (void)fetchDeactivateUser:(NSString *)userName password:(NSString *)password accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Create user
- (void)createUserWithUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFVDUserCreationSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Update user
- (void)updateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage success:(AFVDUserCreationSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName success:(AFVDUsernameAvailabilitySuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Update token
- (void)fetchUserUpdateTokenWithUsername:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDUserUpdateTokenSuccess)success failure:(AFVDBaseNetworkFailure)failure;

@end