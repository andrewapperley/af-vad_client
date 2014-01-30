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

#pragma mark - Constants
NSString *const kAFVDTimelineCanvas_CellIdentifier              = @"kAFVDTimelineCanvasCellIdentifier";

CGFloat const kAFVDTimelineCanvas_CellMarkerWidth               = 3.0f;
CGFloat const kAFVDTimelineCanvas_CellMarkerHeight              = 10.0f;
CGFloat const kAFVDTimelineCanvas_CellMarkerAnimateInDuration   = 0.35f;
CGFloat const kAFVDTimelineCanvas_CellMarkerAnimateOutDuration  = 0.15f;

@interface AFVDTimelineCanvas () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView    *_collectionView;
    UIView              *_currentCellMarker;
}

@end

@implementation AFVDTimelineCanvas

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
      
        [self createCollectionView];
        [self createCurrentCellMarker];
    }
    return self;
}

#pragma mark - Create collection view
- (void)createCollectionView {

    //Collection view layout
    AFVDTimelineCanvasLayout *collectionViewLayout = [[AFVDTimelineCanvasLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake(self.bounds.size.width, [AFVDTimelineCanvasCell cellHeight]);

    //Collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[AFVDTimelineCanvasCell class] forCellWithReuseIdentifier:kAFVDTimelineCanvas_CellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //Collection view inset
    CGFloat edgeInset = CGRectGetMidY(self.bounds) - ([AFVDTimelineCanvasCell cellHeight] * 0.5f);
    _collectionView.contentInset = UIEdgeInsetsMake(edgeInset, 0, edgeInset, 0);
    
    [self addSubview:_collectionView];
}

#pragma mark - Create current cell marker
- (void)createCurrentCellMarker {
    
    //Cell marker
    _currentCellMarker = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kAFVDTimelineCanvas_CellMarkerWidth, (CGRectGetHeight(self.bounds) - kAFVDTimelineCanvas_CellMarkerHeight) / 2, kAFVDTimelineCanvas_CellMarkerWidth, kAFVDTimelineCanvas_CellMarkerHeight)];
    _currentCellMarker.backgroundColor = [UIColor greenColor];
    [self addSubview:_currentCellMarker];
}

#pragma mark - UICollectionViewDelegate
#warning TODO

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell
    AFVDTimelineCanvasCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFVDTimelineCanvas_CellIdentifier forIndexPath:indexPath];
    
    //Data
    id data = _data[indexPath.row];
    [cell setData:data];
        
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.isDecelerating || scrollView.isDragging) {
        
        [UIView animateWithDuration:kAFVDTimelineCanvas_CellMarkerAnimateOutDuration animations:^{
           
            _currentCellMarker.alpha = 0.25f;
        }];

    } else {
        
        [UIView animateWithDuration:kAFVDTimelineCanvas_CellMarkerAnimateInDuration animations:^{
            
            _currentCellMarker.alpha = 1.0f;
        }];
    }
    
    //Parallax
    for(AFVDTimelineCanvasCell *cell in _collectionView.visibleCells) {
        
        CGFloat position = [self parallaxPositionForCell:cell];
        [cell setParallaxPosition:position];
    }
}

- (CGFloat)parallaxPositionForCell:(UICollectionViewCell *)cell {
    
    CGRect frame = cell.frame;
    CGPoint point = [[cell superview] convertPoint:frame.origin toView:_collectionView];
    
    const CGFloat minY = CGRectGetMinY(_collectionView.bounds) - CGRectGetHeight(frame);
    const CGFloat maxY = CGRectGetMaxY(_collectionView.bounds);
    
    const CGFloat minPos = -1.0f;
    const CGFloat maxPos = 1.0f;
    
    return (maxPos - minPos) / (maxY - minY) * (point.y - minY) + minPos;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self positionToCanvasCell:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self positionToCanvasCell:scrollView];
}

- (void)positionToCanvasCell:(UIScrollView *)scrollView {
    
    CGFloat contentYOffset = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    //Calculate current cell based on content position
    CGFloat cellHeight = [AFVDTimelineCanvasCell cellHeight];
    CGFloat currentYOffset = 0.0f;
    NSUInteger cellIndex = 0;
    
    while(TRUE) {
        
        if(currentYOffset >= contentYOffset - ceil((cellHeight * 0.5f))) {
            
            break;
        }
        
        currentYOffset += cellHeight;
        cellIndex ++;
    }
    
    cellIndex = MIN(cellIndex, _data.count - 1);
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0] atScrollPosition:UICollectionViewScrollPosit0 animated:TRUE];
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
