//
//  AFVDTimeline.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/10/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDTimeline.h"
#import "AFVDTimelineCanvas.h"

@interface AFVDTimeline () {
    
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

#warning TODO
//- (void)timelineWillReachEnd:(AFVDTimeline *)timeline;
//- (void)timelineDidReachEnd:(AFVDTimeline *)timeline;
#warning ENDTODO

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
