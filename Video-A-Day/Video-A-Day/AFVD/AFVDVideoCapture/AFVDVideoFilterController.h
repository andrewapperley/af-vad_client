//
//  AFVDVideoFilterController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface AFVDVideoFilterController : UIViewController<GPUImageMovieWriterDelegate>

@property(nonatomic, strong)GPUImageView *previewView;
@property(nonatomic, strong, getter = filterList)NSArray* filterList;

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL andMovieSize:(CGSize)movieWriterSize andFrame:(CGRect)frame;

- (void)filterFromButtonPress:(NSString *)filterName;

@end