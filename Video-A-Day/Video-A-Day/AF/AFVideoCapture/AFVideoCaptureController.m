//
//  AFVideoCaptureController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVideoCaptureController.h"
#import "AFVDVideoFilterController.h"

static const CGFloat kDurationBroadcastFrequency = 0.5f;

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
    NSTimer *recordedDurationTimer;
    UIButton *shareButton;
    UIButton *addFilterButton;
    CGSize _videoDimensions;
    
    /*Preview controller that plays the file which was just recorded - This is so they have a preview with audio*/
    AVPlayer *previewPlayer;
    AVPlayerLayer *previewPlayerLayer;
}

@end

@implementation AFVideoCaptureController

- (instancetype) initWithMaxDuration:(CMTime)duration andWindowSize:(CGRect)rect andPreset:(AFVideoCapturePreset)lpreset{
    self = [super init];
    if (self) {
        maxDurationTime = duration;
        previewWindowFrame = rect;
        preset = lpreset;
    }
    return self;
}

+ (instancetype)captureControllerWithDefaults {
    return [[AFVideoCaptureController alloc] initWithMaxDuration:CMTimeMake(600, 30) andWindowSize:CGRectMake(10, 30, 300, 300) andPreset:AFVideoCapturePreset_Medium];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOutputURL];
    
    captureSession = [[AVCaptureSession alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(grabVideoDimensions:) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
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
        if (audioInput && !error) {
            if([captureSession canAddInput:audioInput]) {
                [captureSession addInput:audioInput];
            }
        }
    }
    
    // setup output properties
    //setup a video output
    if(!cameraOutput) {
        cameraOutput = [[AVCaptureMovieFileOutput alloc] init];
    }

    //setup preview layer
    previewWindow = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    
    //setup the final preview for the recorded video file
    previewPlayer = [[AVPlayer alloc] initWithURL:nil];
    
    previewPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previewDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    previewPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:previewPlayer];
    previewPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewPlayerLayer.frame = previewWindowFrame;
    
    [self.view.layer addSublayer:previewPlayerLayer];
    
    [self setupVideoOutputProperties];

    if ( [captureSession canAddOutput:cameraOutput] ) {
        [captureSession addOutput:cameraOutput];
    }
    
    [self.view.layer addSublayer:previewWindow];
    
    [captureSession commitConfiguration];
    [captureSession startRunning];

    //setup controls
    mainControls = [[AFVideoCaptureControls alloc] initWithFrame:CGRectMake(previewWindowFrame.origin.x, previewWindowFrame.origin.y, previewWindowFrame.size.width, previewWindowFrame.size.height)];
    mainControls.delegate = self;
    [self.view addSubview:mainControls];
    [self addShareAndFilterButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma Setup Properties

- (NSString *)AFVideoCapturePresetToString:(AFVideoCapturePreset)lpreset {
    NSArray *AFVideoCapturePresets = @[@"AVCaptureSessionPresetLow", @"AVCaptureSessionPresetMedium", @"AVCaptureSessionPresetHigh", @"AFVideoCapturePreset_640x480"];
    return AFVideoCapturePresets[lpreset];
}

- (void)setupVideoOutputProperties {
    previewWindow.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewWindow.delegate = self;
    previewWindow.frame = previewWindowFrame;
    if ([previewWindow.connection isVideoOrientationSupported])
    {
        [previewWindow.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    [captureSession setSessionPreset:[self AFVideoCapturePresetToString:preset]];

    cameraOutput.maxRecordedDuration = maxDurationTime;
}

#pragma -
#pragma VideoCapture methods
#pragma -

- (void)previewWindowFrame:(CGRect)newFrame {
    previewWindow.frame = newFrame;
    [self.view.layer layoutSublayers];
}

- (void)setOutputURL {
    tempOutputPath = [[NSString alloc] initWithFormat:@"%@tempOutput.m4v", NSTemporaryDirectory()];
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
    
    /*Stop the recording if it's in progress and show the share / add filter buttons*/
    if(captureSession.isRunning && cameraOutput.isRecording) {
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
            previewWindow.opacity = 0;
        } completion:^(BOOL finished) {
            [cameraOutput stopRecording];
            [captureSession stopRunning];
            [self showFilterShareButtons:TRUE];
            [previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[self outputURL]]];
            [previewPlayer play];
            NSLog(@"Recording Stopped");
        }];
        return;
    }
    
    NSLog(@"recording");
    
    if (!captureSession.isRunning) {
        [captureSession startRunning];
    }
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
        previewWindow.opacity = 1;
    } completion:^(BOOL finished) {
        [previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:nil]];
        [previewPlayer pause];
    }];
    
    [self removeTempVideoOutput];
    
    [cameraOutput startRecordingToOutputFileURL:[self outputURL] recordingDelegate:self];
    [recordedDurationTimer invalidate];
    recordedDurationTimer = nil;
    recordedDurationTimer = [NSTimer scheduledTimerWithTimeInterval:kDurationBroadcastFrequency target:self selector:@selector(broadcastRecordedDuration) userInfo:nil repeats:TRUE];
    
    [self showFilterShareButtons:FALSE];
    
}

