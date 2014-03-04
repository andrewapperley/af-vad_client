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
#import "AFVDVideoCaptureControls.h"

typedef NS_ENUM(NSInteger, AFVideoCapturePreset) {
    AFVideoCapturePreset_Low = 0,
    AFVideoCapturePreset_Medium,
    AFVideoCapturePreset_High,
    AFVideoCapturePreset_640x480
};

@interface AFVDVideoCaptureController : UIViewController <AFVDVideoCaptureControlsDelegate, AVCaptureFileOutputRecordingDelegate>

- (instancetype) initWithMaxDuration:(CMTime)duration andWindowSize:(CGRect)rect andPreset:(AFVideoCapturePreset)lpreset;

+ (instancetype)captureControllerWithDefaults;

- (void)previewWindowFrame:(CGRect)newFrame;

@end