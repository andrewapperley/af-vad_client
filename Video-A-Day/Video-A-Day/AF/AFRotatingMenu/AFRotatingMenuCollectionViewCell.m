//
//  AFRotatingMenuCollectionViewCell.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuCollectionViewCell.h"
#import "AFRotatingMenuStatics.h"

@interface AFRotatingMenuCollectionViewCell() {
    UIImageView* _iconView;
}

@end

@implementation AFRotatingMenuCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconView                       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kAFRotatingMenuCollectionViewCellIconSize, kAFRotatingMenuCollectionViewCellIconSize)];
        _iconView.layer.cornerRadius    = _iconView.frame.size.width * 0.5f;
        _iconView.contentMode           = UIViewContentModeScaleAspectFit;
        _iconView.clipsToBounds         = YES;
        _iconView.backgroundColor       = [UIColor whiteColor];
        [self.contentView addSubview:_iconView];
        _menuItemTitleLabel             = [[UILabel alloc] init];
        _menuItemTitleLabel.alpha       = 0;
        [self.contentView addSubview:_menuItemTitleLabel];
        self.alpha                      = 0.8f;
    }
    return self;
}

- (void)setIcon:(UIImage *)icon {
    _iconView.image = icon;
}

@end
