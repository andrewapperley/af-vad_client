//
//  AFVDTimelineCanvasCell.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AFVDBaseNetworkStatics.h"
#import "AFVDTimelineCanvasCell.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Constants
//Cell
CGFloat const kAFVDTimelineCanvasCell_CellHeight                = 85.0f;

//Background width
CGFloat const kAFVDTimelineCanvasCell_BackgroundLineWidth       = 2.0f;

//Small portrait
CGFloat const kAFVDTimelineCanvasCell_SmallPortraitWidthHeight  = 24.0f;
CGFloat const kAFVDTimelineCanvasCell_SmallPortraitBorderWidth  = kAFVDTimelineCanvasCell_BackgroundLineWidth;

//Portrait
CGFloat const kAFVDTimelineCanvasCell_PortraitBorderWidth       = kAFVDTimelineCanvasCell_BackgroundLineWidth;
CGFloat const kAFVDTimelineCanvasCell_PortraitMinWidthHeight    = 44.0f;
CGFloat const kAFVDTimelineCanvasCell_PortraitMaxWidthHeight    = kAFVDTimelineCanvasCell_CellHeight;

//Portrait sizing threshold
CGFloat const kAFVDTimelineCanvasCell_PortraitResizeThreshold   = 20.0f;

//Portrait hue
CGFloat const kAFVDTimelineCanvasCell_Hue                       = 90.0f;

//Date label
CGFloat const kAFVDTimelineCanvasCell_MinDateLabelAlpha         = 0.6f;

@interface AFVDTimelineCanvasCell () {
    
    UIView      *_backgroundLine;
    UIImageView *_smallPortraitImageView;
    UIImageView *_portraitImageView;
    UILabel     *_usernameLabel;
    UILabel     *_dateLabel;
}

@end

@implementation AFVDTimelineCanvasCell

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
#warning TEMP
        self.backgroundColor = [UIColor blueColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
#warning ENDTEMP
        [self createLineBackground];
        [self createSmallPortraitImageView];
        [self createPortraitImageView];
        [self createUsernameLabel];
        [self createDateLabel];
    }
    return self;
}

- (void)createLineBackground {
    
    _backgroundLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - (kAFVDTimelineCanvasCell_BackgroundLineWidth * 0.5f), 0, kAFVDTimelineCanvasCell_BackgroundLineWidth, CGRectGetHeight(self.bounds))];
    _backgroundLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroundLine];
}

- (void)createSmallPortraitImageView {
    
    CGFloat padding     = 15.0f;
    CGFloat topOffset   = 6.0f;
    
    //Small portrait image
    _smallPortraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, ceil((self.bounds.size.height - kAFVDTimelineCanvasCell_SmallPortraitWidthHeight) * 0.5f) - topOffset, kAFVDTimelineCanvasCell_SmallPortraitWidthHeight, kAFVDTimelineCanvasCell_SmallPortraitWidthHeight)];
    
    //Border and corner radius
    _smallPortraitImageView.layer.borderWidth = kAFVDTimelineCanvasCell_SmallPortraitBorderWidth;
    _smallPortraitImageView.layer.borderColor = _backgroundLine.backgroundColor.CGColor;
    _smallPortraitImageView.layer.shouldRasterize = TRUE;
    _smallPortraitImageView.layer.allowsEdgeAntialiasing = TRUE;
    _smallPortraitImageView.layer.cornerRadius = ceil(CGRectGetWidth(_smallPortraitImageView.frame) * 0.5f);
    _smallPortraitImageView.layer.masksToBounds = TRUE;
    
    [self addSubview:_smallPortraitImageView];
}

