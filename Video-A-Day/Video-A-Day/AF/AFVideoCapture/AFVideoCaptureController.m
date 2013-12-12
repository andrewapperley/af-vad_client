//
//  AFVideoCaptureController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVideoCaptureController.h"

@interface AFVideoCaptureController ()
{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *cameraInputDevice;
    AVCaptureMovieFileOutput *cameraOutput;
    AVCaptureVideoPreviewLayer *previewWindow;
    AFVideoCaptureControls *mainControls;
}

@end

@implementation AFVideoCaptureController

- (void)viewDidLoad
{
    [super viewDidLoad];

    captureSession = [[AVCaptureSession alloc] init];

    //create video input
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        NSError *error;
        cameraInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (cameraInputDevice) {
            if ([captureSession canAddInput:cameraInputDevice]) {
                [captureSession addInput:cameraInputDevice];
            }
        }
    }
    
    //create audio input
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (audioDevice) {
        NSError *error;
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (audioInput) {
            [captureSession addInput:audioInput];
        }
    }
    
    //set session preset
    
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    
    // setup output properties
    
    [self setupVideoOutputProperties];
    
    //setup preview layer
    
    previewWindow = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [previewWindow setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewWindow.frame = CGRectMake(10, 10, 300, 300);
    [self.view.layer addSublayer:previewWindow];
    
    [captureSession startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma VideoCapture methods
#pragma -

- (void)setupVideoOutputProperties {
    
}

- (AVCaptureDeviceInput *)videoCameraForDevicePosition:(AVCaptureDevicePosition)position {
    return nil;
}

#pragma -
#pragma AFVideoCaptureControlsDelegate Methods
#pragma -

- (void)startCapturingVideo {
    
}

- (void)closeVideoCaptureController {
    
}

- (void)recaptureVideo {
    
}

- (void)videoCaptureDeviceSwitched:(NSInteger)device {
    
}

#pragma -
#pragma AVCaptureFileOutputRecordingDelegate Methods
#pragma -

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
}

@end