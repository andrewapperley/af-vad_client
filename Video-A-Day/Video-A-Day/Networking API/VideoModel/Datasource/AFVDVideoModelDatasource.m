//
//  AFVDVideoModelDatasource.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoModelDatasource.h"

NSString *kAFVDVideoModelParameterKeyUserName    = @"username";
NSString *kAFVDVideoModelParameterKeyAcessToken  = @"access_token";

//Video playlist
NSString *kAFVDVideoPlaylistModelEndpointURL             = @"/video/";
NSString *kAFVDVideoPlaylistModelParameterKeyPlaylistId  = @"playlist_id";
NSString *kAFVDVideoPlaylistModelParameterKeyPage        = @"page";

//Video relationship playlist
NSString *kAFVDVideoRelationshipModelEndpointURL         = @"/video/playlists/";
NSString *kAFVDVideoRelationshipModelId                  = @"relationship_id";

//CONTENT_BASE_URL+/user_content/videos/relationship_id/username/video_date/thumbnail
//and videos at
//CONTENT_BASE_URL+/user_content/videos/relationship_id/username/video_date/video_id.mov

@implementation AFVDVideoModelDatasource

#pragma mark - Video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoPlaylistModelParameterKeyPlaylistId : playlistId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken,
                                 kAFVDVideoPlaylistModelParameterKeyPage : @(pageIndex)};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDVideoPlaylistModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}

#pragma mark - Video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion {
    
    NSDictionary *parameters = @{kAFVDVideoModelParameterKeyUserName : userName,
                                 kAFVDVideoRelationshipModelId : relationshipId,
                                 kAFVDVideoModelParameterKeyAcessToken : accessToken};
    
    [self makeURLRequestWithType:kAFFNGet endpointURLString:kAFVDVideoRelationshipModelEndpointURL parameters:parameters completion:^(AFVDBaseNetworkModel *callback) {
        
        completion(callback);
    }];
}


@end
