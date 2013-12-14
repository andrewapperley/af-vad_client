//
//  AFVideoCaptureControls.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AFVideoCaptureControlsDelegate <NSObject>

@required
- (void)startCapturingVideo;
- (void)closeVideoCaptureController;
- (void)recaptureVideo;
- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)device;

@end

@interface AFVideoCaptureControls : UIView

@property (nonatomic, weak) id <AFVideoCaptureControlsDelegate> delegate;

- (void)changeRecordingButtonState:(BOOL)lrecording;
- (void)setRecordingTime:(NSInteger)newTime;
@end