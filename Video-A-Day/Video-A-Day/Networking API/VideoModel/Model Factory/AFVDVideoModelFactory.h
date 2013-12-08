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

typedef void(^AFVDVideoCreationModelSuccess)(AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDVideoList)(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback);

@interface AFVDVideoModelFactory : NSObject

#pragma mark - Post video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSDate *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail andVideoDescription:(NSString *)description success:(AFVDVideoCreationModelSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Videos at page index
- (void)videosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Relationship videos at page index
- (void)relationshipVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName secondUser:(NSString *)secondUser accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Fetch favourite videos
- (void)favouriteVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Set favourite video
- (void)setFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(NSDate *)date success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Remove favourite video
- (void)removeFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

@end