- (void)createPortraitImageView {
    
    //Portrait image
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ceil((self.bounds.size.width - kAFVDTimelineCanvasCell_PortraitMinWidthHeight) * 0.5f), ceil((self.bounds.size.height - kAFVDTimelineCanvasCell_PortraitMinWidthHeight) * 0.5f), kAFVDTimelineCanvasCell_PortraitMinWidthHeight, kAFVDTimelineCanvasCell_PortraitMinWidthHeight)];
    
    //Border and corner radius
    _portraitImageView.layer.borderWidth = kAFVDTimelineCanvasCell_PortraitBorderWidth;
    _portraitImageView.layer.borderColor = _backgroundLine.backgroundColor.CGColor;
    _portraitImageView.layer.shouldRasterize = TRUE;
    _portraitImageView.layer.allowsEdgeAntialiasing = TRUE;
    _portraitImageView.layer.cornerRadius = ceil(CGRectGetWidth(_portraitImageView.frame) * 0.5f);
    _portraitImageView.layer.masksToBounds = TRUE;
    
    [self addSubview:_portraitImageView];
}

- (void)createUsernameLabel {

    CGFloat padding         = 2.0f;
    CGFloat extraLabelWidth = 5.0f;
    
    _usernameLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_smallPortraitImageView.frame) - extraLabelWidth, CGRectGetMaxY(_smallPortraitImageView.frame) + padding, CGRectGetWidth(_smallPortraitImageView.bounds) + (extraLabelWidth * 2), 0)];
    _usernameLabel.numberOfLines    = 0;
    _usernameLabel.backgroundColor  = [UIColor clearColor];
    _usernameLabel.textColor        = [UIColor whiteColor];
    _usernameLabel.textAlignment    = NSTextAlignmentCenter;
    _usernameLabel.font             = [UIFont fontWithName:@"Helvetica" size:7];
#warning TODO : FONT
    
    [self addSubview:_usernameLabel];
}

- (void)createDateLabel {
    
    CGFloat padding = 10.0f;
    
    _dateLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) - padding, CGRectGetHeight(self.bounds))];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    _dateLabel.numberOfLines    = 2;
    _dateLabel.backgroundColor  = [UIColor clearColor];
    _dateLabel.textColor        = [UIColor whiteColor];
    _dateLabel.textAlignment    = NSTextAlignmentRight;
    _dateLabel.font             = [UIFont fontWithName:@"Helvetica" size:7];
#warning TODO : FONT
    
    [self addSubview:_dateLabel];
}

#pragma mark - Data
- (void)setData:(id)data {
    
#warning TEMP
    [self createImage:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/378800000703808793/2f6dcc6353959ce2009d9ec7bf84baca.jpeg"]];
    [self createDate:[NSDate date]];
    [self createUsername:@"Some Username"];
#warning ENDTEMP
}

- (void)createImage:(NSURL *)url {
    
    [_smallPortraitImageView setImageWithURL:url];
    [_portraitImageView setImageWithURL:url];
}

- (void)createDate:(NSDate *)date {
    
    //Date formatters
    static NSDateFormatter *dateFormat;
    
    if(!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:kAFVDBaseNetworkDefaultDateDisplayMonthDayYearFormat];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    
    static NSDateFormatter *timeFormat;
    
    if(!timeFormat) {
        timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:kAFVDBaseNetworkDefaultDateDisplayHourMinutesFormat];
        [timeFormat setLocale:dateFormat.locale];
    }
    
    //Date strings
    NSMutableString *fullDateString = [[NSMutableString alloc] init];
    
    [fullDateString appendString:[dateFormat stringFromDate:date]];
    [fullDateString appendString:@"\n"];
    [fullDateString appendString:[timeFormat stringFromDate:date]];

    _dateLabel.text = fullDateString;
}

- (void)createUsername:(NSString *)username {
    
    _usernameLabel.text = username;
    [_usernameLabel sizeToFit];
}

