//
//  AFVDVideoModelFactory.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoModel.h"
#import "AFVDVideoPlaylistModel.h"
#import "AFVDVideoRelationshipModel.h"

@class AFVDBaseNetworkModel;

typedef void(^AFVDVideoPlaylistModelCompletion)(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDVideoRelationshipModelCompletion)(AFVDVideoRelationshipModel *videoRelationshipModel, AFVDBaseNetworkModel *networkCallback);

@interface AFVDVideoModelFactory : NSObject

#pragma mark - Video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex completion:(AFVDVideoPlaylistModelCompletion)completion;

#pragma mark - Video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken completion:(AFVDVideoRelationshipModelCompletion)completion;


@end
