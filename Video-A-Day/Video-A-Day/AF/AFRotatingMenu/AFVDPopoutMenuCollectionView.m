//
//  AFRotatingMenuCollectionView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/21/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDPopoutMenuCollectionView.h"

@implementation AFVDPopoutMenuCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        CAShapeLayer* circleOutline     = [[CAShapeLayer alloc] init];
//        circleOutline.fillColor         = [UIColor clearColor].CGColor;
//        circleOutline.path              = CGPathCreateWithEllipseInRect(CGRectMake((self.frame.size.width - self.frame.size.width/1.5)/2, self.frame.size.width/1.5, self.frame.size.width/1.5, self.frame.size.width/1.5), 0);
//        circleOutline.strokeColor       = [UIColor whiteColor].CGColor;
//        circleOutline.lineWidth         = 1;
//        [self.layer addSublayer:circleOutline];
        [self setDirectionalLockEnabled:YES];
        [self setPagingEnabled:YES];
    }
    return self;
}


@end