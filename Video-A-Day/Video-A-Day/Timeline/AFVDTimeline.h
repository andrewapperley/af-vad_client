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

#pragma mark - Scrolling
@optional
/** Sent when the canvas position will scroll to the end of it's content size. */
- (void)timelineWillReadEnd:(AFVDTimeline *)timeline;

/** Sent when the canvas position did scroll to the end of it's content size. */
- (void)timelineDidReadEnd:(AFVDTimeline *)timeline;

@end

typedef void(^AFVDTimelineInitialData)(NSArray *data);
typedef void(^AFVDTimelineAppendedData)(NSArray *data);

@protocol AFVDTimelineDataSource <NSObject>

#pragma mark - Data loading from scrolling
@required
/** Asks the data source for data to be set as initial . */
- (void)timeline:(AFVDTimeline *)timeline willLoadInitialData:(AFVDTimelineInitialData)initialData;

/** Asks the data source for data to be appended to the current timeline canvas. */
- (void)timeline:(AFVDTimeline *)timeline willLoadAppendedData:(AFVDTimelineAppendedData)appendedData;

@end

/** AFVDTimeline is an view controller class that is used with an AFVDTimelineCanvas. It handles the data management from it's delegate and data source methods and passes it to the AFVDTimelineCanvas view. */
@interface AFVDTimeline : UIViewController

@property (nonatomic, weak) id<AFVDTimelineDelegate> delegate;
@property (nonatomic, weak) id<AFVDTimelineDataSource> dataSource;

- (void)reloadData;

@end
