//
//  AFRotatingMenuItem.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFRotatingMenuItem : NSObject

@property(nonatomic, strong, readonly)NSString* menuItemTitle;
@property(nonatomic, strong, readonly)UIImage* menuItemIcon;
@property(nonatomic, readonly)SEL menuItemSelector;

- (instancetype)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)icon selector:(SEL)selector;

@end