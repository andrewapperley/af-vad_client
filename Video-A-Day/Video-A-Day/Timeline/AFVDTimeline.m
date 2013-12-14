//
//  AFVDTimeline.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/10/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDTimeline.h"
#import "AFVDTimelineCanvas.h"

@interface AFVDTimeline () <AFVDTimelineCanvasDelegate> {
    
    AFVDTimelineCanvas  *_timelineCanvas;
}

@end

@implementation AFVDTimeline

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        
        [self createTimelineCanvas];
    }
    return self;
}

- (instancetype)init {
    
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        
        [self createTimelineCanvas];
    }
    return self;
}

#pragma mark - Create timeline 
- (void)createTimelineCanvas {
    
    _timelineCanvas = [[AFVDTimelineCanvas alloc] initWithFrame:self.view.bounds];
    _timelineCanvas.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = _timelineCanvas;
}

#pragma mark - AFVDTimelineCanvasDelegate
- (void)timelineCanvasWillReachEnd:(AFVDTimelineCanvas *)timeline {
    
    if([_delegate respondsToSelector:@selector(timelineWillReadEnd:)]) {
        
        [_delegate timelineWillReadEnd:self];
    }
    
    [_dataSource timeline:self willLoadAppendedData:^(NSArray *data) {
        
        if(data) {
            
            [_timelineCanvas appendData:data];
        }
    }];
}

- (void)timelineCanvasDidReachEnd:(AFVDTimelineCanvas *)timeline {
    
    if([_delegate respondsToSelector:@selector(timelineDidReadEnd:)]) {
        
        [_delegate timelineDidReadEnd:self];
    }
}

#pragma mark - Reload
- (void)reloadData {
    
    [_dataSource timeline:self willLoadInitialData:^(NSArray *data) {
        
        if(data) {
            
            [_timelineCanvas setData:data];
        }
    }];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
    _dataSource = nil;
}

@end
