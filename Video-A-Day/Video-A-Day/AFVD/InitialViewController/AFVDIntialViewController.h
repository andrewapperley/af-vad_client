//
//  AFVDIntialViewController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFViewController.h"
#import "AFVDInitialView.h"
#import "AFVDSigninView.h"
#import "AFVDSignupView.h"

typedef NS_ENUM(NSInteger, AFVDInitialViewOption) {
    AFVDInitialViewOption_Signup = 0,
    AFVDInitialViewOption_Signin = 1
};

@interface AFVDIntialViewController : AFViewController <AFVDInitialViewDelegate, AFVDSignupDelegate>

- (id)initWithBackgroundImage:(UIImage *)backgroundImage;

@end