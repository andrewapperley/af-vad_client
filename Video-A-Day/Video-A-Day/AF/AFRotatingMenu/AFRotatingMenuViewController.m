//
//  AFRotatingMenuViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 2/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFRotatingMenuViewController.h"
#import "AFRotatingMenuDataSource.h"

@interface AFRotatingMenuViewController () {
    UICollectionView* rotatingCollectionView;
    id delegate;
    AFRotatingMenuDataSource* datasource;
}

@end

@implementation AFRotatingMenuViewController

- (id)init {
    self = [super init ];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
