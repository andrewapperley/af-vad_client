//
//  AFVDUserModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkDatasource.h"

@interface AFVDUserModelDatasource : AFVDBaseNetworkDatasource

#pragma mark - User model
- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - User login
- (void)postLoginUserWithUsername:(NSString *)userName password:(NSString *)password completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Create user
- (void)postCreateUsername:(NSString *)userName password:(NSString *)password displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Update user
- (void)postUpdateUserWithUsername:(NSString *)userName accessToken:(NSString *)accessToken displayName:(NSString *)displayName email:(NSString *)email profileImage:(NSData *)profileImage relationships:(NSSet *)relationships completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Check if username is available
- (void)checkIfUsernameIsAvailable:(NSString *)userName completion:(AFVDBaseNetworkCompletion)completion;

@end