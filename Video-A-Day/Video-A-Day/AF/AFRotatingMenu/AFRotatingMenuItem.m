//
//  AFRotatingMenuItem.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuItem.h"

@implementation AFRotatingMenuItem

- (instancetype)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)icon selector:(SEL)selector {
    if (self = [super init]) {
        _menuItemTitle      = title;
        _menuItemIcon       = icon;
        _menuItemSelector   = selector;
    }
    return self;
}

@end