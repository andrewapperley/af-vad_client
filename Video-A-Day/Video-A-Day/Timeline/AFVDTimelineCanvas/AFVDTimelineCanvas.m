//
//  AFVDTimelineCanvas.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDTimelineCanvas.h"
#import "AFVDTimelineCanvasCell.h"
#import "AFVDTimelineCanvasLayout.h"

NSString *kAFVDTimelineCanvasCellIdentifier = @"timelineCanvasCellIdentifier";

@interface AFVDTimelineCanvas () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView    *_collectionView;
}

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation AFVDTimelineCanvas

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
      
        [self createCollectionView];
    }
    return self;
}

#pragma mark - Create collection view
- (void)createCollectionView {

    //Collection view layout
    AFVDTimelineCanvasLayout *collectionViewLayout = [[AFVDTimelineCanvasLayout alloc] init];

    //Collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[AFVDTimelineCanvasCell class] forCellWithReuseIdentifier:kAFVDTimelineCanvasCellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
}

#pragma mark - UICollectionViewDelegate
#warning TODO

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell
    AFVDTimelineCanvasCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFVDTimelineCanvasCellIdentifier forIndexPath:indexPath];
    
    //Data
    id data = _data[indexPath.row];
    [cell setData:data];
        
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for(AFVDTimelineCanvasCell *cell in _collectionView.visibleCells) {
        
#warning TODO : CALCULATE POSITION
        CGPoint cellPosition;
        [cell setCellPosition:cellPosition withinContainer:_collectionView.bounds];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
#warning TODO
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
#warning TODO
}

-  (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
#warning TODO
}

#pragma mark - Data handling
- (void)setData:(NSArray *)data {
    
    _data = [NSMutableArray arrayWithArray:data];
    [_collectionView reloadData];
}

- (void)appendData:(NSArray *)data {
    
    [_data addObjectsFromArray:data];
    [_collectionView reloadData];
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _delegate = nil;
}

@end
