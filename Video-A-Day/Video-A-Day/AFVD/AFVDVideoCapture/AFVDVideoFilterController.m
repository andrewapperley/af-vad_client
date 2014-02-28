//
//  AFVDVideoFilterController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoFilterController.h"

static const NSInteger kTileSize = 40;
static const NSInteger kTileSpacingBuffer = 10;
static const CGFloat kProcessingBlockerAnimationDuration = 0.5f;
static const NSString *kOutputFilteredFileName = @"tempOutput_filtered.m4v";

@interface AFVDVideoFilterController () {
    GPUImageMovie *_movieFile;
    NSURL *_videoURL;
    NSString *_tempOutputPath;
    GPUImageOutput<GPUImageInput> *_filter;
    GPUImageMovieWriter *_movieWriter;
    CGSize _movieWriterSize;
    CGRect _videoPreviewFrame;
}

@end

@implementation AFVDVideoFilterController

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL andMovieSize:(CGSize)movieWriterSize andFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        _videoURL = lvideoURL;
        _movieWriterSize = movieWriterSize;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseFilterView) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeFilterView) name:UIApplicationWillEnterForegroundNotification object:nil];
        _videoPreviewFrame = frame;
    }
    return self;
}

#pragma mark - Resume/Pause Filter Processing

- (void)pauseFilterView {
    [_movieFile endProcessing];
}

- (void)resumeFilterView {
    [_movieFile startProcessing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = _videoPreviewFrame;
    [self setOutputURL];
    [self setupUI];
    [self setupMovieFile];
    NSArray* list = filterList();
    [self applyFilter:list[0]];
}

#pragma mark - Set the filter list array

NSArray* filterList (void) {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *filterListJSON;
    
    /*Home Directory filter list, this is a copy of the downloaded version after the user purchases an add-on pack*/
    NSString *downloadedJSONList = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AFVDVideoFilterList.json"];
    
    /*Check if they downloaded the file*/
    if (![fileManager fileExistsAtPath:downloadedJSONList]) {
        filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AFVDVideoFilterDefaultList" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
    } else {
         filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:downloadedJSONList] options:NSJSONReadingMutableContainers error:nil];
    }
    
    /*If the default one or the downloaded one fail to load we load an inline version of the default list*/
    if (!filterListJSON) {
        return [[NSArray alloc] initWithObjects:
                      @"GPUImageVignetteFilter",
                      @"GPUImageToonFilter",
                      @"GPUImagePixellateFilter",
                      @"GPUImageColorInvertFilter",
                      @"GPUImageSepiaFilter",
                      @"GPUImageGaussianBlurFilter",
                      @"GPUImageSwirlFilter",
                      @"GPUImageGrayscaleFilter",
                      @"GPUImageBoxBlurFilter",
                      @"GPUImageTiltShiftFilter",
                      @"GPUImagePolkaDotFilter",
                      @"GPUImageMotionBlurFilter", nil];
    }
    
    /*Grab the array of filters from the dictionary and assign them to the filter list var*/
    return [[NSArray alloc] initWithArray:filterListJSON[@"filter_list"]];
}

#pragma mark - Setup UI (Preview screen and filter grid)

- (void)setupUI {
    [self setupPreviewView];
}

- (void)setupPreviewView {
    _previewView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, _videoPreviewFrame.size.width, _videoPreviewFrame.size.height)];
    _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    [self.view addSubview:_previewView];
}

#pragma mark - Setup Movie File
- (void)setupMovieFile {
    _movieFile = [[GPUImageMovie alloc] initWithURL:_videoURL];
    _movieFile.playAtActualSpeed = YES;
    _movieFile.shouldRepeat = YES;
}

#pragma mark - Save Video After Processing

- (void)setupMovieWriter {
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputURL] size:_movieWriterSize];
    
    _movieWriter.delegate = self;
    _movieFile.playAtActualSpeed = NO;
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
}

- (void)endPreviewView {
    [_previewView endProcessing];
    [_filter removeTarget:_previewView];
    [_previewView removeFromSuperview];
}

- (void)saveVideoFile {
    
    [_movieFile endProcessing];
    
    [self setupMovieWriter];
    [self endPreviewView];
    [self removeTempVideoOutput];

    [_filter addTarget:_movieWriter];
    [_movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI * 90 / 180.0)];
    [_movieFile startProcessing];

}

#pragma mark - FIlter

- (void)filterFromButtonPress:(NSString *)filterName {
    [self applyFilter:filterName];
}

- (void)applyFilter:(NSString *)newFilter {
    
    /*Make the class from the filterName*/
    Class filterClassFromNewFilterString = NSClassFromString(newFilter);
    
    /*Stop current processing to speed up filter switching*/
    [_movieFile endProcessing];
    
    /*Check if a filter was applied previously and then remove the filter from the processor*/
    if (_filter) {
        [_filter removeTarget:_previewView];
        [_movieFile removeTarget:_filter];
        _filter = nil;
    }
    
    /*Create the new filter from the newFilter name*/
    _filter = [[filterClassFromNewFilterString alloc] init];
    /*Rotate the Preview screens input because the filters are on the side always :s*/
    [_previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    
    /*Add the filter and movieFile together then start processing again*/
    [_filter addTarget:_previewView];
    [_movieFile addTarget:_filter];
    [_movieFile startProcessing];
    
}

#pragma mark - File URL

- (void)setOutputURL {
    _tempOutputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), kOutputFilteredFileName];
}

- (NSURL *)outputURL {
    return [NSURL fileURLWithPath:_tempOutputPath];
}

- (void)removeTempVideoOutput {
    unlink([_tempOutputPath UTF8String]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_tempOutputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempOutputPath error:nil];
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GPUImageMovieWriterDelegate methods

- (void)cleanupVideoFilter {
    
    _movieWriter.delegate = nil;
    [_movieFile endProcessing];
    
    if (_filter) {
        [_filter removeTarget:_movieWriter];
        [_movieFile removeTarget:_filter];
        _filter = nil;
    }
     [_movieWriter finishRecording];
}

- (void)movieRecordingCompleted {
    NSLog(@"Movie saved");
    [self cleanupVideoFilter];
    
    /*GPUImageMovieWriter runs the delegate method from the background thread so I update the UI in the main thread*/
    
    /*I think this will change as we will be making an app wide spinner with optinal touchBlocker that will handle the animation stuff*/
    dispatch_async(dispatch_get_main_queue(), ^{
        /*Do post-filter actions*/
    });
}

- (void)movieRecordingFailedWithError:(NSError *)error {
    NSLog(@"Movie saving ended in error %@", error.localizedDescription);
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
