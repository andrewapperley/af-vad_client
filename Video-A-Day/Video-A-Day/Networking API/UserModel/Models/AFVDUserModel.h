//
//  AFVDUserModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDUserModel : NSObject

@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) UIImage *profileImage;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSArray *relationships;

@end
