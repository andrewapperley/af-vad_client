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

#pragma mark - User model
- (AFVDUserModel *)userModelForData:(NSDictionary *)data {
    
    AFVDUserModel *model = [[AFVDUserModel alloc] init];
    
    NSDictionary *userDictionary = data[@"User"];
    
    //Profile image
    NSString *profileImageString = userDictionary[@"profile_image"];
    NSData *profileImageData = [[NSData alloc]initWithBase64EncodedString:profileImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *profileImage = [UIImage imageWithData:profileImageData];
    
    //User infor
    [model setValue:userDictionary[@"username"] forKey:@"userName"];
    [model setValue:userDictionary[@"email"] forKey:@"email"];
    [model setValue:profileImage forKey:@"profileImage"];
    [model setValue:userDictionary[@"relationships"] forKey:@"relationships"];
    
    return model;
}

@end
