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
    NSString *tempOutputPath;
    AFVideoCaptureConfig *currentConfig;
}

@end

@implementation AFVideoCaptureController

- (id)initWithConfig:(AFVideoCaptureConfig *)config {
    self = [super init];
    if (self) {
        currentConfig = config;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setOutputURL];
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession beginConfiguration];
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
    
    // setup output properties
    //setup a video output
    if(!cameraOutput) {
        cameraOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    
    //setup preview layer
    previewWindow = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    
    [captureSession addOutput:cameraOutput];
    [self setupVideoOutputProperties];

    [self.view.layer addSublayer:previewWindow];
    
    [captureSession commitConfiguration];
    [captureSession startRunning];

    [self startCapturingVideo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma VideoCapture methods
#pragma -

- (void)previewWindowFrame:(CGRect)newFrame {
    previewWindow.frame = newFrame;
    [self.view.layer layoutSublayers];
}

- (void)setupVideoOutputProperties {
    captureSession.usesApplicationAudioSession = FALSE;
    previewWindow.frame = currentConfig.previewWindowFrame;
    [captureSession setSessionPreset:[currentConfig AFVideoCapturePresetToString:currentConfig.preset]];
    cameraOutput.maxRecordedDuration = currentConfig.maxDurationTime;
}

- (AVCaptureDeviceInput *)videoCameraForDevicePosition:(AVCaptureDevicePosition)position {
    return nil;
}

- (void)setOutputURL {
    tempOutputPath = [[NSString alloc] initWithFormat:@"%@tempOutput.mov", NSTemporaryDirectory()];
}

- (NSURL *)outputURL {
    return [NSURL fileURLWithPath:tempOutputPath];
}

- (void)removeTempVideoOutput {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempOutputPath])
        [[NSFileManager defaultManager] removeItemAtPath:tempOutputPath error:nil];
}

#pragma -
#pragma AFVideoCaptureControlsDelegate Methods
#pragma -

- (void)startCapturingVideo {
    
    if(captureSession.isRunning && cameraOutput.isRecording)
        [cameraOutput stopRecording];
    
    [self removeTempVideoOutput];
    
    [cameraOutput startRecordingToOutputFileURL:[self outputURL] recordingDelegate:self];
    
}

- (void)closeVideoCaptureController {
    [cameraOutput stopRecording];
    [captureSession stopRunning];
}

- (void)recaptureVideo {
    
}

- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)devicePosition {
    if(captureSession.isRunning && cameraOutput.isRecording)
        [cameraOutput stopRecording];
    
    NSArray *devicesAvailable = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *newDevice;
    
    for (AVCaptureDevice *device in devicesAvailable) {
        if (device.position == devicePosition) {
            newDevice = device;
            break;
        }
    }
    
    [captureSession beginConfiguration];
    
    NSError *error;
    
    if (newDevice) {
        [captureSession removeInput:cameraInputDevice];
        cameraInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:&error];
    }

    [captureSession addInput:cameraInputDevice];
    
    [captureSession commitConfiguration];
    
}

#pragma -
#pragma AVCaptureFileOutputRecordingDelegate Methods
#pragma -

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    [self videoCaptureDeviceSwitched:AVCaptureDevicePositionFront];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

- (void)dealloc {

}

@end