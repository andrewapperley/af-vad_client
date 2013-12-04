//
//  AFVDRelationshipModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDRelationshipModelDatasource.h"

//Relationship from Id endpoint
NSString *kAFVDRelationshipFromIdModelEndpointURL               = @"/user/relationship_model";
NSString *kAFVDRelationshipFromIdModelParameterKeyUserName      = @"username";
NSString *kAFVDRelationshipFromIdModelParameterKeyAcessToken    = @"access_token";
NSString *kAFVDRelationshipFromIdModelParameterKeyId            = @"relationship_id";

//Relationship models
NSString *kAFVDRelationshipModelsEndpointURL                    = @"/user/relationships/";

//Relationship creation
NSString *kAFVDRelationshipCreateEndpointURL                    = @"/user/relationship/";
NSString *kAFVDRelationshipCreateParameterKeyUsers              = @"users";
NSString *kAFVDRelationshipCreateParameterKeyStartDate          = @"start_date";
NSString *kAFVDRelationshipCreateParameterKeyEndDate            = @"end_date";

@implementation AFVDRelationshipModelDatasource

#pragma mark - Relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken,
                                 kAFVDRelationshipFromIdModelParameterKeyId : relationshipId};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDRelationshipFromIdModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Relationship models
- (void)fetchRelationshipModelsWithUserName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDRelationshipModelsEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Create relationship
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken,
                                 kAFVDRelationshipCreateParameterKeyStartDate : startDate,
                                 kAFVDRelationshipCreateParameterKeyEndDate : endDate,
                                 kAFVDRelationshipCreateParameterKeyUsers : users};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDRelationshipCreateEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end
