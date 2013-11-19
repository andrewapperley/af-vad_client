//
//  AFVDRelationshipModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDRelationshipModelDatasource.h"

//Relationship from Id endpoint
NSString *kAFVDRelationshipFromIdModelEndpointURL               = @"/user/relationships/";
NSString *kAFVDRelationshipFromIdModelParameterKeyUserName      = @"username";
NSString *kAFVDRelationshipFromIdModelParameterKeyAcessToken    = @"access_token";
NSString *kAFVDRelationshipFromIdModelParameterKeyId            = @"relationship_id";

//Relationship Ids
NSString *kAFVDRelationshipIdsEndpointURL                       = @"/user/relationships/";

//Relationship creation
NSString *kAFVDRelationshipCreateEndpointURL                    = @"/user/relationship/";
NSString *kAFVDRelationshipCreateParameterKeyUsers              = @"users";
NSString *kAFVDRelationshipCreateParameterKeyStartDate          = @"start_date";
NSString *kAFVDRelationshipCreateParameterKeyEndDate            = @"end_date";

@implementation AFVDRelationshipModelDatasource

#pragma mark - Relationship
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken,
                                 kAFVDRelationshipFromIdModelParameterKeyId : relationshipId};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDRelationshipFromIdModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Relationship Ids
- (void)fetchRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDRelationshipIdsEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Create relationship
- (void)postRelationshipModelWithUserName:(NSString *)userName accessToken:(NSString *)accessToken startDate:(NSString *)startDate endDate:(NSString *)endDate users:(NSArray *)users completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDRelationshipFromIdModelParameterKeyUserName : userName,
                                 kAFVDRelationshipFromIdModelParameterKeyAcessToken : accessToken,
                                 kAFVDRelationshipCreateParameterKeyStartDate : startDate,
                                 kAFVDRelationshipCreateParameterKeyEndDate : endDate,
                                 kAFVDRelationshipCreateParameterKeyUsers : users};
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDRelationshipCreateEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end
