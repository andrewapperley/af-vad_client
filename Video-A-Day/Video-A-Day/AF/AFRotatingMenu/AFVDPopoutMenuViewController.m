//
//  AFRotatingMenuViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDPopoutMenuViewController.h"
#import "AFVDPopoutMenuDataSource.h"
#import "AFVDPopoutMenuCollectionViewLayout.h"
#import "AFVDPopoutMenuCollectionViewCell.h"
#import "AFVDPopoutMenuStatics.h"
#import "AFVDPopoutMenuMenuItem.h"
#import "AFVDPopoutMenuCollectionView.h"

@interface AFVDPopoutMenuViewController () <UICollectionViewDelegate> {
    AFVDPopoutMenuCollectionView* _rotatingCollectionView;
    AFVDPopoutMenuDataSource* _datasource;
    AFVDPopoutMenuControllerModel* _currentModel;
    CGRect _menuFrame;
}

@end

@implementation AFVDPopoutMenuViewController

#pragma mark - Init methods

- (instancetype)initWithModel:(AFVDPopoutMenuControllerModel *)model frame:(CGRect)frame {
    if (self = [super init]) {
        _currentModel = model;
        _menuFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _menuFrame;
    AFVDPopoutMenuCollectionViewLayout* layout = [[AFVDPopoutMenuCollectionViewLayout alloc] init];
    _rotatingCollectionView = [[AFVDPopoutMenuCollectionView alloc] initWithFrame:CGRectMake(0, 0, _menuFrame.size.width, _menuFrame.size.height) collectionViewLayout:layout];
    _datasource = [[AFVDPopoutMenuDataSource alloc] init];
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView setDelegate:self];
    [_rotatingCollectionView setDataSource:_datasource];
    [_rotatingCollectionView registerClass:[AFVDPopoutMenuCollectionViewCell class] forCellWithReuseIdentifier:kAFVDPopoutMenuCollectionViewCellId];
    [self.view addSubview:_rotatingCollectionView];
}

#pragma mark - Public Menu methods

- (void)refreshMenuWithModel:(AFVDPopoutMenuControllerModel *)model {
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView setCollectionViewLayout:[[AFVDPopoutMenuCollectionViewLayout alloc] init] animated:YES];
    [_rotatingCollectionView reloadData];
    [_rotatingCollectionView performBatchUpdates:^{
        [_rotatingCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}

- (void)closeMenu {
    
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:(SEL)((AFVDPopoutMenuMenuItem *)_datasource.menuItems[indexPath.row]).menuItemSelector]) {
        /** ARC requires enough info about the method so it can enforce proper MM rules. */
        AFVDPopoutMenuMenuItem* item    = (AFVDPopoutMenuMenuItem *)_datasource.menuItems[indexPath.row];
        SEL _selector               = (SEL)item.menuItemSelector;
        IMP imp                     = [_delegate methodForSelector:_selector];
        void (*func)(id, SEL, id)   = (void *)imp;
        func(_delegate, _selector, item);
    }
}

#pragma mark - Cleanup

- (void)dealloc {
    _delegate                           = nil;
    _rotatingCollectionView.delegate    = nil;
    _rotatingCollectionView.dataSource  = nil;
}

@end