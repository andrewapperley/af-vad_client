//
//  AFVDRelationshipModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDRelationshipModel.h"

@class AFVDBaseNetworkModel;

typedef void(^AFVDRelationshipModelCompletion)(AFVDRelationshipModel *relationshipModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDRelationshipIdsCompletion)(NSArray *relationshipIds, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDRelationshipCreationCompletion)(AFVDBaseNetworkModel *networkCallback);

@interface AFVDRelationshipModelFactory : NSObject

#pragma mark - Fetch relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId completion:(AFVDRelationshipModelCompletion)completion;

#pragma mark - Fetch relationship Ids
- (void)fetchRelationshipModelIdsWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDRelationshipIdsCompletion)completion;

#pragma mark - Post relationship creation
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users completion:(AFVDRelationshipCreationCompletion)completion;

@end
