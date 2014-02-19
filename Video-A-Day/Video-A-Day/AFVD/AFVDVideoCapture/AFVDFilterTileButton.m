//
//  AFVDFilterTileButton.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/5/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDFilterTileButton.h"

static const NSString *kFilterTileImageSuffix = @"_filterTile";

@implementation AFVDFilterTileButton

- (instancetype)initWithFrame:(CGRect)frame andFilter:(NSString *)filter {
    self = [super initWithFrame:frame];
    if (self) {
        _filterName = filter;
        [self setBackgroundImageForTile];
    }
    
    return self;
}

- (void)setBackgroundImageForTile {
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_filterName, kFilterTileImageSuffix]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@_selected",_filterName, kFilterTileImageSuffix]] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@_selected",_filterName, kFilterTileImageSuffix]] forState:UIControlStateSelected];
}

@end
