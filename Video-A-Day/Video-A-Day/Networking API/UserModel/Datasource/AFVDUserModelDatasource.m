//
//  AFVDUserModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUserModelDatasource.h"

NSString *kAFVDUserModelEndpointURL             = @"/user/info?username=&access_token=";
NSString *kAFVDUserModelParameterKeyUserName    = @"username";
NSString *kAFVDUserModelParameterKeyAcessToken  = @"access_token";

@implementation AFVDUserModelDatasource

- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelDatasourceCompletion)completion {
    
    NSDictionary *parameters = @{userName : kAFVDUserModelParameterKeyUserName,
                                 accessToken : kAFVDUserModelParameterKeyAcessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDUserModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end
