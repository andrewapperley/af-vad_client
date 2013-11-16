//
//  AFVDUserModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModel.h"
#import "AFVDUserModelDatasource.h"
#import "AFVDUserModelFactory.h"

@implementation AFVDUserModelFactory

- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelCompletion)completion {
    
    [[AFVDUserModelDatasource sharedDataSource] fetchUserModelWithUserName:userName accessToken:accessToken completion:^(AFVDBaseNetworkModel *networkCallback) {
       
        AFVDUserModel *model = nil;
        
        if(networkCallback.success) {
            model = [self userModelForData:networkCallback.responseData];
        }
        
        completion(model, networkCallback);
    }];
}

#pragma mark - User Model
- (AFVDUserModel *)userModelForData:(NSDictionary *)data {
    
    AFVDUserModel *model = [[AFVDUserModel alloc] init];
    
    NSDictionary *userDictionary = data[@"User"];
    
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"email"] forKey:@"email"];
    [model setValue:userDictionary[@"profile_image"] forKey:@"profileImageURL"];
    [model setValue:userDictionary[@"relationships"] forKey:@"relationships"];
    
    return model;
}

@end
