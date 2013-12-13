//
//  AFVDTimeline.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/10/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFVDTimeline;

@protocol AFVDTimelineDelegate <NSObject>

- (void)timelineWillReachEnd:(AFVDTimeline *)timeline;
- (void)timelineDidReachEnd:(AFVDTimeline *)timeline;

@end

@interface AFVDTimeline : UIViewController

@property (nonatomic, weak) id<AFVDTimelineDelegate> delegate;

@end
