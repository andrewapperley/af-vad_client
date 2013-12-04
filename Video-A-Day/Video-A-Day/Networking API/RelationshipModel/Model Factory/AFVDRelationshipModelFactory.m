//
//  AFVDRelationshipModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDRelationshipModelDatasource.h"
#import "AFVDRelationshipModelFactory.h"
#import "AFVDUserModel.h"

@implementation AFVDRelationshipModelFactory

#pragma mark - Fetch relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDRelationshipModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDRelationshipModelDatasource sharedDataSource] fetchRelationshipModelWithUserName:userName accessToken:accessToken relationshipId:relationshipId success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDRelationshipModel *model = nil;
        
        if(networkCallback.success) {
            
            NSDictionary *relationshipDictionary = networkCallback.responseData[@"relationship"];
            model = [self relationshipModelForData:relationshipDictionary];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch relationship models
- (void)fetchRelationshipModelsWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDRelationshipIdsSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDRelationshipModelDatasource sharedDataSource] fetchRelationshipModelsWithUserName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        NSArray *relationshipIds = nil;
        
        if(networkCallback.success) {
            relationshipIds = [self relationshipModelsForData:networkCallback.responseData];
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
    
    //Relationship id
    [model setValue:data[@"relationship_id"] forKey:@"relationshipId"];
    
    //User models
    NSDictionary *userOneModelData = data[@"user1"];
    if(userOneModelData) {
        AFVDUserModel *userOneModel = [self userModelForData:userOneModelData];
        [model setValue:userOneModel forKey:@"userOne"];
    }
    
    NSDictionary *userTwoModelData = data[@"user2"];
    if(userTwoModelData) {
        AFVDUserModel *userTwoModel = [self userModelForData:userTwoModelData];
        [model setValue:userTwoModel forKey:@"userTwo"];
    }
    
    //Dates
    static NSDateFormatter *dateFormat;
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kAFVDBaseNetworkDefaultDateFormat];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    
    NSDate *startDate = [dateFormat dateFromString:data[@"start_date"]];
    [model setValue:startDate forKey:@"startDate"];
    
    NSDate *endDate = [dateFormat dateFromString:data[@"end_date"]];
    [model setValue:endDate forKey:@"endDate"];

    //Finished
    BOOL finished = [data[@"finished"] boolValue];
    model.finished = finished;
    
    return model;
}

#pragma mark - Relationship models
- (NSArray *)relationshipModelsForData:(NSDictionary *)data {
    
    NSArray *relationshipsArray = data[@"relationships"];
    NSMutableArray *relationshipModels = [[NSMutableArray alloc] initWithCapacity:relationshipsArray.count];
    
    for(NSDictionary *relationshipDictionary in relationshipsArray) {
        
        AFVDRelationshipModel *model = [self relationshipModelForData:relationshipDictionary];
        [relationshipModels addObject:model];
    }
    
    return relationshipModels;
}

#pragma mark - User model
- (AFVDUserModel *)userModelForData:(NSDictionary *)data {
    
    AFVDUserModel *model = [[AFVDUserModel alloc] init];
    
    [model setValue:data[@"profile_image"] forKey:@"userImageUrl"];
    [model setValue:data[@"display_name"] forKey:@"displayName"];
    
    return model;
}

@end