- (void)broadcastRecordedDuration {
    [mainControls setRecordingTime:(cameraOutput.recordedDuration.value/cameraOutput.recordedDuration.timescale)];
}

- (void)closeVideoCaptureController {
    
    /*THIS DOESNT WORK BECAUSE WE NEED TO SETUP VC STUFF*/
    
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

- (void)grabVideoDimensions:(NSNotification *)event {
    AVCaptureInputPort *port = event.object;
    CMFormatDescriptionRef formatDescription = port.formatDescription;
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription);
    _videoDimensions = CGSizeMake(dimensions.height, dimensions.width);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
}

- (void)recaptureVideo {
    if (recordedDurationTimer.isValid) {
        [recordedDurationTimer invalidate];
        recordedDurationTimer = nil;
    }
    if (cameraOutput.isRecording) {
         [cameraOutput stopRecording];
    }
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut animations:^{
        previewWindow.opacity = 1;
    } completion:^(BOOL finished) {
        [captureSession startRunning];
        [previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:nil]];
        [previewPlayer pause];
        NSLog(@"Recording Reset");
    }];
    
    [mainControls setRecordingTime:0];
    [self removeTempVideoOutput];
    [self showFilterShareButtons:FALSE];
}

- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)devicePosition {
    
    [mainControls setRecordingTime:0];
    
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
#pragma UI Update Methods
#pragma -

- (void)showFilterShareButtons:(BOOL)show {
    if (show) {
        addFilterButton.enabled = shareButton.enabled = TRUE;
        addFilterButton.alpha = shareButton.alpha = 1;
    } else {
        addFilterButton.enabled = shareButton.enabled = FALSE;
        addFilterButton.alpha = shareButton.alpha = 0.3f;
    }
}

- (void)addShareAndFilterButtons {
    addFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 370, 145, 40)];
    addFilterButton.backgroundColor = [UIColor redColor];
    [addFilterButton setTitle:@"Add FIlter" forState:UIControlStateNormal];
    [addFilterButton addTarget:self action:@selector(addFilterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(addFilterButton.frame.size.width + 15, 370, 145, 40)];
    shareButton.backgroundColor = [UIColor purpleColor];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self showFilterShareButtons:FALSE];
    
    [self.view addSubview:addFilterButton];
    [self.view addSubview:shareButton];
}

#pragma -
#pragma Share / Add Filter Button Methods
#pragma -

- (void)shareButtonClicked {
    NSLog(@"Share");
}

- (void)addFilterButtonClicked {
    /*Invalidate the timer, stop the recording and session*/
    [recordedDurationTimer invalidate];
    recordedDurationTimer = nil;
    [cameraOutput stopRecording];
    [captureSession stopRunning];
    
    /*Present filter view controller and dismiss this view controller*/
    
    AFVDVideoFilterController *videoFilterView = [[AFVDVideoFilterController alloc] initWithVideoURL:[self outputURL] andMovieSize:_videoDimensions];
    [self.navigationController presentViewController:videoFilterView animated:TRUE completion:nil];
    
    [self removeFromParentViewController];
}

#pragma -
#pragma AVCaptureFileOutputRecordingDelegate Methods
#pragma -

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    if([error.userInfo[@"NSLocalizedFailureReason"] isEqualToString:@"The recording reached the maximum allowable length."]) {
        [recordedDurationTimer invalidate];
        recordedDurationTimer = nil;
        [mainControls setRecordingTime:(maxDurationTime.value/maxDurationTime.timescale)];
    }
    switch (error.code) {
        /*This code is for when switching devices while recording*/
        case -11818:
            return;
            break;
            
        /*This error code is for when we have completed a recording*/
        case -11810:
            [cameraOutput stopRecording];
            [self showFilterShareButtons:TRUE];
            NSLog(@"Recording Stopped");
            return;
            break;
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

#pragma -
#pragma Preview Player Notifications
#pragma -

- (void)previewDidReachEnd:(NSNotification *)event {
    AVPlayerItem *p = [event object];
    [p seekToTime:kCMTimeZero];
    [previewPlayer play];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    mainControls.delegate = nil;
    [recordedDurationTimer invalidate];
    recordedDurationTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:previewPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end