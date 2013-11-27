//
//  AFVDRelationshipModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDRelationshipModelDatasource.h"
#import "AFVDRelationshipModelFactory.h"

@implementation AFVDRelationshipModelFactory

#pragma mark - Fetch relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDRelationshipModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDRelationshipModelDatasource sharedDataSource] fetchRelationshipModelWithUserName:userName accessToken:accessToken relationshipId:relationshipId success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDRelationshipModel *model = nil;
        
        if(networkCallback.success) {
            model = [self relationshipModelForData:networkCallback.responseData];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch relationship Ids
- (void)fetchRelationshipModelIdsWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDRelationshipIdsSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDRelationshipModelDatasource sharedDataSource] fetchRelationshipModelWithUserName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        NSArray *relationshipIds = nil;
        
        if(networkCallback.success) {
            relationshipIds = [self relationshipIdsForData:networkCallback.responseData];
        }
        
        success(relationshipIds, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Post relationship creation
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDRelationshipModelDatasource sharedDataSource] postRelationshipModelWithUserName:userName accessToken:accessToken startDate:startDate endDate:endDate users:users success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Relationship model
- (AFVDRelationshipModel *)relationshipModelForData:(NSDictionary *)data {
    
    AFVDRelationshipModel *model = [[AFVDRelationshipModel alloc] init];
    
    NSDictionary *relationshipDictionary = data[@"relationship"];
    
    //User info
    [model setValue:relationshipDictionary[@"relationship_id"] forKey:@"relationshipId"];
    [model setValue:relationshipDictionary[@"start_date"] forKey:@"startDate"];
    [model setValue:relationshipDictionary[@"end_date"] forKey:@"endDate"];
    [model setValue:relationshipDictionary[@"playlists"] forKey:@"playlists"];
    [model setValue:relationshipDictionary[@"users"] forKey:@"users"];
    
    BOOL shouldHideVideosUntilEndDateIsMet = [relationshipDictionary[@"private"] boolValue];
    model.shouldHideVideosUntilEndDateIsMet = shouldHideVideosUntilEndDateIsMet;
    
    return model;
}

#pragma mark - Relationship ids
- (NSArray *)relationshipIdsForData:(NSDictionary *)data {
    
    NSArray *relationshipIds = data[@"relationships"];
    
    return relationshipIds;
}

@end
