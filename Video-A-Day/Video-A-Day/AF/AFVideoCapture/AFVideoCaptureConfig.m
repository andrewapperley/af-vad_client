//
//  AFVideoCaptureConfig.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/12/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVideoCaptureConfig.h"

@implementation AFVideoCaptureConfig

- (instancetype)initConfigWithMaxDuration:(CMTime)maxDuration andWindowSize:(CGRect)size andPreset:(AFVideoCapturePreset)preset {
    self = [super init];
    if (self) {
        _maxDurationTime = maxDuration;
        _previewWindowFrame = size;
        _preset = preset;
    }
    return self;
}

- (instancetype)initWithDefaultConfig {
    return [[AFVideoCaptureConfig alloc] initConfigWithMaxDuration:CMTimeMake(600, 30) andWindowSize:CGRectMake(10, 10, 300, 300) andPreset:AFVideoCapturePreset_Medium];
}

- (NSString *)AFVideoCapturePresetToString:(AFVideoCapturePreset)preset {
    NSArray *AFVideoCapturePresets = @[@"AVCaptureSessionPresetLow", @"AVCaptureSessionPresetMedium", @"AVCaptureSessionPresetHigh"];
    return AFVideoCapturePresets[preset];
}

@end