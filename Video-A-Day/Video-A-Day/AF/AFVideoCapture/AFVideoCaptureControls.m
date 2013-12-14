//
//  AFVideoCaptureControls.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVideoCaptureControls.h"

@interface AFVideoCaptureControls ()
{
    UIButton *recordButton;
    UIButton *reRecordButton;
    UILabel *recordingTime;
    UIButton *closeButton;
}

@end

@implementation AFVideoCaptureControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButtons];
    }
    return self;
}

- (void)setupButtons {
    
//    UIImage *closeImage = [UIImage imageNamed:@""];
//    UIImage *recordImage = [UIImage imageNamed:@""];
//    UIImage *reRecordImage = [UIImage imageNamed:@""];
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setTitle:@"C" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor redColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    reRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 30, 30)];
    [reRecordButton setTitle:@"RR" forState:UIControlStateNormal];
    reRecordButton.backgroundColor = [UIColor greenColor];
    [reRecordButton addTarget:self action:@selector(reRecordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 30, 30)];
    [recordButton setTitle:@"R" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor blueColor];
    [recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:closeButton];
    [self addSubview:reRecordButton];
    [self addSubview:recordButton];
}

#pragma -
#pragma Button Methods
#pragma -

- (void)closeButtonPressed {
    [_delegate closeVideoCaptureController];
}

- (void)recordButtonPressed {
    [_delegate startCapturingVideo];
}

- (void)reRecordButtonPressed {
    [_delegate recaptureVideo];
}

#pragma -
#pragma Public Methods
#pragma -

- (void)changeRecordingButtonState:(BOOL)lrecording {
    
}

- (void)setRecordingTime:(NSInteger)newTime {
    
}

@end