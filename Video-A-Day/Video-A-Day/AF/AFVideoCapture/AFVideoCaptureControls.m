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
    UIButton *changeCameraButton;
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
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;

    changeCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 30, 0, 30, 30)];
    changeCameraButton.tag = AVCaptureDevicePositionBack;
    [changeCameraButton setTitle:@"CC" forState:UIControlStateNormal];
    changeCameraButton.backgroundColor = [UIColor yellowColor];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height - 30, 30, 30)];
    [closeButton setTitle:@"C" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor redColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    reRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(40, height - 30, 30, 30)];
    [reRecordButton setTitle:@"RR" forState:UIControlStateNormal];
    reRecordButton.backgroundColor = [UIColor greenColor];
    [reRecordButton addTarget:self action:@selector(reRecordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(80, height - 30, 30, 30)];
    [recordButton setTitle:@"R" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor blueColor];
    [recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize labelSize = [@"10s" sizeWithAttributes: [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:15] forKey: NSFontAttributeName]];
    
    recordingTime = [[UILabel alloc] initWithFrame:CGRectMake(width - labelSize.width - 5, height - labelSize.height - 5, labelSize.width, labelSize.height)];
    recordingTime.textAlignment = NSTextAlignmentCenter;
    recordingTime.textColor = [UIColor whiteColor];
    recordingTime.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    recordingTime.font = [UIFont systemFontOfSize:15];
    recordingTime.text = @"0s";
    
    [self addSubview:changeCameraButton];
    [self addSubview:closeButton];
    [self addSubview:reRecordButton];
    [self addSubview:recordButton];
    [self addSubview:recordingTime];
}

#pragma -
#pragma Button Methods
#pragma -

- (void)changeCameraButtonPressed:(UIButton *)sender {
    AVCaptureDevicePosition device;
    switch (sender.tag) {
        case AVCaptureDevicePositionBack:
            device = sender.tag = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            device = sender.tag = AVCaptureDevicePositionBack;
            break;
    }
    [_delegate videoCaptureDeviceSwitched:device];
}

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

- (void)setRecordingTime:(long long)newTime {
    [recordingTime setText:[NSString stringWithFormat:@"%llds",newTime]];
}

@end