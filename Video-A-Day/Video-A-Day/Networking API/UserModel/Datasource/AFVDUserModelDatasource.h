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

#pragma mark - Create User
- (void)postUsername:(NSString *)userName andPassword:(NSString *)password andEmail:(NSString *)email andProfileImage:(NSData *)profileImage completion:(AFVDBaseNetworkCompletion)completion;

@end