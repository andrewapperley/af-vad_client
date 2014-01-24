//
//  AFVDSigninView.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDInitialView.h"

@class AFVDSigninUserModel;

typedef NS_ENUM(NSInteger, AFVDSigninFormItemTypes) {
    AFVDSigninFormItem_Username = 0,
    AFVDSigninFormItem_Password
};

@protocol AFVDSigninDelegate <NSObject>
@required
- (void)signUserInWithModel:(AFVDSigninUserModel *)model;

@end

@interface AFVDSigninView : AFVDInitialView

@property(nonatomic, weak)id <AFVDSigninDelegate> signinDelegate;

@end