#pragma mark - Position
- (void)checkCellPositionInView:(UIView *)view {
    
#warning TODO :    kAFVDTimelineCanvasCell_PortraitResizeThreshold
    
    /*
     
     Handles portrait color
     Handles date alpha / parallax
     Handles small portrait parallax
     
     */
    
    //Cell y position
    CGRect localRectContainer = view.frame;
    CGPoint localPositioninContainer = self.frame.origin;
    NSUInteger localRectContainerHeight = floor(CGRectGetHeight(localRectContainer));
    NSUInteger localPositioninContainerY = floor(localPositioninContainer.y);
    
    localPositioninContainerY %= localRectContainerHeight;
    
    //Portrait data
    CGRect portraitFrame;
    UIColor *portraitColor;
    CGFloat hue = (kAFVDTimelineCanvasCell_Hue / 256.0f);
    CGFloat saturation = 0.0f;
    
    //Date data
    CGFloat dateAlpha = 1.0f;
    
#warning TODO kAFVDTimelineCanvasCell_PortraitResizeThreshold

    //Check if container view has cell position
    if(CGRectContainsPoint(view.frame, CGPointMake(0, localPositioninContainerY))) {
        
        //Calculate position percentage for top position and container with threshold
        CGFloat containerCenterY = view.center.y;
        CGFloat containerHeight = CGRectGetHeight(view.frame);
        CGFloat positionDifferenceY = abs(containerCenterY - localPositioninContainerY);
        CGFloat positionPerentage = (containerHeight - positionDifferenceY) / containerHeight;

        /** Portrait image position. */
        //Center portrait image
        CGFloat portraitWidth     = MAX(kAFVDTimelineCanvasCell_PortraitMinWidthHeight, MIN(kAFVDTimelineCanvasCell_PortraitMaxWidthHeight * positionPerentage, kAFVDTimelineCanvasCell_PortraitMaxWidthHeight));
        CGFloat portraitHeight    = portraitWidth;
        CGFloat portraitLeft      = (self.bounds.size.width - portraitWidth) * 0.5f;
        CGFloat portraitTop       = (self.bounds.size.height - portraitHeight) * 0.5f;

        //Portrait view frame
        portraitFrame             = CGRectMake(portraitLeft, portraitTop, portraitWidth, portraitHeight);
        
        /** Portrait color */
        saturation = 1.0f - MAX(MIN((1.0f - positionPerentage) * 2, 1.0f), 0.0f);
        
        /** Date alpha */
        dateAlpha = MAX(1.0f - MAX(MIN((1.0f - positionPerentage) * 2, 1.0f), 0.0f), kAFVDTimelineCanvasCell_MinDateLabelAlpha);
    }
    
    portraitColor             = [UIColor colorWithHue:hue saturation:saturation brightness:1.0f alpha:1.0f];
    [self animatePortraitImageToFrame:portraitFrame portraitColor:portraitColor dateAlpha:dateAlpha];
}

- (void)animatePortraitImageToFrame:(CGRect)frame portraitColor:(UIColor *)portraitColor dateAlpha:(CGFloat)dateAlpha {
    
#warning TEMP....SHOULD BE CA ANIMATION
    
    [UIView animateWithDuration:0.15f animations:^{
        
        //Portrait image
        _portraitImageView.frame = frame;
        _portraitImageView.layer.cornerRadius = trunc(CGRectGetWidth(frame) / 2);
        _portraitImageView.layer.borderColor = portraitColor.CGColor;
        
        //Date
        _dateLabel.alpha = dateAlpha;
    }];
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.15f];
//    
//    _portraitImageView.frame = frame;
//    _portraitImageView.layer.cornerRadius = trunc(CGRectGetWidth(frame) / 2);
//    
//    [CATransaction commit];
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
            
            _backgroundLine.frame = CGRectMake(left, 0, width, CGRectGetHeight(self.bounds));
            
            //Top line
        } else if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_Top) {
            
            _backgroundLine.frame = CGRectMake(left, 0, width, ceil(CGRectGetHeight(self.bounds) / 2));
            
            //Bottom line
        } else if(position & kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom) {
            
            _backgroundLine.frame = CGRectMake(left, CGRectGetMidY(self.bounds), width, ceil(CGRectGetHeight(self.bounds) / 2));
        }
    }
}

#pragma mark - Cell height
+ (CGFloat)cellHeight {
    
    return kAFVDTimelineCanvasCell_CellHeight;
}

@end
