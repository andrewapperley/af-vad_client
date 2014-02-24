//
//  AFVideoCaptureController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoCaptureController.h"
#import "AFVDVideoFilterController.h"

static const CGFloat kDurationBroadcastFrequency = 0.5f;
static const CGFloat kPreviewViewAnimationDuration = 0.5f;

@interface AFVDVideoCaptureController () {
    AVCaptureSession* _captureSession;
    AVCaptureDeviceInput* _cameraInputDevice;
    AVCaptureMovieFileOutput* _cameraOutput;
    AVCaptureVideoPreviewLayer* _previewWindow;
    UIImageView* _backgroundLayer;
    AFVDVideoCaptureControls* _mainControls;
    NSString* _tempOutputPath;
    CMTime _maxDurationTime;
    CGRect _previewWindowFrame;
    AFVideoCapturePreset _preset;
    NSTimer* _recordedDurationTimer;
    UIButton* _shareButton;
    UIButton* _addFilterButton;
    CGSize _videoDimensions;
    
    /*Preview controller that plays the file which was just recorded - This is so they have a preview with audio*/
    AVPlayer* _previewPlayer;
    AVPlayerLayer* _previewPlayerLayer;
}

@end

@implementation AFVDVideoCaptureController

- (instancetype) initWithMaxDuration:(CMTime)duration andWindowSize:(CGRect)rect andPreset:(AFVideoCapturePreset)lpreset{
    self = [super init];
    if (self) {
        _maxDurationTime = duration;
        _previewWindowFrame = rect;
        _preset = lpreset;
    }
    return self;
}

+ (instancetype)captureControllerWithDefaults {
    return [[AFVDVideoCaptureController alloc] initWithMaxDuration:CMTimeMake(600, 30) andWindowSize:CGRectMake(10, 30, 300, 300) andPreset:AFVideoCapturePreset_High];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOutputURL];
    
    _captureSession = [[AVCaptureSession alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(grabVideoDimensions:) name:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil];
    [_captureSession beginConfiguration];
    //create video input
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        NSError *error;
        _cameraInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (_cameraInputDevice) {
            if ([_captureSession canAddInput:_cameraInputDevice]) {
                [_captureSession addInput:_cameraInputDevice];
            }
        }
    }
    
    //create audio input
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (audioDevice) {
        NSError *error;
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        if (audioInput && !error) {
            if([_captureSession canAddInput:audioInput]) {
                [_captureSession addInput:audioInput];
            }
        }
    }
    
    // setup output properties
    //setup a video output
    if(!_cameraOutput) {
        _cameraOutput = [[AVCaptureMovieFileOutput alloc] init];
    }

    //setup preview layer
    _previewWindow              = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewWindow.borderColor  = UIColorFromRGBA(100, 100, 100, 1).CGColor;
    _previewWindow.borderWidth  = 1;
    
    //background preview layer
    _backgroundLayer = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"AFVDFieldBackground"] applyAFVDBackgroundBlur]];
    [self.view addSubview:_backgroundLayer];

    //setup the final preview for the recorded video file
    _previewPlayer = [[AVPlayer alloc] initWithURL:nil];
    
    _previewPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(previewDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    _previewPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_previewPlayer];
    _previewPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewPlayerLayer.frame = _previewWindowFrame;
    
    [self.view.layer addSublayer:_previewPlayerLayer];
    
    [self setupVideoOutputProperties];

    if ( [_captureSession canAddOutput:_cameraOutput] ) {
        [_captureSession addOutput:_cameraOutput];
    }
    
    [self.view.layer addSublayer:_previewWindow];
    [self applyCornersToPreview];
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];

    //setup controls
    _mainControls = [[AFVDVideoCaptureControls alloc] initWithFrame:CGRectMake(_previewWindowFrame.origin.x, _previewWindowFrame.origin.y, _previewWindowFrame.size.width, _previewWindowFrame.size.height)];
    _mainControls.delegate = self;
    [self.view addSubview:_mainControls];
//    [self addShareAndFilterButtons];
}

