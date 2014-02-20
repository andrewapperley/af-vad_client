//
//  AFRotatingMenuViewController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFRotatingMenuControllerModel;

@interface AFRotatingMenuViewController : UIViewController

@property(nonatomic, weak)id delegate;

- (instancetype)initWithModel:(AFRotatingMenuControllerModel *)model;

@end