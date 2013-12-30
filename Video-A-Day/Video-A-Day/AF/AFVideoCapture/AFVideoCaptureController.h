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
#import <MessageUI/MessageUI.h>

typedef enum {
    AFVideoCapturePreset_Low = 0,
    AFVideoCapturePreset_Medium = 1,
    AFVideoCapturePreset_High = 2,
    AFVideoCapturePreset_640x480 = 3
} AFVideoCapturePreset;

@interface AFVideoCaptureController : UIViewController <AFVideoCaptureControlsDelegate, AVCaptureFileOutputRecordingDelegate, MFMailComposeViewControllerDelegate>

- (instancetype) initWithMaxDuration:(CMTime)duration andWindowSize:(CGRect)rect andPreset:(AFVideoCapturePreset)lpreset;

+ (instancetype)initWithDefaultConfig;

- (void)previewWindowFrame:(CGRect)newFrame;

@end