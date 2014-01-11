//
//  AFVDIntialViewController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFViewController.h"

typedef NS_ENUM(NSInteger, AFVDInitialViewOption) {
    AFVDInitialViewOption_Signup = 0,
    AFVDInitialViewOption_Signin = 1
};

@interface AFVDIntialViewController : AFViewController

- (id)initWithBackgroundImage:(UIImage *)backgroundImage;

@end