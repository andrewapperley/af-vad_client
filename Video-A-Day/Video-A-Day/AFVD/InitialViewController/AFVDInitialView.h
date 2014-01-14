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
@end

@interface AFVDInitialView : UIView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate;

@property(nonatomic, weak)UIViewController <AFVDInitialViewDelegate>* delegate;
@end