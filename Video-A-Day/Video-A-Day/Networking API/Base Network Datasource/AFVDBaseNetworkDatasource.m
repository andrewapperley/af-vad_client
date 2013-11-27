//
//  AFVDBaseNetworkDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <AFNetworking.h>
#import "AFVDBaseNetworkDatasource.h"

const NSString *kAFVDBaseNetworkKeyPostParam    = @"params";

@implementation AFVDBaseNetworkDatasource

- (void)makeURLRequestWithType:(AFVDNetworkCallType)type endpointURLString:(NSString *)urlString success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [self makeURLRequestWithType:type endpointURLString:urlString parameters:nil success:success failure:failure];
}

- (void)makeURLRequestWithType:(AFVDNetworkCallType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    //Base request URL
    static NSURL *baseRequestURL;
    
    if(!baseRequestURL) {
        baseRequestURL = [NSURL URLWithString:BASE_NETWORK_URL];
    }
    
    //Create session manager
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseRequestURL];
    
    //If the type is "POST" then we must wrap any parameters in a 'params' dictionary.
    NSDictionary *paramDictionary;
    if(type == kAFVDNetworkCallType_POST) {
       
        NSMutableDictionary *newParamDictionary = [NSMutableDictionary dictionary];
        [newParamDictionary setObject:parameters forKey:kAFVDBaseNetworkKeyPostParam];
        paramDictionary = newParamDictionary;
        
        [sessionManager POST:urlString parameters:paramDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
            
            AFVDBaseNetworkModel *networkModel = [self networkModelFromResponse:responseObject];
            success(networkModel);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failure(error);
        }];
        
    } else {
        paramDictionary = parameters;
        
        [sessionManager GET:urlString parameters:paramDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
            
            AFVDBaseNetworkModel *networkModel = [self networkModelFromResponse:responseObject];
            success(networkModel);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failure(error);
        }];
    }
}

#pragma mark - Status handling
- (AFVDBaseNetworkModel *)networkModelFromResponse:(id)callbackObject {
    
    NSMutableDictionary *networkCallbackDictionary = [NSMutableDictionary dictionaryWithDictionary:[NSMutableDictionary dictionaryWithData:callbackObject]];
    
    AFVDBaseNetworkModel *networkModel = [[AFVDBaseNetworkModel alloc] init];
    
    //Status
    networkModel.success = [networkCallbackDictionary[@"status"] boolValue];
    [networkCallbackDictionary removeObjectForKey:@"status"];
    
    //Response code
    NSUInteger responseCode = [networkCallbackDictionary[@"HTTP_CODE"] unsignedIntegerValue];
    networkModel.responseCode = responseCode;
    [networkCallbackDictionary removeObjectForKey:@"HTTP_CODE"];

    //Response message
    NSString *responseMessage = networkCallbackDictionary[@"message"];
    [networkModel setValue:responseMessage forKey:@"responseMessage"];
    [networkCallbackDictionary removeObjectForKey:@"message"];

    //Response data
    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:networkCallbackDictionary];
    
    if(responseDictionary && responseDictionary.allValues.count > 0 && responseDictionary.allKeys.count > 0) {
        [networkModel setValue:responseDictionary forKey:@"responseData"];
    }
    
    return networkModel;
}

#pragma mark - Singleton instance
+ (instancetype)sharedDataSource {
    
    return [[self alloc] init];
}

@end
