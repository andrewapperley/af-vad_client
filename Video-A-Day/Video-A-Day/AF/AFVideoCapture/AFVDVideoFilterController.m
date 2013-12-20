//
//  AFVDVideoFilterController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoFilterController.h"
#import "GPUImage.h"

@interface AFVDVideoFilterController ()
{
    GPUImageMovie *movieFile;
    NSURL *videoURL;
    NSString *tempOutputPath;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    GPUImageView *previewView;
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
    
    previewView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
    previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [previewView setInputRotation:kGPUImageRotateRight atIndex:0];
    [self.view addSubview:previewView];
    
    [self setOutputURL];
    movieFile = [[GPUImageMovie alloc] initWithURL:videoURL];
    movieFile.playAtActualSpeed = TRUE;
    movieFile.shouldRepeat = TRUE;
    [self applyFilter];
    
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputURL] size:CGSizeMake(640, 480)];
    
    [filter addTarget:previewView];
    
//    movieFile.audioEncodingTarget = movieWriter;
    
    [movieFile startProcessing];

    
}

- (void)applyFilter {
    filter = [[GPUImageVignetteFilter alloc] init];
    [movieFile addTarget:filter];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
