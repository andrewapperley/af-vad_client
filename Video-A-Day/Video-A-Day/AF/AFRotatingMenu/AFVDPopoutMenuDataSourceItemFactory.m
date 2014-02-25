//
//  AFRotatingMenuDataSourceItemFactory.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDPopoutMenuDataSourceItemFactory.h"
#import "AFVDPopoutMenuMenuItem.h"
#import "AFVDPopoutMenuStatics.h"

@implementation AFVDPopoutMenuDataSourceItemFactory

+ (NSArray *)generateMenuItemsFromMenuModel:(AFVDPopoutMenuControllerModel *)model {
    
    NSUInteger largestArrayCount = 0;
    
    largestArrayCount = (model.titles.count >= model.icons.count) ? model.titles.count : (model.icons.count >= model.properties.count) ? model.icons.count : (model.properties.count >= model.selectors.count) ? model.properties.count : model.selectors.count;
    NSMutableArray* returnArray = [[NSMutableArray alloc] initWithCapacity:largestArrayCount];
    
    [returnArray addObject:[AFVDPopoutMenuDataSourceItemFactory addCloseButtonMenuItem]];
    
    for (NSInteger i = 0; i < largestArrayCount; i++) {
        
        NSString* _title    = (i < model.titles.count) ? model.titles[i] : nil;
        UIImage* _icon      = (i < model.icons.count) ? model.icons[i] : nil;
        SEL _selector       = (i < model.selectors.count) ? NSSelectorFromString(model.selectors[i]) : nil;
        id _property        = (i < model.properties.count) ? model.properties[i] : nil;
        
        AFVDPopoutMenuMenuItem* menuItem = [[AFVDPopoutMenuMenuItem alloc] initMenuItemWithTitle:_title icon:_icon selector:_selector property:_property];
        
        [returnArray addObject:menuItem];
    }
    
    return (NSArray *)returnArray;
}

/*This is called to ensure that the first item is always the close button for the menu*/

+ (AFVDPopoutMenuMenuItem *)addCloseButtonMenuItem {
    
    AFVDPopoutMenuMenuItem* closeMenuItem = [[AFVDPopoutMenuMenuItem alloc] initMenuItemWithTitle:NSLocalizedString(@"kAFVDPopoutMenuCloseMenuItemTitle", nil) icon:[UIImage imageNamed:kAFVDPopoutMenuCloseMenuItemIconImage] selector:popoutMenuCloseButtonPressed property:nil];
    
    return closeMenuItem;
}

@end