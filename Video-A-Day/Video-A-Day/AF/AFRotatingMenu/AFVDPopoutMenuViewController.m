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
        _currentModel           = model;
        _menuFrame              = frame;
        _isOpen                 = YES;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _menuFrame;
    AFVDPopoutMenuCollectionViewLayout* layout = [[AFVDPopoutMenuCollectionViewLayout alloc] init];
    _rotatingCollectionView = [[AFVDPopoutMenuCollectionView alloc] initWithFrame:CGRectMake(-_menuFrame.size.width, 0, _menuFrame.size.width, _menuFrame.size.height) collectionViewLayout:layout];
    _datasource = [[AFVDPopoutMenuDataSource alloc] init];
    [_datasource setMenuItemsWithModel:_currentModel];
    [_rotatingCollectionView setDelegate:self];
    [_rotatingCollectionView setDataSource:_datasource];
    [_rotatingCollectionView registerClass:[AFVDPopoutMenuCollectionViewCell class] forCellWithReuseIdentifier:kAFVDPopoutMenuCollectionViewCellId];
    [self.view addSubview:_rotatingCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self closeMenu:NO];
}

#pragma mark - Public Menu methods

- (void)refreshMenuWithModel:(AFVDPopoutMenuControllerModel *)model {
    if (_currentModel) {
        _currentModel = model;
    }
    [_datasource setMenuItemsWithModel:_currentModel];
    [self closeMenu:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAFVDPopoutMenuCloseDuration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_rotatingCollectionView reloadData];
        [self closeMenu:NO];
    });
}

- (void)closeMenu:(BOOL)close {
    [UIView animateWithDuration:kAFVDPopoutMenuCloseDuration animations:^{
        _rotatingCollectionView.frame = CGRectMake((close) ? -_rotatingCollectionView.frame.size.width : 0, _rotatingCollectionView.frame.origin.y, _rotatingCollectionView.frame.size.width, _rotatingCollectionView.frame.size.height);
    } completion:^(BOOL finished) {
        _isOpen = !_isOpen;
    }];
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