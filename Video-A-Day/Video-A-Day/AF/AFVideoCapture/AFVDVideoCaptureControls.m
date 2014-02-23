//
//  AFVideoCaptureControls.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoCaptureControls.h"

@interface AFVDVideoCaptureControls () {
    UIButton *recordButton;
    UIButton *resetButton;
    UILabel *recordingTime;
    UIButton *changeCameraButton;
    UIButton *closeButton;
}

@end

static NSString* kAFVDVideoCaptureMaxDuration       = @" - 00:20";
static NSString* kAFVDVideoCaptureDefaultDuration   = @"00:00 - 00:20";

@implementation AFVDVideoCaptureControls

- (id)initWithFrame:(CGRect)frame {
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
    
    NSInteger tileSize = 30;

    /*The x/y numbers will change anyways because the placement isnt to any design and is probably wrong so they are magical for now*/
    
    changeCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(width - tileSize, 0, tileSize, tileSize)];
    changeCameraButton.tag = AVCaptureDevicePositionBack;
    [changeCameraButton setTitle:@"CC" forState:UIControlStateNormal];
    changeCameraButton.backgroundColor = [UIColor yellowColor];
    [changeCameraButton addTarget:self action:@selector(changeCameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height - tileSize, tileSize, tileSize)];
    [closeButton setTitle:@"C" forState:UIControlStateNormal];
    closeButton.backgroundColor = [UIColor redColor];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    resetButton = [[UIButton alloc] initWithFrame:CGRectMake(40, height - tileSize, tileSize, tileSize)];
    [resetButton setTitle:@"RS" forState:UIControlStateNormal];
    resetButton.backgroundColor = [UIColor greenColor];
    [resetButton addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(80, height - tileSize, tileSize, tileSize)];
    [recordButton setTitle:@"R" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor blueColor];
    [recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize labelSize = [kAFVDVideoCaptureDefaultDuration sizeWithAttributes: [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:15] forKey: NSFontAttributeName]];
    
    recordingTime = [[UILabel alloc] initWithFrame:CGRectMake(width - labelSize.width - 5, 0, labelSize.width, labelSize.height)];
    recordingTime.textAlignment = NSTextAlignmentCenter;
    recordingTime.textColor = [UIColor whiteColor];
    recordingTime.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0 alpha:0.7f];
    recordingTime.font = [UIFont systemFontOfSize:15];
    recordingTime.text = kAFVDVideoCaptureDefaultDuration;
    
//    [self addSubview:changeCameraButton];
    [self addSubview:closeButton];
    [self addSubview:resetButton];
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

- (void)resetButtonPressed {
    [_delegate recaptureVideo];
}

#pragma -
#pragma Public Methods
#pragma -

- (void)changeRecordingButtonState:(BOOL)lrecording {
    
}

- (void)setRecordingTime:(long long)newTime {
    
    NSString* newTimeString = @"";
    if (newTime < 10) {
        newTimeString = [NSString stringWithFormat:@"0%lld", newTime];
    } else {
        newTimeString = [NSString stringWithFormat:@"%lld", newTime];
    }
    [recordingTime setText:[NSString stringWithFormat:@"00:%@%@", newTimeString,kAFVDVideoCaptureMaxDuration]];
}

@end