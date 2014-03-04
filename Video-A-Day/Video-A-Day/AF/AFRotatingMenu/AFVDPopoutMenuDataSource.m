//
//  AFRotatingMenuDataSource.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDPopoutMenuDataSource.h"
#import "AFVDPopoutMenuDataSourceItemFactory.h"
#import "AFVDPopoutMenuStatics.h"
#import "AFVDPopoutMenuCollectionViewCell.h"
#import "AFVDPopoutMenuMenuItem.h"

@implementation AFVDPopoutMenuDataSource

- (instancetype)init {
    if (self = [super init]) {
        _menuItems = [[NSArray alloc] init];
    }
    return self;
}

- (void)setMenuItemsWithModel:(AFVDPopoutMenuControllerModel *)model {
    
    _menuItems = [AFVDPopoutMenuDataSourceItemFactory generateMenuItemsFromMenuModel:model];
    
}

#pragma mark - UICollectionViewDataSource methods

- (AFVDPopoutMenuCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AFVDPopoutMenuCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFVDPopoutMenuCollectionViewCellId forIndexPath:indexPath];
    
    AFVDPopoutMenuMenuItem* menuItem = (AFVDPopoutMenuMenuItem *)_menuItems[indexPath.row];
    
    /*This could be put into the cell but is fine here for now*/
    cell.icon = menuItem.menuItemIcon;
    cell.menuItemTitleLabel.text = menuItem.menuItemTitle;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuItems.count;
}

@end