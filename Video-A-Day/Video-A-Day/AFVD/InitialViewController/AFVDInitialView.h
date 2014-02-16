//
//  AFVDInitialView.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFVDInitialViewStatics.h"

@class AFVDInitialView;

@protocol AFVDInitialViewDelegate <NSObject>

@required
- (void)panelViewIsReady:(__weak UIView *)panel andSender:(__weak AFVDInitialView *)sender;
- (void)panelViewIsDragged:(CGPoint)panelsPoint closeView:(BOOL)closeView withVelocity:(CGFloat)velocity andSender:(__weak AFVDInitialView *)sender;
- (void)panelViewToSnapToPositionWithVelocity:(NSInteger)velocity andClosePanel:(BOOL)closePanel andSender:(__weak AFVDInitialView *)sender;
@end

@interface AFVDInitialView : UIView <UITextFieldDelegate>
{
    UIScrollView* _formScrollView;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate;
- (void)setupTitleWithTitle:(NSString *)title;
- (void)setupUI NS_REQUIRES_SUPER;
@property(nonatomic, weak)UIViewController <AFVDInitialViewDelegate>* delegate;
@end