- (void)applyCornersToPreview {
    NSInteger borderWidth   = 3;
    NSInteger borderHeight  = 27;
    
    CAShapeLayer* cornerShapes  = [[CAShapeLayer alloc] init];
    cornerShapes.frame          = CGRectMake(_previewWindowFrame.origin.x - borderWidth/2, _previewWindowFrame.origin.y - borderWidth/2, _previewWindowFrame.size.width + borderWidth, _previewWindowFrame.size.height + borderWidth);
//    cornerShapes.opacity        = 0.8f;
    cornerShapes.strokeColor    = [UIColor clearColor].CGColor;
    cornerShapes.fillColor      = UIColorFromRGBA(200, 200, 200, 1.0f).CGColor;
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    
    
    [path moveToPoint:CGPointMake(0, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, borderHeight)];
    
    [path moveToPoint:CGPointMake(cornerShapes.frame.size.width, borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, 0)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, borderHeight)];
    
    [path moveToPoint:CGPointMake(cornerShapes.frame.size.width, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderWidth, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width - borderHeight, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.width, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(cornerShapes.frame.size.height, cornerShapes.frame.size.height - borderHeight)];

    [path moveToPoint:CGPointMake(0, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, cornerShapes.frame.size.height - borderHeight)];
    [path addLineToPoint:CGPointMake(borderWidth, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, cornerShapes.frame.size.height - borderWidth)];
    [path addLineToPoint:CGPointMake(borderHeight, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, cornerShapes.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, cornerShapes.frame.size.height - borderHeight)];
    
    [path closePath];
    
    cornerShapes.path = path.CGPath;
    
    [self.view.layer addSublayer:cornerShapes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -
#pragma mark - Setup Properties

- (NSString *)AFVideoCapturePresetToString:(AFVideoCapturePreset)lpreset {
    NSArray *AFVideoCapturePresets = @[@"AVCaptureSessionPresetLow", @"AVCaptureSessionPresetMedium", @"AVCaptureSessionPresetHigh", @"AFVideoCapturePreset_640x480"];
    return AFVideoCapturePresets[lpreset];
}

- (void)setupVideoOutputProperties {
    _previewWindow.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewWindow.delegate = self;
    _previewWindow.frame = _previewWindowFrame;
    if ([_previewWindow.connection isVideoOrientationSupported]) {
        [_previewWindow.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [_previewWindow.connection setAutomaticallyAdjustsVideoMirroring:FALSE];
    [_previewWindow.connection setVideoMirrored:FALSE];
    
    [_captureSession setSessionPreset:[self AFVideoCapturePresetToString:_preset]];

    _cameraOutput.maxRecordedDuration = _maxDurationTime;
}

#pragma -
#pragma mark - VideoCapture methods
#pragma -

- (void)previewWindowFrame:(CGRect)newFrame {
    _previewWindow.frame = newFrame;
    [self.view.layer layoutSublayers];
}

- (void)setOutputURL {
    _tempOutputPath = [[NSString alloc] initWithFormat:@"%@tempOutput.m4v", NSTemporaryDirectory()];
}

- (NSURL *)outputURL {
    return [NSURL fileURLWithPath:_tempOutputPath];
}

- (void)removeTempVideoOutput {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_tempOutputPath])
        [[NSFileManager defaultManager] removeItemAtPath:_tempOutputPath error:nil];
}

#pragma -
#pragma mark - AFVideoCaptureControlsDelegate Methods
#pragma -

- (void)startCapturingVideo {
    
    /*Stop the recording if it's in progress and show the share / add filter buttons*/
    if(_captureSession.isRunning && _cameraOutput.isRecording) {
        [UIView animateWithDuration:kPreviewViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations:^{
            _previewWindow.opacity = 0;
        } completion:^(BOOL finished) {
            [_cameraOutput stopRecording];
            [_captureSession stopRunning];
            [self showFilterShareButtons:TRUE];
            [_previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[self outputURL]]];
            [_previewPlayer play];
            NSLog(@"Recording Stopped");
        }];
        return;
    }
    
    NSLog(@"recording");
    
    if (!_captureSession.isRunning) {
        [_captureSession startRunning];
    }
    
    [UIView animateWithDuration:kPreviewViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations:^{
        _previewWindow.opacity = 1;
    } completion:^(BOOL finished) {
        [_previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:nil]];
        [_previewPlayer pause];
    }];
    
    [self removeTempVideoOutput];
    
    [_cameraOutput startRecordingToOutputFileURL:[self outputURL] recordingDelegate:self];
    [_recordedDurationTimer invalidate];
    _recordedDurationTimer = nil;
    _recordedDurationTimer = [NSTimer scheduledTimerWithTimeInterval:kDurationBroadcastFrequency target:self selector:@selector(broadcastRecordedDuration) userInfo:nil repeats:TRUE];
    
    [self showFilterShareButtons:FALSE];
    
}

- (void)broadcastRecordedDuration {
    [_mainControls setRecordingTime:(_cameraOutput.recordedDuration.value/_cameraOutput.recordedDuration.timescale)];
}

- (void)closeVideoCaptureController {
    
    /*THIS DOESNT WORK BECAUSE WE NEED TO SETUP VC STUFF*/
    
    NSLog(@"closing");
    [_cameraOutput stopRecording];
    [_captureSession stopRunning];
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
    if (_recordedDurationTimer.isValid) {
        [_recordedDurationTimer invalidate];
        _recordedDurationTimer = nil;
    }
    if (_cameraOutput.isRecording) {
         [_cameraOutput stopRecording];
    }
    
    if (_previewPlayer.currentItem) {
        [UIView animateWithDuration:kPreviewViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations:^{
            _previewWindow.opacity = 1;
        } completion:^(BOOL finished) {
            if (!_captureSession.isRunning) {
                [_captureSession startRunning];
            }
            [_previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:nil]];
            [_previewPlayer pause];
            NSLog(@"Recording Reset");
        }];
    }
    
    [_mainControls setRecordingTime:0];
    [self removeTempVideoOutput];
    [self showFilterShareButtons:FALSE];
}

- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)devicePosition {
    
    if (_recordedDurationTimer.isValid) {
        [_recordedDurationTimer invalidate];
        _recordedDurationTimer = nil;
    }
    
    if (_cameraOutput.isRecording) {
        [_cameraOutput stopRecording];
    }
    
    [_mainControls setRecordingTime:0];
    [self removeTempVideoOutput];
    [self showFilterShareButtons:FALSE];
    
    NSArray *devicesAvailable = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *newDevice;
    
    for (AVCaptureDevice *device in devicesAvailable) {
        if (device.position == devicePosition) {
            newDevice = device;
            break;
        }
    }
    [_captureSession stopRunning];
    [_captureSession beginConfiguration];
    
    NSError *error;
    
    if (newDevice) {
        [_captureSession removeInput:_cameraInputDevice];
        _cameraInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:&error];
        if (error) {
            NSAssert(!error, error.localizedDescription);
            return;
        }
    }

    [_captureSession addInput:_cameraInputDevice];
    
    [_captureSession commitConfiguration];
    [_captureSession startRunning];
    
    if (_previewPlayer.currentItem) {
        [UIView animateWithDuration:kPreviewViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations:^{
            _previewWindow.opacity = 1;
        } completion:^(BOOL finished) {
            [_previewPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:nil]];
            [_previewPlayer pause];
            NSLog(@"Camera Switched");
        }];
    }
    
} 

#pragma -
#pragma mark - UI Update Methods
#pragma -

- (void)showFilterShareButtons:(BOOL)show {
    if (show) {
        _addFilterButton.enabled = _shareButton.enabled = TRUE;
        _addFilterButton.alpha = _shareButton.alpha = 1;
    } else {
        _addFilterButton.enabled = _shareButton.enabled = FALSE;
        _addFilterButton.alpha = _shareButton.alpha = 0.3f;
    }
}

- (void)addShareAndFilterButtons {
    _addFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 370, 145, 40)];
    _addFilterButton.backgroundColor = [UIColor redColor];
    [_addFilterButton setTitle:@"Add FIlter" forState:UIControlStateNormal];
    [_addFilterButton addTarget:self action:@selector(addFilterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(_addFilterButton.frame.size.width + 15, 370, 145, 40)];
    _shareButton.backgroundColor = [UIColor purpleColor];
    [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self showFilterShareButtons:FALSE];
    
    [self.view addSubview:_addFilterButton];
    [self.view addSubview:_shareButton];
}

#pragma -
#pragma mark - Share / Add Filter Button Methods
#pragma -

- (void)shareButtonClicked {
    NSLog(@"Share");
}

- (void)addFilterButtonClicked {
    /*Invalidate the timer, stop the recording and session*/
    [_recordedDurationTimer invalidate];
    _recordedDurationTimer = nil;
    [_cameraOutput stopRecording];
    [_captureSession stopRunning];
    
    /*Present filter view controller and dismiss this view controller*/
    
    AFVDVideoFilterController *videoFilterView = [[AFVDVideoFilterController alloc] initWithVideoURL:[self outputURL] andMovieSize:_videoDimensions];
    [self.navigationController presentViewController:videoFilterView animated:TRUE completion:nil];
    
    [self removeFromParentViewController];
}

#pragma -
#pragma mark - AVCaptureFileOutputRecordingDelegate Methods
#pragma -

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    if([error.userInfo[@"NSLocalizedFailureReason"] isEqualToString:@"The recording reached the maximum allowable length."]) {
        [_recordedDurationTimer invalidate];
        _recordedDurationTimer = nil;
        [_mainControls setRecordingTime:(_maxDurationTime.value/_maxDurationTime.timescale)];
    }
    switch (error.code) {
        /*This code is for when switching devices while recording*/
        case -11818:
            return;
            break;
            
        /*This error code is for when we have completed a recording*/
        case -11810:
            [_cameraOutput stopRecording];
            [self showFilterShareButtons:TRUE];
            NSLog(@"Recording Stopped");
            return;
            break;
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
}

#pragma -
#pragma mark - Preview Player Notifications
#pragma -

- (void)previewDidReachEnd:(NSNotification *)event {
    AVPlayerItem *p = [event object];
    [p seekToTime:kCMTimeZero];
    [_previewPlayer play];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    _mainControls.delegate = nil;
    [_recordedDurationTimer invalidate];
    _recordedDurationTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_previewPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end