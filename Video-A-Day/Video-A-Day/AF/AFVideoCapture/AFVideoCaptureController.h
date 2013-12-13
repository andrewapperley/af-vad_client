//
//  AFVideoCaptureController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "AFVideoCaptureControls.h"
#import "AFVideoCaptureConfig.h"

@interface AFVideoCaptureController : UIViewController <AFVideoCaptureControlsDelegate, AVCaptureFileOutputRecordingDelegate>

- (id)initWithConfig:(AFVideoCaptureConfig *)config;

- (void)previewWindowFrame:(CGRect)newFrame;

@end