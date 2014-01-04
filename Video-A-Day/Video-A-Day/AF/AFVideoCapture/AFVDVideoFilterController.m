//
//  AFVDVideoFilterController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoFilterController.h"


static const NSInteger tileSize = 40;
static const NSInteger tileSpacingBuffer = 10;

@interface AFVDVideoFilterController ()
{
    GPUImageMovie *movieFile;
    NSURL *videoURL;
    NSString *tempOutputPath;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    GPUImageView *previewView;
    UIScrollView *filterGrid;
    NSArray *filterList;
    UIButton *shareButton;
    UIView *processingBlocker;
    UIActivityIndicatorView *processingBlockerSpinner;
    MFMailComposeViewController *mailComposer;
}

@end

@implementation AFVDVideoFilterController

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL {
    self = [super init];
    if (self) {
        videoURL = lvideoURL;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseFilterView) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeFilterView) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

#pragma mark - Resume/Pause Filter Processing

- (void)pauseFilterView {
    [movieFile endProcessing];
}

- (void)resumeFilterView {
    [movieFile startProcessing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOutputURL];
    [self setupFilterList];
    [self setupUI];
    [self setupMovieFile];
    [self applyFilter:filterList[0]];
}

- (void)viewDidAppear:(BOOL)animated {
    mailComposer = [[MFMailComposeViewController alloc]init];
}

#pragma mark - Set the filter list array

- (void)setupFilterList {
    filterList = [[NSArray alloc] initWithObjects:@"GPUImageVignetteFilter",
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

#pragma mark - Setup UI (Preview screen and filter grid)

- (void)setupUI {
    [self setupPreviewView];
    [self setupFilterGrid];
    [self setupShareButton];
    [self setupProcessingBlocker];
}

- (void)setupShareButton {
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 145) / 2, filterGrid.frame.origin.y + filterGrid.frame.size.height + 20, 145, 40)];
    shareButton.backgroundColor = [UIColor greenColor];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}

- (void)setupPreviewView {
    previewView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
    previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    [self.view addSubview:previewView];
}

- (void)setupFilterGrid {
    filterGrid = [[UIScrollView alloc] initWithFrame:CGRectMake(10, previewView.frame.origin.y + previewView.frame.size.height + 20, 300, tileSize)];
    filterGrid.showsHorizontalScrollIndicator = filterGrid.showsVerticalScrollIndicator = FALSE;
    
    for (uint i = 0; i < filterList.count; i++) {
        UIButton *s = [[UIButton alloc] initWithFrame:CGRectMake(((tileSize + tileSpacingBuffer)*i), 0, tileSize, tileSize)];
        s.backgroundColor = [UIColor redColor];
        s.tag = i;
        [s addTarget:self action:@selector(getFilterFromButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [s setBackgroundImage:[AFVDVideoFilterController imageWithColor:[UIColor yellowColor]] forState:UIControlStateSelected];
        if(i == 0) {
            s.selected = TRUE;
        }
        [filterGrid addSubview:s];
    }
    
    filterGrid.contentSize = CGSizeMake(filterGrid.contentSize.width + ((tileSize + tileSpacingBuffer)*filterList.count), tileSize);
    [self.view addSubview:filterGrid];
}

- (void)setupProcessingBlocker {
    processingBlocker = [[UIView alloc] initWithFrame:self.view.frame];
    processingBlocker.backgroundColor = [UIColor blackColor];
    processingBlocker.alpha = 0;
    
    processingBlockerSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    processingBlockerSpinner.center = processingBlocker.center;
    [processingBlocker addSubview:processingBlockerSpinner];
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
    movieFile = [[GPUImageMovie alloc] initWithURL:videoURL];
    movieFile.playAtActualSpeed = TRUE;
    movieFile.shouldRepeat = TRUE;
}

#pragma mark - Save Video After Processing

- (void)setupMovieWriter {
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputURL] size:CGSizeMake(640, 480)];
    
    movieWriter.delegate = self;
    movieFile.playAtActualSpeed = FALSE;
    movieWriter.shouldPassthroughAudio = TRUE;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
}

- (void)endPreviewView {
    [previewView endProcessing];
    [filter removeTarget:previewView];
    [previewView removeFromSuperview];
}

- (void)saveVideoFile {
    
    [movieFile endProcessing];
    
    [self setupMovieWriter];
    [self endPreviewView];
    [self removeTempVideoOutput];

    [filter addTarget:movieWriter];
    [movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI * 90 / 180.0)];
    [movieFile startProcessing];
    
    [self.view addSubview:processingBlocker];
    [UIView animateWithDuration:0.5f animations:^{
        processingBlocker.alpha = 0.6f;
    } completion:^(BOOL finished) {
        [processingBlockerSpinner startAnimating];
    }];

}

#pragma mark - FIlter

- (void)getFilterFromButtonPress:(UIButton *)sender {
    filterGrid.userInteractionEnabled = FALSE;
    [self applyFilter:filterList[sender.tag]];
    /*TEMP I will eventually hold onto the last selected button*/
    for (UIButton *b in filterGrid.subviews) {
        b.selected = FALSE;
    }
    sender.selected = TRUE;
    filterGrid.userInteractionEnabled = TRUE;
}

- (void)applyFilter:(NSString *)newFilter {
    
    /*Make the class from the filterName*/
    Class filterClassFromNewFilterString = NSClassFromString(newFilter);
    
    /*Stop current processing to speed up filter switching*/
    [movieFile endProcessing];
    
    /*Check if a filter was applied previously and then remove the filter from the processor*/
    if (filter) {
        [filter removeTarget:previewView];
        [movieFile removeTarget:filter];
        filter = nil;
    }
    
    /*Create the new filter from the newFilter name*/
    filter = [[filterClassFromNewFilterString alloc] init];
    /*Rotate the Preview screens input because the filters are on the side always :s*/
    [previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    
    /*Add the filter and movieFile together then start processing again*/
    [filter addTarget:previewView];
    [movieFile addTarget:filter];
    [movieFile startProcessing];
    
}

#pragma mark - File URL

- (void)setOutputURL {
    tempOutputPath = [[NSString alloc] initWithFormat:@"%@tempOutput_filtered.m4v", NSTemporaryDirectory()];
}

- (NSURL *)outputURL {
    return [NSURL fileURLWithPath:tempOutputPath];
}

- (void)removeTempVideoOutput {
    unlink([tempOutputPath UTF8String]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempOutputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:tempOutputPath error:nil];
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
    movieWriter.delegate = nil;
    [movieFile endProcessing];
//    [previewView endProcessing];
    if (filter) {
        [filter removeTarget:movieWriter];
//        [filter removeTarget:previewView];
        [movieFile removeTarget:filter];
        filter = nil;
    }
     [movieWriter finishRecording];
}

- (void)movieRecordingCompleted {
    NSLog(@"Movie saved");
    [self cleanupVideoFilter];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            processingBlocker.alpha = 0;
        } completion:^(BOOL finished) {
            [processingBlockerSpinner stopAnimating];
            [processingBlocker removeFromSuperview];
        }];
         [self displayComposerSheet];
    });
}

- (void)displayComposerSheet
{
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Test mail"];
    [mailComposer setMessageBody:@"Testing message for the test mail" isHTML:NO];
    NSData *data = [NSData dataWithContentsOfURL:[self outputURL]];
    [mailComposer addAttachmentData:data mimeType:@"video/m4v" fileName:@"abc.m4v"];
     [self presentModalViewController:mailComposer animated:YES];
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
