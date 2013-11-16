//
//  AFVDBaseNetworkDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFFNManager.h"
#import "AFVDBaseNetworkDatasource.h"

const NSString *kAFVDBaseNetworkURL     = @"http://99.232.33.159:5000";
const char *kAFVDBaseNetworkQueue       = "kAFVDBaseNetworkDispatchQueue";

@implementation AFVDBaseNetworkDatasource

- (void)makeURLRequestWithType:(AFFNPostType)type endpointURLString:(NSString *)urlString completion:(AFVDBaseNetworkCompletion)completion {
    
    [self makeURLRequestWithType:type endpointURLString:urlString parameters:nil completion:completion];
}

- (void)makeURLRequestWithType:(AFFNPostType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(AFVDBaseNetworkCompletion)completion {
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@", kAFVDBaseNetworkURL, urlString];
    
    AFFNRequest *request = [AFFNRequest requestWithConnectionType:type andURL:requestString andParams:parameters withCompletion:^(AFFNCallbackObject *result) {
        
        AFVDBaseNetworkModel *networkModel = [self networkModelFromResponse:result];
        dispatch_async(dispatch_get_main_queue(), ^(){
            completion(networkModel);
        });
        
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            completion(nil);
        });
        
    }];
    
    [[AFFNManager sharedManager] addNetworkOperation:request];
}

#pragma mark - Status handling
- (AFVDBaseNetworkModel *)networkModelFromResponse:(AFFNCallbackObject *)callbackObject {
    
    NSMutableDictionary *networkCallbackDictionary = [NSMutableDictionary dictionaryWithDictionary:[NSMutableDictionary dictionaryWithData:callbackObject.data]];
    
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
