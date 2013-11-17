//
//  AFVDVideoPlaylistModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDVideoPlaylistModel : NSObject

@property (nonatomic) NSUInteger totalNumberOfPages;
@property (nonatomic, strong, readonly) NSArray *videos;        //Contains AFVDVideoModels

@end
