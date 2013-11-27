//
//  AFVDRelationshipModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDBaseNetworkStatics.h"
#import "AFVDRelationshipModel.h"

typedef void(^AFVDRelationshipModelSuccess)(AFVDRelationshipModel *relationshipModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDRelationshipIdsSuccess)(NSArray *relationshipIds, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDRelationshipCreationSuccess)(AFVDBaseNetworkModel *networkCallback);

@interface AFVDRelationshipModelFactory : NSObject

#pragma mark - Fetch relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDRelationshipModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Fetch relationship Ids
- (void)fetchRelationshipModelIdsWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDRelationshipIdsSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Post relationship creation
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users success:(AFVDRelationshipCreationSuccess)success failure:(AFVDBaseNetworkFailure)failure;

@end