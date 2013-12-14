//
//  AFVDTimelineCanvas.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFVDTimelineCanvas;

@protocol AFVDTimelineCanvasDelegate <NSObject>

- (void)timelineCanvasWillReachEnd:(AFVDTimelineCanvas *)timeline;
- (void)timelineCanvasDidReachEnd:(AFVDTimelineCanvas *)timeline;

@end

@interface AFVDTimelineCanvas : UIView

@property (nonatomic, weak) id<AFVDTimelineCanvasDelegate> delegate;

#pragma mark - Data handling
/** Set the timeline data. */
- (void)setData:(NSArray *)data;

/** Append data to the existing timeline canvas data. This will resize the collection view's content size. */
- (void)appendData:(NSArray *)data;

@end
