//
//  AFVDVideoFilterModel.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 2014-03-03.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDVideoFilterModel : NSObject

@property(nonatomic, strong)NSString* filterClassName;
@property(nonatomic, strong)NSString* filterTitle;
@property(nonatomic, strong)UIImage* filterImage;

+ (instancetype)filterModelWithClassName:(NSString *)className title:(NSString *)title image:(NSString *)image;

@end