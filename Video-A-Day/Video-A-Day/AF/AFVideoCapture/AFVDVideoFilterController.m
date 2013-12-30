//
//  AFVDVideoFilterController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoFilterController.h"
#import "GPUImage.h"

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
}

@end

@implementation AFVDVideoFilterController

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL {
    self = [super init];
    if (self) {
        videoURL = lvideoURL;
    }
    return self;
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

#pragma mark Set the filter list array

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
    movieFile.playSound = TRUE;
}

#pragma mark - Save Video After Processing

- (void)setupMovieWriter {
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputURL] size:CGSizeMake(640, 480)];
//    movieFile.audioEncodingTarget = movieWriter;
}

- (void)saveVideoFile {
//    [movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(-90)];
}

#pragma mark - FIlter

- (void)getFilterFromButtonPress:(UIButton *)sender {
    
    [self applyFilter:filterList[sender.tag]];
    /*TEMP I will eventually hold onto the last selected button*/
    for (UIButton *b in filterGrid.subviews) {
        b.selected = FALSE;
    }
    sender.selected = TRUE;
    
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
    tempOutputPath = [[NSString alloc] initWithFormat:@"%@tempOutput_filtered.mov", NSTemporaryDirectory()];
}

- (NSURL *)outputURL {
    return [NSURL fileURLWithPath:tempOutputPath];
}

- (void)removeTempVideoOutput {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:tempOutputPath])
        [[NSFileManager defaultManager] removeItemAtPath:tempOutputPath error:nil];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
