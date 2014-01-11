//
//  AFVDTimelineCanvasCell.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, AFVDTimelineCanvasCellBackgroundLinePosition) {
    
    kAFVDTimelineCanvasCellBackgroundLinePosition_None   = 0,
    kAFVDTimelineCanvasCellBackgroundLinePosition_Top    = 1 << 0,
    kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom = 1 << 1
};

@interface AFVDTimelineCanvasCell : UICollectionViewCell

#pragma mark - Data
/** Sets the data for the cell. */
- (void)setData:(id)data;

#pragma mark - Position
/** Sets the position relative to it's visible container. */
- (void)checkCellPositionInView:(UIView *)view position:(CGPoint)position;

#pragma mark - Background line position
- (void)setBackgroundLinePosition:(AFVDTimelineCanvasCellBackgroundLinePosition)position;

#pragma mark - Cell height
+ (CGFloat)cellHeight;

@end
