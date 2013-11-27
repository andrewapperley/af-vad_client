//
//  AFVDVideoModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDBaseNetworkStatics.h"
#import "AFVDVideoModel.h"
#import "AFVDVideoPlaylistModel.h"
#import "AFVDVideoRelationshipModel.h"

typedef void(^AFVDVideoPlaylistModelSuccess)(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDVideoRelationshipModelSuccess)(AFVDVideoRelationshipModel *videoRelationshipModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDVideoCreationModelSuccess)(AFVDBaseNetworkModel *networkCallback);

@interface AFVDVideoModelFactory : NSObject

#pragma mark - Fetch video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex success:(AFVDVideoPlaylistModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Fetch video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken success:(AFVDVideoRelationshipModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Post video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail success:(AFVDVideoCreationModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

@end