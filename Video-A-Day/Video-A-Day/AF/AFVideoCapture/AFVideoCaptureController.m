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
    CMTime maxDurationTime;
    CGRect previewWindowFrame;
    AFVideoCapturePreset preset;
    AVCaptureVideoDataOutput *videoDataOutput;
    dispatch_queue_t videoDataOutputQueue;
    NSTimer *recordedDurationTimer;
}

@end

@implementation AFVideoCaptureController

- (instancetype) initWithMaxDuration:(CMTime)duration andWindowSize:(CGRect)rect andPreset:(AFVideoCapturePreset)lpreset{
    self = [super init];
    if (self) {
        maxDurationTime = duration;
        previewWindowFrame = rect;
        preset = lpreset;

        [[NSNotificationCenter defaultCenter] addObserver:self
                               selector:@selector(deviceOrientationDidChange)
                                   name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)initWithDefaultConfig {
    return [[AFVideoCaptureController alloc] initWithMaxDuration:CMTimeMake(300, 30) andWindowSize:CGRectMake(10, 30, 300, 300) andPreset:AFVideoCapturePreset_Medium];
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
        [cameraOutput addObserver:self forKeyPath:@"recordedDuration" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    if (!videoDataOutput) {
        videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    }
    
    //setup preview layer
    previewWindow = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];

    [captureSession addOutput:cameraOutput];
    [self setupVideoOutputProperties];

    [self.view.layer addSublayer:previewWindow];
    
    [captureSession commitConfiguration];
    [captureSession startRunning];

    //setup controls
    mainControls = [[AFVideoCaptureControls alloc] initWithFrame:CGRectMake(previewWindowFrame.origin.x, previewWindowFrame.origin.y, previewWindowFrame.size.width, previewWindowFrame.size.height)];
    mainControls.delegate = self;
    [self.view addSubview:mainControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma Setup Properties

- (NSString *)AFVideoCapturePresetToString:(AFVideoCapturePreset)lpreset {
    NSArray *AFVideoCapturePresets = @[@"AVCaptureSessionPresetLow", @"AVCaptureSessionPresetMedium", @"AVCaptureSessionPresetHigh"];
    return AFVideoCapturePresets[lpreset];
}

- (void)setupVideoOutputProperties {
    captureSession.usesApplicationAudioSession = FALSE;
    previewWindow.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewWindow.delegate = self;
    previewWindow.frame = previewWindowFrame;
    if ([previewWindow.connection isVideoOrientationSupported])
    {
        [previewWindow.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    [captureSession setSessionPreset:[self AFVideoCapturePresetToString:preset]];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    cameraOutput.maxRecordedDuration = maxDurationTime;
    if ( [captureSession canAddOutput:videoDataOutput] )
        [captureSession addOutput:videoDataOutput];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
}

#pragma -
#pragma VideoCapture methods
#pragma -

- (void)previewWindowFrame:(CGRect)newFrame {
    previewWindow.frame = newFrame;
    [self.view.layer layoutSublayers];
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
    NSLog(@"recording");
    //make recording button blink or something
    if(captureSession.isRunning && cameraOutput.isRecording)
        [cameraOutput stopRecording];
    
    [self removeTempVideoOutput];
    
    [cameraOutput startRecordingToOutputFileURL:[self outputURL] recordingDelegate:self];
    recordedDurationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(broadcastRecordedDuration) userInfo:nil repeats:TRUE];
    
}

- (void)broadcastRecordedDuration {
    [mainControls setRecordingTime:(cameraOutput.recordedDuration.value/cameraOutput.recordedDuration.timescale)];
}

- (void)closeVideoCaptureController {
    NSLog(@"closing");
    [cameraOutput stopRecording];
    [captureSession stopRunning];
//    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    //Temp
    [UIView animateWithDuration:0.5f animations:^(){
        self.view.bounds = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)recaptureVideo {
    //reset timer text to 00:00
    [mainControls setRecordingTime:0];
    [self startCapturingVideo];
}

- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)devicePosition {
    
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

- (void)deviceOrientationDidChange {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    AVCaptureVideoOrientation newOrientation;
    
    if (deviceOrientation == UIDeviceOrientationPortrait){
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown){
        newOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    
    // AVCapture and UIDevice have opposite meanings for landscape left and right (AVCapture orientation is the same as UIInterfaceOrientation)
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft){
        newOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight){
        newOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    else if (deviceOrientation == UIDeviceOrientationUnknown){
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    else{
        newOrientation = AVCaptureVideoOrientationPortrait;
    }
    
    [previewWindow.connection setVideoOrientation:newOrientation];
}

#pragma -
#pragma AVCaptureFileOutputRecordingDelegate Methods
#pragma -

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if([error.userInfo[@"NSLocalizedFailureReason"] isEqualToString:@"The recording reached the maximum allowable length."])
        [mainControls setRecordingTime:(maxDurationTime.value/maxDurationTime.timescale)];
    [recordedDurationTimer invalidate];
    recordedDurationTimer = nil;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

- (void)dealloc {
    mainControls.delegate = nil;
    [recordedDurationTimer invalidate];
    recordedDurationTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end