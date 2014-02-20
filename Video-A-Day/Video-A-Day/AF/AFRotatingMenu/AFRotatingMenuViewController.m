//
//  AFRotatingMenuViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuViewController.h"
#import "AFRotatingMenuDataSource.h"
#import "AFRotatingMenuCollectionViewLayout.h"
#import "AFRotatingMenuCollectionViewCell.h"
#import "AFRotatingMenuStatics.h"
#import "AFRotatingMenuItem.h"

@interface AFRotatingMenuViewController () <UICollectionViewDelegate> {
    UICollectionView* _rotatingCollectionView;
    AFRotatingMenuDataSource* _datasource;
    AFRotatingMenuControllerModel* _currentModel;
}

@end

@implementation AFRotatingMenuViewController

- (instancetype)initWithModel:(AFRotatingMenuControllerModel *)model {
    if (self = [super init]) {
        _currentModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _datasource = [[AFRotatingMenuDataSource alloc] init];
    [_datasource setMenuItemsWithModel:_currentModel];
	_rotatingCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[AFRotatingMenuCollectionViewLayout alloc] init]];
    [_rotatingCollectionView setDelegate:self];
    [_rotatingCollectionView setDataSource:_datasource];
    [_rotatingCollectionView registerClass:[AFRotatingMenuCollectionViewCell class] forCellWithReuseIdentifier:kAFRotatingMenuCollectionViewCellId];
    [self.view addSubview:_rotatingCollectionView];
}

- (void)refreshMenuWithModel:(AFRotatingMenuControllerModel *)model {
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:(SEL)((AFRotatingMenuItem *)_datasource.menuItems[indexPath.row]).menuItemSelector]) {
        /** ARC requires enough info about the method so it can enforce proper MM rules. */
        SEL _selector           = (SEL)((AFRotatingMenuItem *)_datasource.menuItems[indexPath.row]).menuItemSelector;
        IMP imp                 = [_delegate methodForSelector:_selector];
        void (*func)(id, SEL)   = (void *)imp;
        func(_delegate, _selector);
    }
}

- (void)dealloc {
    _delegate                           = nil;
    _rotatingCollectionView.delegate    = nil;
    _rotatingCollectionView.dataSource  = nil;
}

@end