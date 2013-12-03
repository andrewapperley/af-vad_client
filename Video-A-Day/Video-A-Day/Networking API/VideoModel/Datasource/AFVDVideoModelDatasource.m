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

//Video playlist
NSString *kAFVDVideoPlaylistModelEndpointURL                = @"/video/getVideos/";
NSString *kAFVDVideoPlaylistModelParameterKeyPlaylistId     = @"playlist_id";
NSString *kAFVDVideoPlaylistModelParameterKeyPage           = @"page";

//Video relationship playlist
NSString *kAFVDVideoRelationshipModelEndpointURL            = @"/video/playlists/";
NSString *kAFVDVideoRelationshipModelParameterKeyId         = @"relationship_id";

//Video creation
NSString *kAFVDVideoCreationModelEndpointURL                = @"/video/";
NSString *kAFVDVideoCreationModelParameterKeyRelationshipId = @"relationship_id";
NSString *kAFVDVideoCreationModelParameterKeyVideoContent   = @"video_content";
NSString *kAFVDVideoCreationModelParameterKeyDate           = @"date";
NSString *kAFVDVideoCreationModelParameterKeyThumbnail      = @"video_thumbnail";
NSString *kAFVDVideoCreationModelParameterKeyDescription      = @"description";

@implementation AFVDVideoModelDatasource

#pragma mark - Video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoPlaylistModelParameterKeyPlaylistId : playlistId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoPlaylistModelParameterKeyPage : [NSString stringWithFormat:@"%d",pageIndex]};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDVideoPlaylistModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoRelationshipModelParameterKeyId : relationshipId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_GET endpointURLString:kAFVDVideoRelationshipModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail videoDescription:(NSString *)description success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoCreationModelParameterKeyRelationshipId : relationshipId,
                                 kAFVDVideoCreationModelParameterKeyVideoContent : videoContent,
                                 kAFVDVideoCreationModelParameterKeyDate : date,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoCreationModelParameterKeyThumbnail : videoThumbnail,
                                 kAFVDVideoCreationModelParameterKeyDescription : description};
    
    [self makeURLRequestWithType:kAFVDNetworkCallType_POST endpointURLString:kAFVDVideoCreationModelEndpointURL parameters:parameters success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end
