//
//  AFVDVideoFilterController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoFilterController.h"
#import "AFVDFilterTileButton.h"

static const NSInteger kTileSize = 40;
static const NSInteger kTileSpacingBuffer = 10;
static const CGFloat kProcessingBlockerAnimationDuration = 0.5f;
static const NSString *kOutputFilteredFileName = @"tempOutput_filtered.m4v";
@interface AFVDVideoFilterController ()
{
    GPUImageMovie *_movieFile;
    NSURL *_videoURL;
    NSString *_tempOutputPath;
    GPUImageOutput<GPUImageInput> *_filter;
    GPUImageMovieWriter *_movieWriter;
    GPUImageView *_previewView;
    UIScrollView *_filterGrid;
    NSArray *_filterList;
    UIButton *_shareButton;
    UIView *_processingBlocker;
    UIActivityIndicatorView *_processingBlockerSpinner;
    CGSize _movieWriterSize;
    AFVDFilterTileButton *_selectedTile;
}

@end

@implementation AFVDVideoFilterController

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL andMovieSize:(CGSize)movieWriterSize {
    self = [super init];
    if (self) {
        _videoURL = lvideoURL;
        _movieWriterSize = movieWriterSize;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseFilterView) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeFilterView) name:UIApplicationWillEnterForegroundNotification object:nil];
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
    
    [self setOutputURL];
    [self setupFilterList];
    [self setupUI];
    [self setupMovieFile];
    [self applyFilter:_filterList[0]];
}

#pragma mark - Set the filter list array

- (void)setupFilterList {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *filterListJSON;
    
    /*Home Directory filter list, this is a copy of the downloaded version after the user purchases an add-on pack*/
    NSString *downloadedJSONList = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/AFVDVideoFilterList.json"];
    
    /*Check if they downloaded the file*/
    if (![fileManager fileExistsAtPath:downloadedJSONList]) {
        filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AFVideoFilterDefaultList" ofType:@"json"]] options:NSJSONReadingMutableContainers error:nil];
    } else {
         filterListJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:downloadedJSONList] options:NSJSONReadingMutableContainers error:nil];
    }
    
    /*If the default one or the downloaded one fail to load we load an inline version of the default list*/
    if (!filterListJSON) {
        _filterList = [[NSArray alloc] initWithObjects:
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
        return;
    }
    
    /*Grab the array of filters from the dictionary and assign them to the filter list var*/
    _filterList = [[NSArray alloc] initWithArray:filterListJSON[@"filter_list"]];
}

#pragma mark - Setup UI (Preview screen and filter grid)

- (void)setupUI {
    [self setupPreviewView];
    [self setupFilterGrid];
    [self setupShareButton];
    [self setupProcessingBlocker];
}

- (void)setupShareButton {
    _shareButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 145) / 2, _filterGrid.frame.origin.y + _filterGrid.frame.size.height + 20, 145, 40)];
    _shareButton.backgroundColor = [UIColor greenColor];
    [_shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton];
}

- (void)setupPreviewView {
    _previewView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
    _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    [self.view addSubview:_previewView];
}

- (void)setupFilterGrid {
    _filterGrid = [[UIScrollView alloc] initWithFrame:CGRectMake(10, _previewView.frame.origin.y + _previewView.frame.size.height + 20, 300, kTileSize)];
    _filterGrid.showsHorizontalScrollIndicator = _filterGrid.showsVerticalScrollIndicator = FALSE;
    
    NSUInteger i = 0;
    
    for (NSString *filter in _filterList) {
        AFVDFilterTileButton *s = [[AFVDFilterTileButton alloc] initWithFrame:CGRectMake(((kTileSize + kTileSpacingBuffer)*i), 0, kTileSize, kTileSize) andFilter:filter];
        //Temp
        s.backgroundColor = [UIColor redColor];
        //end Temp
        [s addTarget:self action:@selector(filterFromButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [s setBackgroundImage:[AFVDVideoFilterController imageWithColor:[UIColor yellowColor]] forState:UIControlStateSelected];
        if(i == 0) {
            s.selected = TRUE;
            _selectedTile = s;
        }
        [_filterGrid addSubview:s];
        
        i++;
    }
    
    _filterGrid.contentSize = CGSizeMake(_filterGrid.contentSize.width + ((kTileSize + kTileSpacingBuffer)*_filterList.count), kTileSize);
    [self.view addSubview:_filterGrid];
}

- (void)setupProcessingBlocker {
    _processingBlocker = [[UIView alloc] initWithFrame:self.view.frame];
    _processingBlocker.backgroundColor = [UIColor blackColor];
    _processingBlocker.alpha = 0;
    
    _processingBlockerSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _processingBlockerSpinner.center = _processingBlocker.center;
    [_processingBlocker addSubview:_processingBlockerSpinner];
}

/*TEMP*/
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Setup Movie File
- (void)setupMovieFile {
    _movieFile = [[GPUImageMovie alloc] initWithURL:_videoURL];
    _movieFile.playAtActualSpeed = TRUE;
    _movieFile.shouldRepeat = TRUE;
}

#pragma mark - Save Video After Processing

- (void)setupMovieWriter {
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputURL] size:_movieWriterSize];
    
    _movieWriter.delegate = self;
    _movieFile.playAtActualSpeed = FALSE;
    _movieWriter.shouldPassthroughAudio = TRUE;
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
    
    [self.view addSubview:_processingBlocker];
    [UIView animateWithDuration:kProcessingBlockerAnimationDuration animations:^{
        _processingBlocker.alpha = 0.6f;
    } completion:^(BOOL finished) {
        [_processingBlockerSpinner startAnimating];
    }];

}

#pragma mark - FIlter

- (void)filterFromButtonPress:(AFVDFilterTileButton *)sender {
    _filterGrid.userInteractionEnabled = FALSE;
    [self applyFilter:sender.filterName];
    _selectedTile.selected = FALSE;
    sender.selected = TRUE;
    _selectedTile = sender;
    _filterGrid.userInteractionEnabled = TRUE;
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

#pragma mark - Share button method

- (void)shareButtonClicked {
    NSLog(@"Shared");
    [self saveVideoFile];
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
        [UIView animateWithDuration:0.5f animations:^{
            _processingBlocker.alpha = 0;
        } completion:^(BOOL finished) {
            [_processingBlockerSpinner stopAnimating];
            [_processingBlocker removeFromSuperview];
        }];
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
