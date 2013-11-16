//
//  AFVDUserModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkDatasource.h"

typedef void(^AFVDUserModelDatasourceCompletion)(AFVDBaseNetworkModel *networkCallback);

@interface AFVDUserModelDatasource : AFVDBaseNetworkDatasource

- (void)fetchUserModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDUserModelDatasourceCompletion)completion;

@end
