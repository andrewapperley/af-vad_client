//
//  AFVDTimelineCanvasCell.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AFVDTimelineCanvasCell.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Constants
//Cell
CGFloat const kAFVDTimelineCanvasCell_CellHeight                 = 80.0f;

//Background width
CGFloat const kAFVDTimelineCanvasCell_BackgroundLineWidth        = 1.0f;

//Portrait
CGFloat const kAFVDTimelineCanvasCell_PortraitBorderWidth        = kAFVDTimelineCanvasCell_BackgroundLineWidth;
CGFloat const kAFVDTimelineCanvasCell_PortraitMinWidthHeight     = 40.0f;
CGFloat const kAFVDTimelineCanvasCell_PortraitMaxWidthHeight     = kAFVDTimelineCanvasCell_CellHeight;

//Portrait sizing threshold
CGFloat const kAFVDTimelineCanvasCell_PortraitResizeThreshold    = 20.0f;

@interface AFVDTimelineCanvasCell () {
    
    UIView      *_backgroundLine;
    UIImageView *_portraitImageView;
}

@end

@implementation AFVDTimelineCanvasCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor blueColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        [self createLineBackground];
        [self createPortraitImageView];
    }
    return self;
}

- (void)createLineBackground {
    
    _backgroundLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - (kAFVDTimelineCanvasCell_BackgroundLineWidth / 2), 0, kAFVDTimelineCanvasCell_BackgroundLineWidth, self.bounds.size.height)];
    _backgroundLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundLine];
}

- (void)createPortraitImageView {
    
    //Portrait image
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAFVDTimelineCanvasCell_PortraitMinWidthHeight, kAFVDTimelineCanvasCell_PortraitMinWidthHeight)];
    [self addSubview:_portraitImageView];
    
    //Border and corner radius
    _portraitImageView.layer.borderWidth = kAFVDTimelineCanvasCell_PortraitBorderWidth;
    _portraitImageView.layer.borderColor = _backgroundLine.backgroundColor.CGColor;
    _portraitImageView.layer.shouldRasterize = TRUE;
    _portraitImageView.layer.allowsEdgeAntialiasing = TRUE;
    _portraitImageView.layer.cornerRadius = trunc(CGRectGetWidth(_portraitImageView.frame) / 2);
    _portraitImageView.layer.masksToBounds = TRUE;
}

#pragma mark - Data
- (void)setData:(id)data {
    
#warning TODO
    
    [_portraitImageView setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/378800000703808793/2f6dcc6353959ce2009d9ec7bf84baca.jpeg"]];
}

#pragma mark - Position
- (void)checkCellPositionInView:(UIView *)view {
    
#warning TODO :    kAFVDTimelineCanvasCell_PortraitResizeThreshold
    
//    CGRect localRectContainer = view.frame;
//    CGPoint localPositioninContainer = self.frame.origin;
//    
//    //Default size
//    CGSize defaultCellSize = CGSizeMake(kAFVDTimelineCanvasCell_PortraitMinWidthHeight, kAFVDTimelineCanvasCell_PortraitMinWidthHeight);
//    
//#warning TODO kAFVDTimelineCanvasCell_PortraitResizeThreshold
//
//    //Check if container view has cell position
//    if(CGRectContainsPoint(view.frame, localPositioninContainer)) {
//        
//#warning TODO kAFVDTimelineCanvasCell_PortraitResizeThreshold
//        //Calculate position percentage for top position and container with threshold
//        CGFloat positionPerentage = (localPositioninContainer.y / view.bounds.size.height);
//
////        if(positionPerentage > 0.5f) {
////
////            positionPerentage -= 0.5f;
////        }
//        
//        NSLog(@"positionPerentage : %f", positionPerentage);
//
//        //Center portrait image
//        CGFloat portraitWidth     = MAX(kAFVDTimelineCanvasCell_PortraitMinWidthHeight, MIN(kAFVDTimelineCanvasCell_PortraitMaxWidthHeight * positionPerentage, kAFVDTimelineCanvasCell_PortraitMaxWidthHeight));
//        CGFloat portraitHeight    = portraitWidth;
//        CGFloat portraitLeft      = (self.bounds.size.width - portraitWidth) * 0.5f;
//        CGFloat portraitTop       = (self.bounds.size.height - portraitHeight) * 0.5f;
//
//        //Portrait view frame
//        CGRect frame             = CGRectMake(portraitLeft, portraitTop, portraitWidth, portraitHeight);
//        [self animatePortraitImageToFrame:frame];
//
//    //Cell is default and won't need resizing
//    } else if(!CGSizeEqualToSize(_portraitImageView.bounds.size, defaultCellSize)) {
//
//        //Center portrait image
//        CGFloat portraitWidth     = defaultCellSize.width;
//        CGFloat portraitHeight    = defaultCellSize.height;
//        CGFloat portraitLeft      = (self.bounds.size.width - portraitWidth) * 0.5f;
//        CGFloat portraitTop       = (self.bounds.size.height - portraitHeight) * 0.5f;
//
//        //Portrait view frame
//         CGRect frame             = CGRectMake(portraitLeft, portraitTop, portraitWidth, portraitHeight);
//        [self animatePortraitImageToFrame:frame];
//    }

}

- (void)animatePortraitImageToFrame:(CGRect)frame {
    
#warning TEMP....SHOULD BE CA ANIMATION
    [UIView animateWithDuration:0.15f animations:^{
        //Portrait view frame
        _portraitImageView.frame = frame;
        _portraitImageView.layer.cornerRadius = trunc(CGRectGetWidth(frame) / 2);
    }];
}

#pragma mark - Background line position
- (void)setBackgroundLinePosition:(AFVDTimelineCanvasCellBackgroundLinePosition)position {
    
    CGFloat left    = CGRectGetMinX(_backgroundLine.frame);
    CGFloat width   = CGRectGetWidth(_backgroundLine.frame);
    
    //No line
    if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_None) {
        
        _backgroundLine.frame = CGRectMake(left, 0, width, 0);
        
    } else {
        
        //Top and bottom lines
        if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_Top && position & kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom) {
            
            _backgroundLine.frame = CGRectMake(left, 0, width, CGRectGetHeight(self.frame));
            
            //Top line
        } else if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_Top) {
            
            _backgroundLine.frame = CGRectMake(left, 0, width, CGRectGetMidY(self.frame));
            
            //Bottom line
        } else if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom) {
            
            _backgroundLine.frame = CGRectMake(left, CGRectGetMidY(self.frame), width, CGRectGetMidY(self.frame));
        }
    }
}

#pragma mark - Cell height
+ (CGFloat)cellHeight {
    
    return kAFVDTimelineCanvasCell_CellHeight;
}

@end
