//
//  AFVDFilterTileButton.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/5/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFVDFilterTileButton : UIButton

@property(nonatomic, strong, readonly)NSString *filterName;

- (instancetype)initWithFrame:(CGRect)frame andFilter:(NSString *)filter;

@end
