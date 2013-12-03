//
//  AFVDVideoModelFactory.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoModelDatasource.h"
#import "AFVDVideoModelFactory.h"

@implementation AFVDVideoModelFactory

#pragma mark - Fetch video playlist
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex success:(AFVDVideoPlaylistModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideoPlaylistModelWithUserName:userName playlistId:playlistId accessToken:accessToken pageIndex:pageIndex success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDVideoPlaylistModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoPlaylistModelForData:networkCallback.responseData];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken success:(AFVDVideoRelationshipModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideoRelationshipModelWithUserName:userName relationshipId:relationshipId accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDVideoRelationshipModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoRelationshipModelForData:networkCallback.responseData];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Post video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail andVideoDescription:(NSString *)description success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {

    [[AFVDVideoModelDatasource sharedDataSource] postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:accessToken videoThumbnail:videoThumbnail videoDescription:description success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Video relationship model
- (AFVDVideoRelationshipModel *)videoRelationshipModelForData:(NSDictionary *)data {
    
    AFVDVideoRelationshipModel *model = [[AFVDVideoRelationshipModel alloc] init];
    
    NSArray *playlistIdPairs = data[@"playlists"];
    
    if(playlistIdPairs) {
        [model setValue:playlistIdPairs forKey:@"playlistIds"];
    }
    
    return model;
}

#pragma mark - Video playlist model
- (AFVDVideoPlaylistModel *)videoPlaylistModelForData:(NSDictionary *)data {
    
    AFVDVideoPlaylistModel *model = [[AFVDVideoPlaylistModel alloc] init];
    
    //Video array
    NSArray *videoDataArray = data[@"videos"];
    NSMutableArray *videoArray = [[NSMutableArray alloc] initWithCapacity:videoDataArray.count];
    
    for(id videoDataObject in videoDataArray) {
        
        AFVDVideoModel *videoModel = [self videoModelForData:videoDataObject];
        [videoArray addObject:videoModel];
    }
    
    [model setValue:videoArray forKey:@"videos"];
    
    //Total video count
    NSUInteger numberOfPages = [data[@"total_pages"] unsignedIntegerValue];
    model.totalNumberOfPages = numberOfPages;
    
    return model;
}

#pragma mark - Video model
- (AFVDVideoModel *)videoModelForData:(NSDictionary *)data {
    
    AFVDVideoModel *model = [[AFVDVideoModel alloc] init];
    
    //User info
    [model setValue:data[@"date"] forKey:@"date"];
    [model setValue:data[@"thumbnail_path"] forKey:@"thumbnailURL"];
    [model setValue:data[@"video_id"] forKey:@"videoId"];
    [model setValue:data[@"video_path"] forKey:@"videoURL"];
    [model setValue:data[@"relationship_id"] forKey:@"relationshipId"];
    [model setValue:data[@"user"] forKey:@"userName"];
        
    return model;
}

@end
