//
//  AFRotatingMenuDataSourceItemFactory.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuDataSourceItemFactory.h"
#import "AFRotatingMenuItem.h"

@implementation AFRotatingMenuDataSourceItemFactory

+ (NSArray *)generateMenuItemsFromMenuModel:(AFRotatingMenuControllerModel *)model {
    
    NSUInteger largestArrayCount = 0;
    
    largestArrayCount = (model.titles.count >= model.icons.count) ? model.titles.count : (model.icons.count >= model.selectors.count) ? model.icons.count : model.selectors.count;
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithCapacity:largestArrayCount];
    
    for (NSInteger i = 0; i < largestArrayCount; i++) {
        
        NSString* _title    = (i < model.titles.count) ? model.titles[i] : nil;
        UIImage* _icon      = (i < model.icons.count) ? model.icons[i] : nil;
        SEL _selector       = (i < model.selectors.count) ? NSSelectorFromString(model.selectors[i]) : nil;
        
        AFRotatingMenuItem* menuItem = [[AFRotatingMenuItem alloc] initMenuItemWithTitle:_title icon:_icon selector:_selector];
        
        [returnArray addObject:menuItem];
    }
    
    return (NSArray *)returnArray;
}

@end