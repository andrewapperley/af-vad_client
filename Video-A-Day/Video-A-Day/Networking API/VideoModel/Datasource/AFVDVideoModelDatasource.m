//
//  AFVDVideoModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoModelDatasource.h"

NSString *kAFVDVideoModelParameterKeyUserName               = @"username";
NSString *kAFVDVideoModelParameterKeyAcessToken             = @"access_token";

//Videos at page index
NSString *kAFVDVideoModelsEndpointURL                       = @"/video/getVideos/";
NSString *kAFVDVideoModelsParameterKeyRelationshipId        = @"relationship_id";
NSString *kAFVDVideoModelsParameterKeyPage                  = @"page";
NSString *kAFVDVideoModelsParameterKeyType                  = @"type";
NSString *kAFVDVideoModelsParameterKeySecondUser            = @"user2";

//Video creation
NSString *kAFVDVideoCreationModelEndpointURL                = @"/video/";
NSString *kAFVDVideoCreationModelParameterKeyRelationshipId = @"relationship_id";
NSString *kAFVDVideoCreationModelParameterKeyVideoContent   = @"video_content";
NSString *kAFVDVideoCreationModelParameterKeyDate           = @"date";
NSString *kAFVDVideoCreationModelParameterKeyThumbnail      = @"video_thumbnail";
NSString *kAFVDVideoCreationModelParameterKeyDescription    = @"description";

//Favourites
NSString *kAFVDFavouriteVideoModelGetEndpointURL            = @"/video/favourites/";
NSString *kAFVDFavouriteVideoModelSetEndpointURL            = @"/video/setfavourite/";
NSString *kAFVDFavouriteVideoModelRemoveEndpointURL         = @"/video/unsetfavourite/";
NSString *kAFVDFavouriteVideoModelVideoId                   = @"video_id";
NSString *kAFVDFavouriteVideoModelFavouriteDate             = @"fav_date";

@implementation AFVDVideoModelDatasource

#pragma mark - Video creation
- (void)postCreateVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSDate *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail videoDescription:(NSString *)description success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    static NSDateFormatter *dateFormat;
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kAFVDBaseNetworkDefaultDateFormat];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoCreationModelParameterKeyRelationshipId : relationshipId,
                                 kAFVDVideoCreationModelParameterKeyVideoContent : videoContent,
                                 kAFVDVideoCreationModelParameterKeyDate : [dateFormat stringFromDate:date],
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoCreationModelParameterKeyThumbnail : videoThumbnail,
                                 kAFVDVideoCreationModelParameterKeyDescription : description};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDVideoCreationModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Videos at page index
- (void)fetchVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoModelsParameterKeyType : @"selfType",
                                 kAFVDVideoModelsParameterKeyPage : [NSString stringWithFormat:@"%d",pageIndex]};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDVideoModelsEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Relationship videos at page index
- (void)fetchRelationshipVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName secondUser:(NSString *)secondUser accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:
                               @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoModelsParameterKeyType : @"relationshipType",
                                 kAFVDVideoModelsParameterKeyPage : [NSString stringWithFormat:@"%d",pageIndex]}];
    
    if(secondUser) {
        [parameters setValue:kAFVDVideoModelsParameterKeySecondUser forKey:secondUser];
    }
    
    if(relationshipId) {
        [parameters setValue:kAFVDVideoModelsParameterKeyRelationshipId forKey:relationshipId];
    }
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDVideoModelsEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch favourite videos
- (void)fetchFavouriteVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoModelsParameterKeyPage : [NSString stringWithFormat:@"%d",pageIndex]};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDFavouriteVideoModelGetEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set favourite video
- (void)postSetFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(NSDate *)date success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    static NSDateFormatter *dateFormat;
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kAFVDBaseNetworkDefaultDateFormat];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDFavouriteVideoModelVideoId : videoId,
                                 kAFVDFavouriteVideoModelFavouriteDate : [dateFormat stringFromDate:date]};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDFavouriteVideoModelSetEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Remove favourite video
- (void)postRemoveFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDFavouriteVideoModelVideoId : videoId};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDFavouriteVideoModelRemoveEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end
