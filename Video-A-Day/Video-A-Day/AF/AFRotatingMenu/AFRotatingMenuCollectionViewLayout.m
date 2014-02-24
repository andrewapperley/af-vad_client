//
//  AFRotatingMenuCollectionViewLayout.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/20/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuCollectionViewLayout.h"
#import "AFRotatingMenuDataSource.h"

@implementation AFRotatingMenuCollectionViewLayout

- (instancetype)init {
    
    if (self = [super init]) {
        self.sectionInset       = UIEdgeInsetsMake(100, 0, 0, 0);
        self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attribute in attributes) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            attribute.center = CGPointMake(visibleRect.size.width/2 + self.collectionView.center.x * cosf(2 * attribute.indexPath.item * M_PI_2 / 4), visibleRect.size.width/2 + self.collectionView.center.y * sinf(2 * attribute.indexPath.item * M_PI_2 / 4));
        }
    }
    return attributes;
}


//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    
//}

//- (CGSize)collectionViewContentSize {
//    
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end