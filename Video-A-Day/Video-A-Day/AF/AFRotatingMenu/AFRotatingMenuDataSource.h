//
//  AFRotatingMenuDataSource.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFRotatingMenuControllerModel, AFRotatingMenuDataSourceItemFactory;

@interface AFRotatingMenuDataSource : NSObject

@property(nonatomic, strong)NSArray* menuItems;
@property(nonatomic, strong)AFRotatingMenuDataSourceItemFactory* rotatingMenuDatasourceFactory;
+ (void)setMenuItemsWithModel:(AFRotatingMenuControllerModel *)model;

@end
