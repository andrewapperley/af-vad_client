//
//  AFVDInitialView.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFVDInitialViewDelegate <NSObject>

@required
- (void)panelViewIsReady:(__weak UIView *)panel;
- (void)panelViewIsDragged:(CGPoint)panelsPoint closeView:(BOOL)closeView withVelocity:(NSInteger)velocity;
- (void)snapPanelToPositionWithVelocity:(NSInteger)velocity andClosePanel:(BOOL)closePanel;
@end

@interface AFVDInitialView : UIView
{
    UIScrollView* formScrollView;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate;
- (void)setupTitleWithTitle:(NSString *)title;
- (void)setupUI NS_REQUIRES_SUPER;
@property(nonatomic, weak)UIViewController <AFVDInitialViewDelegate>* delegate;
@end