//
//  AFVDVideoModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDVideoModel : NSObject

@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *relationshipId;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *videoId;

@end
