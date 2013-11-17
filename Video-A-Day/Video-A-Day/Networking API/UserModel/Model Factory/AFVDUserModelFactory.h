//
//  AFVDUserModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModel.h"

@class AFVDBaseNetworkModel;

typedef void(^AFVDUserModelCompletion)(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDUserLoginCompletion)(AFVDUserModel *userModel, NSString *accessToken , AFVDBaseNetworkModel *networkCallback);

@interface AFVDUserModelFactory : NSObject

- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelCompletion)completion;

- (void)fetchUserModelAndAccessTokenWithUserName:(NSString *)userName andPassword:(NSString *)password completion:(AFVDUserLoginCompletion)completion;

@end
