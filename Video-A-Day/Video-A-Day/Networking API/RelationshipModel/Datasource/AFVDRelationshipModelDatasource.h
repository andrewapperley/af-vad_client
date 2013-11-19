//
//  AFVDRelationshipModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkDatasource.h"

@interface AFVDRelationshipModelDatasource : AFVDBaseNetworkDatasource

#pragma mark - Relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Relationship Ids
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Create relationship 
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users completion:(AFVDBaseNetworkCompletion)completion;

@end
