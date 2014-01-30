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

//Portrait hue
CGFloat const kAFVDTimelineCanvasCell_Hue                       = 90.0f;

//Date label
CGFloat const kAFVDTimelineCanvasCell_MinDateLabelAlpha         = 0.4f;

@interface AFVDTimelineCanvasCell () {
    
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
        
        self.clipsToBounds = NO;
        [self createSmallPortraitImageView];
        [self createPortraitImageView];
        [self createUsernameLabel];
        [self createDateLabel];
    }
    return self;
}

- (void)createSmallPortraitImageView {
    
    CGFloat padding     = 15.0f;
    CGFloat topOffset   = 6.0f;
    
    //Small portrait image
    _smallPortraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, ceil((self.bounds.size.height - kAFVDTimelineCanvasCell_SmallPortraitWidthHeight) * 0.5f) - topOffset, kAFVDTimelineCanvasCell_SmallPortraitWidthHeight, kAFVDTimelineCanvasCell_SmallPortraitWidthHeight)];
    
    //Border and corner radius
    _smallPortraitImageView.layer.borderWidth = kAFVDTimelineCanvasCell_SmallPortraitBorderWidth;
    _smallPortraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
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
    _portraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
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
- (void)setParallaxPosition:(CGFloat)position {
    
    CGRect bounds = self.bounds;
    
    const CGFloat padding = (CGRectGetWidth(bounds) - kAFVDTimelineCanvasCell_CellHeight) * 0.5f;
    
    const CGFloat minOffsetY  = -padding;
    const CGFloat maxOffsetY  = padding;
    
    const CGFloat minPosition = -2.0f;
    const CGFloat maxPosition = 2.0f;
    
    //Vertical offset
    CGFloat offsetY = (maxOffsetY - minOffsetY) / (maxPosition - minPosition) * (position - minPosition) + minOffsetY;
    
    //Portrait
    [self adjustPortrait:offsetY];
    [self adjustSmallPortrait:offsetY];
    [self adjustSmallPortraitLabel:offsetY];
    [self adjustDateLabel:offsetY];
}

#pragma mark - Adjust cell subview components
- (void)adjustPortrait:(CGFloat)offsetY {
    
    //Position percentage
    CGFloat positionPerentage = offsetY / kAFVDTimelineCanvasCell_CellHeight;
    
    //Portrait frame
    CGRect portraitFrame      = _portraitImageView.frame;
    CGFloat portraitHeight    =  MAX(kAFVDTimelineCanvasCell_PortraitMaxWidthHeight * positionPerentage, kAFVDTimelineCanvasCell_PortraitMinWidthHeight);
    portraitFrame.size.width  = portraitHeight;
    portraitFrame.size.height = portraitHeight;
    portraitFrame.origin.x    = ceil((CGRectGetWidth(self.bounds) - CGRectGetWidth(portraitFrame)) * 0.5f);
    portraitFrame.origin.y    = ceil((kAFVDTimelineCanvasCell_CellHeight - CGRectGetHeight(portraitFrame)) * 0.5f) + offsetY;
    _portraitImageView.frame  = portraitFrame;
    
    //Portrait corner radius
    _portraitImageView.layer.cornerRadius = trunc(CGRectGetWidth(portraitFrame) * 0.5f);
    
    //Portrait data
    CGFloat hue               = (kAFVDTimelineCanvasCell_Hue / 256.0f);
    CGFloat saturation        = positionPerentage;
    UIColor *portraitColor    = [UIColor colorWithHue:hue saturation:saturation brightness:1.0f alpha:1.0f];
    
    //Portrait border
    _portraitImageView.layer.borderColor = portraitColor.CGColor;
}

- (void)adjustSmallPortrait:(CGFloat)offsetY {
    
    //Small portait frame
    CGFloat smallPortaitTopOffset           = 6.0f;
    
    CGRect smallPortraitFrame     = _smallPortraitImageView.frame;
    smallPortraitFrame.origin.y   = ceil(((kAFVDTimelineCanvasCell_CellHeight - kAFVDTimelineCanvasCell_SmallPortraitWidthHeight) * 0.5f) - smallPortaitTopOffset) + offsetY * 1.5f;
    _smallPortraitImageView.frame = smallPortraitFrame;
}

- (void)adjustSmallPortraitLabel:(CGFloat)offsetY {
    
    //Username label
    CGFloat userNamePadding                 = 2.0f;
    CGFloat userNameExtraLabelWidth         = 5.0f;
    
    CGRect usernameLabelFrame = _usernameLabel.frame;
    usernameLabelFrame        = CGRectMake(CGRectGetMinX(_smallPortraitImageView.frame) - userNameExtraLabelWidth, CGRectGetMaxY(_smallPortraitImageView.frame) + userNamePadding, CGRectGetWidth(_smallPortraitImageView.bounds) + (userNameExtraLabelWidth * 2), CGRectGetHeight(_usernameLabel.frame));
    
    _usernameLabel.frame      = usernameLabelFrame;
}

- (void)adjustDateLabel:(CGFloat)offsetY {
    
    //Date frame
    CGRect dateLabelFrame   = _dateLabel.frame;
    dateLabelFrame.origin.y   = ceil((kAFVDTimelineCanvasCell_CellHeight - CGRectGetHeight(dateLabelFrame)) * 0.5f) + offsetY * 1.5f;
    _dateLabel.frame        = dateLabelFrame;
    
    //Position percentage
    CGFloat positionPerentage = CGRectGetMaxY(dateLabelFrame) / (kAFVDTimelineCanvasCell_CellHeight);
    if(positionPerentage > 0.5f) {
        
        positionPerentage = 2.0f - positionPerentage;
    }
    
    //Date alpha
    CGFloat dateAlpha = MAX(positionPerentage, kAFVDTimelineCanvasCell_MinDateLabelAlpha);
    _dateLabel.alpha = dateAlpha;
}

#pragma mark - Reuse
- (void)prepareForReuse {
    
    _portraitImageView.image        = nil;
    _smallPortraitImageView.image   = nil;
    _dateLabel.text                 = nil;
    _usernameLabel.text             = nil;
}

#pragma mark - Cell height
+ (CGFloat)cellHeight {
    
    return kAFVDTimelineCanvasCell_CellHeight;
}

@end
