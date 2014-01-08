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
NSString *kAFVDTimelineCanvas_CellIdentifier = @"kAFVDTimelineCanvasCellIdentifier";

@interface AFVDTimelineCanvas () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView    *_collectionView;
}

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
    collectionViewLayout.itemSize = CGSizeMake(self.bounds.size.width, [AFVDTimelineCanvasCell cellHeight]);

    //Collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[AFVDTimelineCanvasCell class] forCellWithReuseIdentifier:kAFVDTimelineCanvas_CellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //Collection view inset
    CGFloat edgeInset = CGRectGetMidY(self.bounds) - ([AFVDTimelineCanvasCell cellHeight] / 2);
    _collectionView.contentInset = UIEdgeInsetsMake(edgeInset, 0, edgeInset, 0);
    
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
    AFVDTimelineCanvasCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAFVDTimelineCanvas_CellIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        
        cell = [[AFVDTimelineCanvasCell alloc] init];
    }
    
    //Data
    id data = _data[indexPath.row];
    [cell setData:data];
    
    //Set background line position
    [self setCellBackgroundLinePosition:cell index:indexPath.row];
    
    return cell;
}

- (void)setCellBackgroundLinePosition:(AFVDTimelineCanvasCell *)cell index:(NSUInteger)index {
    
    AFVDTimelineCanvasCellBackgroundLinePosition position = kAFVDTimelineCanvasCellBackgroundLinePosition_None;
    
    BOOL hasTop    = index > 0;
    BOOL hasBottom = index < _data.count - 1;
    
    if(hasTop && hasBottom) {
        
        position = kAFVDTimelineCanvasCellBackgroundLinePosition_Top & kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom;
        
    } else if(hasTop) {
        
        position = kAFVDTimelineCanvasCellBackgroundLinePosition_Top;
    } else if(hasBottom) {
        
        position = kAFVDTimelineCanvasCellBackgroundLinePosition_Bottom;
    }
    
    [cell setBackgroundLinePosition:position];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for(AFVDTimelineCanvasCell *cell in _collectionView.visibleCells) {
        
#warning TODO : CALCULATE POSITION
        if([cell isKindOfClass:[AFVDTimelineCanvasCell class]]) {
            
            [cell checkCellPositionInView:self];
        }
    }
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
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:TRUE];
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
