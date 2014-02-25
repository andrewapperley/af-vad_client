//
//  AFVideoCaptureControls.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AFVDPopoutMenuViewController;

@protocol AFVDVideoCaptureControlsDelegate <NSObject>

@required
- (void)startCapturingVideo;
- (void)closeVideoCaptureController;
- (void)recaptureVideo;
- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)device;

@end

@interface AFVDVideoCaptureControls : UIView

@property(nonatomic, weak) id <AFVDVideoCaptureControlsDelegate> delegate;
@property(nonatomic, strong) AFVDPopoutMenuViewController* menu;

- (id)initWithFrame:(CGRect)frame sizeOfPreviewScreen:(CGSize)previewSize;

- (void)changeRecordingButtonState:(BOOL)lrecording;
- (void)setRecordingTime:(long long)newTime;

@end