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

#pragma mark - Post video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSDate *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail andVideoDescription:(NSString *)description success:(AFVDVideoCreationModelSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] postCreateVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:accessToken videoThumbnail:videoThumbnail videoDescription:description success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Videos at page index
- (void)videosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideosAtPageIndex:pageIndex userName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDVideoPlaylistModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoPlaylistModelForData:networkCallback.responseData];
        }
        
        success(model, networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Relationship videos at page index
- (void)relationshipVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName secondUser:(NSString *)secondUser accessToken:(NSString *)accessToken relationshipId:(NSString *)relationshipId success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideosAtPageIndex:pageIndex userName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDVideoPlaylistModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoPlaylistModelForData:networkCallback.responseData];
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Fetch favourite videos
- (void)favouriteVideosAtPageIndex:(NSUInteger)pageIndex userName:(NSString *)userName accessToken:(NSString *)accessToken success:(AFVDVideoList)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchFavouriteVideosAtPageIndex:pageIndex userName:userName accessToken:accessToken success:^(AFVDBaseNetworkModel *networkCallback) {
        
        AFVDVideoPlaylistModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoPlaylistModelForData:networkCallback.responseData];
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

#pragma mark - Set favourite video
- (void)setFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId favouritedDate:(NSDate *)date success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] postSetFavouriteVideoWithUserName:userName accessToken:accessToken videoId:videoId favouritedDate:date success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
       
        failure(error);
    }];
}

#pragma mark - Remove favourite video
- (void)removeFavouriteVideoWithUserName:(NSString *)userName accessToken:(NSString *)accessToken videoId:(NSString *)videoId success:(AFVDBaseNetworkSuccess)success failure:(AFVDBaseNetworkFailure)failure {
    
    [[AFVDVideoModelDatasource sharedDataSource] postRemoveFavouriteVideoWithUserName:userName accessToken:accessToken videoId:videoId success:^(AFVDBaseNetworkModel *networkCallback) {
        
        success(networkCallback);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
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
    static NSDateFormatter *dateFormat;
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kAFVDBaseNetworkDefaultDateFormat];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    
    NSDate *date = [dateFormat dateFromString:data[@"date"]];
    [model setValue:date forKey:@"date"];
    [model setValue:data[@"thumbnail_path"] forKey:@"thumbnailURL"];
    [model setValue:data[@"video_id"] forKey:@"videoId"];
    [model setValue:data[@"video_path"] forKey:@"videoURL"];
    [model setValue:data[@"relationship_id"] forKey:@"relationshipId"];
    [model setValue:data[@"user"] forKey:@"userName"];
        
    return model;
}

@end
