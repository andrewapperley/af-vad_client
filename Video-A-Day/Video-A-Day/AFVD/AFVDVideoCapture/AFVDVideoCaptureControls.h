//
//  AFVideoCaptureControls.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AFVDPopoutMenuViewController, AFVDPopoutMenuMenuItem;

@protocol AFVDVideoCaptureControlsDelegate <NSObject>

@required
- (void)startCapturingVideo;
- (void)closeVideoCaptureController;
- (void)recaptureVideo;
- (void)shareVideo;
- (void)showFilters;
- (void)videoCaptureDeviceSwitched:(AVCaptureDevicePosition)device;
- (void)changeVideoFilterForItem:(AFVDPopoutMenuMenuItem *)menuItem;

@end

@interface AFVDVideoCaptureControls : UIView

@property(nonatomic, weak) id <AFVDVideoCaptureControlsDelegate> delegate;
@property(nonatomic, strong) AFVDPopoutMenuViewController* menu;

- (id)initWithFrame:(CGRect)frame sizeOfPreviewScreen:(CGSize)previewSize;

- (void)changeRecordingButtonState:(BOOL)lrecording;
- (void)setRecordingTime:(long long)newTime;
- (void)showFilterShareButtons;
- (void)showFilterMenuForFilters:(NSArray *)filters;

@end