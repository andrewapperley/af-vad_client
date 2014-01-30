//
//  AFVDTimelineCanvasCell.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFVDTimelineCanvasCell : UICollectionViewCell

#pragma mark - Data
/** Sets the data for the cell. */
- (void)setData:(id)data;

#pragma mark - Position
/** Sets the position relative to it's visible container. */
- (void)setParallaxPosition:(CGFloat)position;

#pragma mark - Cell height
+ (CGFloat)cellHeight;

@end
