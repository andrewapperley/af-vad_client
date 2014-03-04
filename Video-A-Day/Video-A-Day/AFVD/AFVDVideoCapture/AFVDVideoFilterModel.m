//
//  AFVDVideoFilterModel.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2014-03-03.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDVideoFilterModel.h"

@implementation AFVDVideoFilterModel

+ (instancetype)filterModelWithClassName:(NSString *)className title:(NSString *)title image:(NSString *)image {
    AFVDVideoFilterModel* filterModel = [[AFVDVideoFilterModel alloc] init];
    filterModel.filterClassName = className;
    filterModel.filterTitle     = title;
    filterModel.filterImage     = [UIImage imageNamed:image];
    return filterModel;
}

@end