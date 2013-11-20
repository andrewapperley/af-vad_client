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
- (void)fetchVideoPlaylistModelWithUserName:(NSString *)userName playlistId:(NSString *)playlistId accessToken:(NSString *)accessToken pageIndex:(NSUInteger)pageIndex completion:(AFVDVideoPlaylistModelCompletion)completion {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideoPlaylistModelWithUserName:userName playlistId:playlistId accessToken:accessToken pageIndex:pageIndex completion:^(AFVDBaseNetworkModel *networkCallback) {
       
        AFVDVideoPlaylistModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoPlaylistModelForData:networkCallback.responseData];
        }
        
        completion(model, networkCallback);
    }];
}

#pragma mark - Fetch video relationship playlist
- (void)fetchVideoRelationshipModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId accessToken:(NSString *)accessToken completion:(AFVDVideoRelationshipModelCompletion)completion {
    
    [[AFVDVideoModelDatasource sharedDataSource] fetchVideoRelationshipModelWithUserName:userName relationshipId:relationshipId accessToken:accessToken completion:^(AFVDBaseNetworkModel *networkCallback) {
       
        AFVDVideoRelationshipModel *model = nil;
        
        if(networkCallback.success) {
            model = [self videoRelationshipModelForData:networkCallback.responseData];
        }
        
        completion(model, networkCallback);
    }];
}

#pragma mark - Post video creation
- (void)postVideoModelWithUserName:(NSString *)userName relationshipId:(NSString *)relationshipId videoContent:(NSString *)videoContent date:(NSString *)date accessToken:(NSString *)accessToken videoThumbnail:(NSString *)videoThumbnail completion:(AFVDVideoCreationModelCompletion)completion {

    [[AFVDVideoModelDatasource sharedDataSource] postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:accessToken videoThumbnail:videoThumbnail completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        completion(networkCallback);
    }];
}

#pragma mark - Video relationship model
- (AFVDVideoRelationshipModel *)videoRelationshipModelForData:(NSDictionary *)data {
    
    AFVDVideoRelationshipModel *model = [[AFVDVideoRelationshipModel alloc] init];
    
    NSArray *playlistIds = data[@"playlists"];
    
    if(playlistIds) {
        [model setValue:playlistIds forKey:@"playlistIds"];
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
    
    //Thumbnail
    NSString *thumbnailImageString = data[@"thumbnail"];
    NSData *thumbnailImageData = [[NSData alloc]initWithBase64EncodedString:thumbnailImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailImageData];
    
    [model setValue:thumbnailImage forKey:@"thumbnailImage"];
    
    //User info
    [model setValue:data[@"user"] forKey:@"userName"];
    [model setValue:data[@"relationship_id"] forKey:@"relationshipId"];
#warning WTF
//    [model setValue:data forKey:@"profileImage"]; // WTF?
//    [model setValue:data[@"relationships"] forKey:@"relationships"]; // Again WTF

#warning end WTF
    [model setValue:data[@"video_id"] forKey:@"videoId"];
    [model setValue:data[@"date"] forKey:@"date"];
    
    return model;
}

@end
