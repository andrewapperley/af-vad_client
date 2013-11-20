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

@implementation AFVDVideoModelDatasource

#pragma mark - Video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoPlaylistModelParameterKeyPlaylistId : playlistId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoPlaylistModelParameterKeyPage : [NSString stringWithFormat:@"%d",pageIndex]};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDVideoPlaylistModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoRelationshipModelParameterKeyId : relationshipId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDVideoRelationshipModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoCreationModelParameterKeyRelationshipId : relationshipId,
                                 kAFVDVideoCreationModelParameterKeyVideoContent : videoContent,
                                 kAFVDVideoCreationModelParameterKeyDate : date,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoCreationModelParameterKeyThumbnail : videoThumbnail};
    
    [self makeURLRequestWithType:kAFFNPost endpointURLString:kAFVDVideoCreationModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

@end
