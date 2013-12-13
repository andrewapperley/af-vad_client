//
//  AFVideoCaptureConfig.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/12/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

typedef enum {
    AFVideoCapturePreset_Low = 0,
    AFVideoCapturePreset_Medium = 1,
    AFVideoCapturePreset_High = 2
} AFVideoCapturePreset;

@interface AFVideoCaptureConfig : NSObject

@property (nonatomic) CMTime maxDurationTime;
@property (nonatomic) CGRect previewWindowFrame;
@property (nonatomic) AFVideoCapturePreset preset;

- (NSString *)AFVideoCapturePresetToString:(AFVideoCapturePreset)preset;

- (instancetype)initConfigWithMaxDuration:(CMTime)maxDuration andWindowSize:(CGRect)size andPreset:(AFVideoCapturePreset)preset;

- (instancetype)initWithDefaultConfig;

@end