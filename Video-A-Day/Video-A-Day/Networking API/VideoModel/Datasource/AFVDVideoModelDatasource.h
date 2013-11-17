//
//  AFVDVideoModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkDatasource.h"

@interface AFVDVideoModelDatasource : AFVDBaseNetworkDatasource

#pragma mark - Video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken completion:(AFVDBaseNetworkCompletion)completion;

#pragma mark - Video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail completion:(AFVDBaseNetworkCompletion)completion;
    
@end
