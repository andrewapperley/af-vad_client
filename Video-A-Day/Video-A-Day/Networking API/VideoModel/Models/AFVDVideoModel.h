//
//  AFVDVideoModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDVideoModel : NSObject

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong, readonly) NSString *thumbnailURL;
@property (nonatomic, strong, readonly) NSString *videoId;
@property (nonatomic, strong, readonly) NSString *videoURL;
@property (nonatomic, strong, readonly) NSString *relationshipId;
@property (nonatomic, strong, readonly) NSString *userName;

@end
