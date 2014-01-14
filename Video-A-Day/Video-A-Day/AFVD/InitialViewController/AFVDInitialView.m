//
//  AFVD.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDInitialView.h"

@implementation AFVDInitialView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
}

@end