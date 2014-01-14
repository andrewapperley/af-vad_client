//
//  AFVDSignupView.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDInitialView.h"

typedef NS_ENUM(NSInteger, kAFVDSignupFormItems) {
    kAFVDSignupFormItem_Username = 0,
    kAFVDSignupFormItem_Displayname,
    kAFVDSignupFormItem_Password,
    kAFVDSignupFormItem_RePassword,
    kAFVDSignupFormItem_Email
};

@interface AFVDSignupView : AFVDInitialView <UITextFieldDelegate>

@end