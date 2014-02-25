//
//  AFVideoCaptureControls.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoCaptureControls.h"
#import "AFVDPopoutMenuMenuItem.h"
#import "AFVDPopoutMenuStatics.h"
#import "AFVDPopoutMenuControllerModel.h"
#import "AFVDPopoutMenuViewController.h"

@interface AFVDVideoCaptureControls () {
    UIButton *_recordButton;
    UILabel *recordingTime;
    CGSize _previewSize;
}

@end

static NSString* kAFVDVideoCaptureMaxDuration       = @" - 00:20";
static NSString* kAFVDVideoCaptureDefaultDuration   = @"00:00 - 00:20";
NSInteger const kAFVDVideoCaptureButtonYMargin      = 10;

@implementation AFVDVideoCaptureControls

- (id)initWithFrame:(CGRect)frame sizeOfPreviewScreen:(CGSize)previewSize {
    self = [super initWithFrame:frame];
    if (self) {
        _previewSize = previewSize;
        [self setupButtons];
        [self setupMenu];
    }
    return self;
}

- (void)setupButtons {
    
//    UIImage *closeImage = [UIImage imageNamed:@""];
    UIImage *recordImage = [UIImage imageNamed:@"AFVDVideoCaptureRecordButton"];
//    UIImage *reRecordImage = [UIImage imageNamed:@""];
    
//    CGFloat height      = self.bounds.size.height;
    CGFloat width       = self.bounds.size.width;
    
//    NSInteger tileSize = 30;
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((_previewSize.width - recordImage.size.width)/2, _previewSize.height + kAFVDVideoCaptureButtonYMargin, recordImage.size.width, recordImage.size.height)];
    [_recordButton setImage:recordImage forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize labelSize = [kAFVDVideoCaptureDefaultDuration sizeWithAttributes: [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:15] forKey: NSFontAttributeName]];
    
    recordingTime = [[UILabel alloc] initWithFrame:CGRectMake(width - labelSize.width - 5, 0, labelSize.width, labelSize.height)];
    recordingTime.textAlignment = NSTextAlignmentCenter;
    recordingTime.textColor = [UIColor whiteColor];
    recordingTime.backgroundColor = [UIColor clearColor];
    recordingTime.font = [UIFont systemFontOfSize:15];
    recordingTime.text = kAFVDVideoCaptureDefaultDuration;
    
    [self addSubview:recordingTime];
    [self addSubview:_recordButton];
}

- (void)setupMenu {
    
    /*Make close button external and do animation for close/open internal*/
    
    AFVDPopoutMenuControllerModel* menuModel = [[AFVDPopoutMenuControllerModel alloc] initWithIcons:@[[UIImage imageNamed:@"AFVDProfileImageSelector"], [UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"], [UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"],[UIImage imageNamed:@"AFVDProfileImageSelector"]] titles:@[@"test"] selectors:@[@"itemSelected:", @"itemSelected:", @"itemSelected:", @"itemSelected:", @"itemSelected:", @"itemSelected:"] properties:@[@"GPUImageVignetteFilter", @"GPUImageVignetteFilter", @"GPUImageVignetteFilter", @"GPUImageVignetteFilter"]];
    
    _menu = [[AFVDPopoutMenuViewController alloc] initWithModel:menuModel frame:CGRectMake(_menu.view.frame.origin.x, self.frame.size.height - kAFVDPopoutMenuCollectionViewCellIconSize - kAFVDVideoCaptureButtonYMargin, self.frame.size.width, kAFVDPopoutMenuCollectionViewCellIconSize)];
    _menu.delegate   = self;

    [self addSubview:_menu.view];
}

#pragma -
#pragma Button Methods
#pragma -

- (void)popoutMenuCloseButtonPressed {
    [_menu closeMenu];
}

- (void)changeCameraButtonPressed:(AFVDPopoutMenuMenuItem *)sender {
    AVCaptureDevicePosition device;
    NSInteger newMenuProperty;
    
    switch ([sender.menuItemProperty integerValue]) {
        case AVCaptureDevicePositionBack:
            device = newMenuProperty = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            device = newMenuProperty = AVCaptureDevicePositionBack;
            break;
    }
    
    [sender setMenuItemProperty:@(newMenuProperty)];
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