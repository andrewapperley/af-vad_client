//
//  AFVDVideoModelDatasource.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkDatasource.h"

@interface AFVDVideoModelDatasource : AFVDBaseNetworkDatasource

#pragma mark - Video creation
- (void)postCreateVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSDate *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail videoDescription:(NSString *)description success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Videos at page index
- (void)fetchVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Relationship videos at page index
- (void)fetchRelationshipVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName secondUser:(NSString *)secondUser accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Fetch favourite videos
- (void)fetchFavouriteVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Set favourite video
- (void)postSetFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(NSDate *)date success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

#pragma mark - Remove favourite video
- (void)postRemoveFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure;

@end
