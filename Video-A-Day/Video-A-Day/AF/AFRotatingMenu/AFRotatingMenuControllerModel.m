//
//  AFRotatingMenuControllerModel.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuControllerModel.h"

@implementation AFRotatingMenuControllerModel

- (instancetype)initWithIcons:(NSArray *)icons titles:(NSArray *)titles selectors:(NSArray *)selectors {
    if (self = [super init]) {
        _icons      = icons;
        _titles     = titles;
        _selectors  = selectors;
    }
    return self;
}

@end