//
//  AFVDBaseNetworkDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFFNRequest.h"

typedef void(^AFVDBaseNetworkCompletion)(AFVDBaseNetworkModel *networkCallback);

@interface AFVDBaseNetworkDatasource : NSObject

- (void)makeURLRequestWithType:(AFFNPostType)type endpointURLString:(NSString *)urlString completion:(AFVDBaseNetworkCompletion)completion;
- (void)makeURLRequestWithType:(AFFNPostType)type endpointURLString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Singleton instance
+ (instancetype)sharedDataSource;

@end
