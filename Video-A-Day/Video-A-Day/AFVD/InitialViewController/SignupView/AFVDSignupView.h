//
//  AFVDSignupView.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDInitialView.h"
#import "AFVDSignupUserModel.h"

typedef NS_ENUM(NSInteger, AFVDSignupFormItemTypes) {
    AFVDSignupFormItem_Username = 0,
    AFVDSignupFormItem_Email,
    AFVDSignupFormItem_Password,
    AFVDSignupFormItem_RePassword
};

@protocol AFVDSignupDelegate <NSObject>

- (BOOL)validInput:(NSString *)input forType:(AFVDSignupFormItemTypes)type;
- (void)signUserUpWithModel:(AFVDSignupUserModel *)model;


@end

@interface AFVDSignupView : AFVDInitialView <UITextFieldDelegate>

@property(nonatomic, weak)id <AFVDSignupDelegate> signupDelegate;

@end