//
//  AFVideoCaptureControls.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDVideoCaptureControls.h"
#import "AFVDPopoutMenuMenuItem.h"
#import "AFVDPopoutMenuStatics.h"
#import "AFVDPopoutMenuControllerModel.h"
#import "AFVDPopoutMenuViewController.h"
#import "AFVDVideoFilterModel.h"

@interface AFVDVideoCaptureControls () {
    UIButton *_recordButton;
    UILabel *recordingTime;
    CGSize _previewSize;
}

@end

static NSString* kAFVDVideoCaptureMaxDuration                       = @" - 00:20";
static NSString* kAFVDVideoCaptureDefaultDuration                   = @"00:00 - 00:20";
NSInteger const kAFVDVideoCaptureButtonYMargin                      = 10;
NSInteger const kAFVDPopoutMenuCollectionViewCloseButtonXMargin     = 10;

@implementation AFVDVideoCaptureControls

- (id)initWithFrame:(CGRect)frame sizeOfPreviewScreen:(CGSize)previewSize {
    self = [super initWithFrame:frame];
    if (self) {
        _previewSize = previewSize;
        [self setupButtons];
        [self setupMenu];
    }
    return self;
}

- (void)setupButtons {
    
    UIImage *recordImage = [UIImage imageNamed:@"AFVDVideoCaptureRecordButton"];
    
    CGFloat width       = self.bounds.size.width;
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((_previewSize.width - recordImage.size.width)/2, _previewSize.height + kAFVDVideoCaptureButtonYMargin, recordImage.size.width, recordImage.size.height)];
    [_recordButton setImage:recordImage forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize labelSize = [kAFVDVideoCaptureDefaultDuration sizeWithAttributes: [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:15] forKey: NSFontAttributeName]];
    
    recordingTime = [[UILabel alloc] initWithFrame:CGRectMake(width - labelSize.width - 5, 0, labelSize.width, labelSize.height)];
    recordingTime.textAlignment = NSTextAlignmentCenter;
    recordingTime.textColor = [UIColor whiteColor];
    recordingTime.backgroundColor = [UIColor clearColor];
    recordingTime.font = [UIFont systemFontOfSize:15];
    recordingTime.text = kAFVDVideoCaptureDefaultDuration;
    
    [self addSubview:recordingTime];
    [self addSubview:_recordButton];
}

