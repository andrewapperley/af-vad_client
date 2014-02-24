//
//  AFRotatingMenuDataSource.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuDataSource.h"
#import "AFRotatingMenuDataSourceItemFactory.h"
#import "AFRotatingMenuStatics.h"
#import "AFRotatingMenuCollectionViewCell.h"
#import "AFRotatingMenuItem.h"

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

#pragma mark - UICollectionViewDataSource methods

- (AFRotatingMenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AFRotatingMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFRotatingMenuCollectionViewCellId forIndexPath:indexPath];
    
    AFRotatingMenuItem* menuItem = (AFRotatingMenuItem *)_menuItems[indexPath.row];
    
    /*This could be put into the cell but is fine here for now*/
    cell.icon = menuItem.menuItemIcon;
    cell.menuItemTitleLabel.text = menuItem.menuItemTitle;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuItems.count;
}

@end