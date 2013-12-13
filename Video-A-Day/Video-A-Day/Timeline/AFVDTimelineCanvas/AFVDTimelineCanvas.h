//
//  AFVDTimelineCanvas.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFVDTimelineCanvas : UIView

#pragma mark - Data handling
/** Set the timeline data. */
- (void)setData:(NSArray *)data;

/** Set the timeline data with a visual canvas refresh. */
- (void)setData:(NSArray *)data refresh:(BOOL)refresh;

/** Append data to the existing timeline canvas data. This will resize the collection view's content size. */
- (void)appendData:(NSArray *)data;

@end