- (void)setupMenu {
    
    UIButton* closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"AFVDPopoutMenuMenuItemIconImage"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, self.frame.size.height - kAFVDPopoutMenuCollectionViewCellIconSize - kAFVDVideoCaptureButtonYMargin, kAFVDPopoutMenuCollectionViewCellIconSize, kAFVDPopoutMenuCollectionViewCellIconSize);
    [closeButton addTarget:self action:@selector(popoutMenuCloseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
    AFVDPopoutMenuControllerModel* menuModel = [[AFVDPopoutMenuControllerModel alloc] initWithIcons:@[[UIImage imageNamed:@"AFVDPopoutMenuChangeCameraMenuItemIconImage"], [UIImage imageNamed:@"AFVDPopoutMenuRestartMenuItemIconImage"]]
                                                                                             titles:@[NSLocalizedString(@"kAFVDPopoutMenuChangeCameraMenuItemTitle", nil), NSLocalizedString(@"kAFVDPopoutMenuRestartMenuItemTitle", nil)]
                                                                                          selectors:@[@"changeCameraButtonPressed:", @"resetButtonPressed"]
                                                                                         properties:@[@(AVCaptureDevicePositionBack)]];
    
    _menu = [[AFVDPopoutMenuViewController alloc] initWithModel:menuModel frame:CGRectMake(closeButton.frame.size.width + closeButton.frame.origin.x + kAFVDPopoutMenuCollectionViewCloseButtonXMargin, closeButton.frame.origin.y, self.frame.size.width - (closeButton.frame.size.width + closeButton.frame.origin.x + kAFVDPopoutMenuCollectionViewCloseButtonXMargin), kAFVDPopoutMenuCollectionViewCellIconSize)];
    _menu.delegate   = self;

    [self addSubview:_menu.view];
    [self addSubview:closeButton];
}

#pragma -
#pragma Button Methods
#pragma -

- (void)addFilterButtonClicked {
    if ([_delegate respondsToSelector:@selector(showFilters)]) {
        [_delegate showFilters];
    }
}

- (void)filterButtonClicked:(AFVDPopoutMenuMenuItem *)menuItem {
    if ([_delegate respondsToSelector:@selector(changeVideoFilterForItem:)]) {
        [_delegate changeVideoFilterForItem:menuItem];
    }
}

- (void)shareButtonClicked {
    if ([_delegate respondsToSelector:@selector(shareVideo)]) {
        [_delegate shareVideo];
    }
}

- (void)popoutMenuCloseButtonPressed {
    [_menu closeMenu:!_menu.isOpen];
}

- (void)changeCameraButtonPressed:(AFVDPopoutMenuMenuItem *)sender {
    AVCaptureDevicePosition device;
    NSInteger newMenuProperty;
    
    switch ([sender.menuItemProperty integerValue]) {
        case AVCaptureDevicePositionBack:
            device = newMenuProperty = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            device = newMenuProperty = AVCaptureDevicePositionBack;
            break;
    }
    
    [sender setMenuItemProperty:@(newMenuProperty)];
    if ([_delegate respondsToSelector:@selector(videoCaptureDeviceSwitched:)]) {
        [_delegate videoCaptureDeviceSwitched:device];
    }
}

- (void)closeButtonPressed {
    if ([_delegate respondsToSelector:@selector(closeVideoCaptureController)]) {
        [_delegate closeVideoCaptureController];
    }
}

- (void)recordButtonPressed {
    if ([_delegate respondsToSelector:@selector(startCapturingVideo)]) {
        [_delegate startCapturingVideo];
    }
}

- (void)resetButtonPressed {
    if ([_delegate respondsToSelector:@selector(recaptureVideo)]) {
        [_delegate recaptureVideo];
    }
}

#pragma -
#pragma Public Methods
#pragma -

- (void)showFilterMenuForFilters:(NSArray *)filters {
    
    NSMutableArray* icons       = [[NSMutableArray alloc] initWithCapacity:filters.count];
    NSMutableArray* titles      = [[NSMutableArray alloc] initWithCapacity:filters.count];
    NSMutableArray* selectors   = [[NSMutableArray alloc] initWithCapacity:filters.count];
    NSMutableArray* properties  = [[NSMutableArray alloc] initWithCapacity:filters.count];
    
    for (AFVDVideoFilterModel *filter in filters) {
        [icons addObject:/*filter.filterImage*/[UIImage imageNamed:@"AFVDPopoutMenuShareMenuItemIconImage"]];
        [titles addObject:filter.filterTitle];
        [selectors addObject:@"filterButtonClicked:"];
        [properties addObject:filter.filterClassName];
    }
    
    AFVDPopoutMenuControllerModel* menuModel = [[AFVDPopoutMenuControllerModel alloc] initWithIcons:icons
                                                                                             titles:titles
                                                                                          selectors:selectors
                                                                                         properties:properties];
    [_menu refreshMenuWithModel:menuModel];
}

- (void)showFilterShareButtons {
    AFVDPopoutMenuControllerModel* menuModel = [[AFVDPopoutMenuControllerModel alloc] initWithIcons:@[[UIImage imageNamed:@"AFVDPopoutMenuShareMenuItemIconImage"], [UIImage imageNamed:@"AFVDPopoutMenuAddFilterMenuItemIconImage"]]
                                                                                             titles:@[NSLocalizedString(@"kAFVDPopoutMenuAddFilterMenuItemTitle", nil), NSLocalizedString(@"kAFVDPopoutMenuShareMenuItemTitle", nil)]
                                                                                          selectors:@[@"shareButtonClicked", @"addFilterButtonClicked"]
                                                                                         properties:nil];
    [_menu refreshMenuWithModel:menuModel];
}

- (void)changeRecordingButtonState:(BOOL)lrecording {
    
}

- (void)setRecordingTime:(long long)newTime {
    
    NSString* newTimeString = @"";
    if (newTime < 10) {
        newTimeString = [NSString stringWithFormat:@"0%lld", newTime];
    } else {
        newTimeString = [NSString stringWithFormat:@"%lld", newTime];
    }
    [recordingTime setText:[NSString stringWithFormat:@"00:%@%@", newTimeString,kAFVDVideoCaptureMaxDuration]];
}

@end