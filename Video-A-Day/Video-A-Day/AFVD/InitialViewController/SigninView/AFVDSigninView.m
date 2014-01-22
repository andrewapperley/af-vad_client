//
//  AFVDSigninView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSigninView.h"

@implementation AFVDSigninView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    self = [super initWithFrame:frame andDelegate:delegate];
    if (self) {
        
        [self.delegate panelViewIsReady:self];
    }
    return self;
}

#pragma mark - UI Setup Methods

- (void)setupUI {
    [super setupUI];
    [self setupTitleWithTitle:NSLocalizedString(@"AFVDInitialViewSignIn", nil)];
    [self setupForm];
}

- (void)setupForm {
    
}

@end