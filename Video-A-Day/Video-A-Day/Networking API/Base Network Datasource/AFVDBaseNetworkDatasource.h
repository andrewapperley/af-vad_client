//
//  AFVDBaseNetworkDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDBaseNetworkStatics.h"

typedef NS_ENUM(NSUInteger, AFVDNetworkCallType) {
    kAFVDNetworkCallType_POST,
    kAFVDNetworkCallType_GET
};

@interface AFVDBaseNetworkDatasource : NSObject

- (void)makeURLRequestWithType:(AFVDNetworkCallType)type endpointURLString:(NSString *)urlString success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;
- (void)makeURLRequestWithType:(AFVDNetworkCallType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Singleton instance
+ (instancetype)sharedDataSource;

@end
