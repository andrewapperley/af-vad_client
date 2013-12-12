//
//  AFVDTimelineCanvas.m
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/11/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDTimelineCanvas.h"
#import "AFVDTimelineCanvasLayout.h"

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

    //Collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
}

#pragma mark - UICollectionViewDelegate
#warning TODO

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
#warning TODO
}

@end
