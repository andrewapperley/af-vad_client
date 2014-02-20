//
//  AFRotatingMenuDataSource.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuDataSource.h"
#import "AFRotatingMenuDataSourceItemFactory.h"

@implementation AFRotatingMenuDataSource

- (instancetype)init {
    if (self = [super init]) {
        _menuItems = [[NSArray alloc] init];
    }
    return self;
}

- (void)setMenuItemsWithModel:(AFRotatingMenuControllerModel *)model {
    
    _menuItems = [AFRotatingMenuDataSourceItemFactory generateMenuItemsFromMenuModel:model];
    
}

@end