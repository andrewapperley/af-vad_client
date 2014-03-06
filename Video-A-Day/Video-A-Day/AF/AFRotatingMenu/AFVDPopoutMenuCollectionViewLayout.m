//
//  AFRotatingMenuCollectionViewLayout.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/20/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDPopoutMenuCollectionViewLayout.h"
#import "AFVDPopoutMenuDataSource.h"

@implementation AFVDPopoutMenuCollectionViewLayout

- (instancetype)init {
    
    if (self = [super init]) {
        self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    
//    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
//
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    
//    for (UICollectionViewLayoutAttributes* attribute in attributes) {
//        if (CGRectIntersectsRect(attribute.frame, rect)) {
//            
//        }
//    }
//    return attributes;
//}


//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    
//}

//- (CGSize)collectionViewContentSize {
//    
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

@end