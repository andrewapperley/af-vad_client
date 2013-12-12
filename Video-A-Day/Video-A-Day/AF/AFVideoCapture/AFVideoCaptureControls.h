//
//  AFVideoCaptureControls.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureDevice;
@protocol AFVideoCaptureControlsDelegate <NSObject>

@required
- (void)startCapturingVideo;
- (void)closeVideoCaptureController;
- (void)recaptureVideo;
- (void)videoCaptureDeviceSwitched:(NSInteger)device;

@end

@interface AFVideoCaptureControls : UIView

@end