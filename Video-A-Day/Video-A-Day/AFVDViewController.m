//
//  AFVDViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDViewController.h"
#import "AFVDTimeline.h"
#import "AFVDVideoModelFactory.h"

@interface AFVDViewController () <AFVDTimelineDelegate, AFVDTimelineDataSource>

@end

@implementation AFVDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTimeline];
}

- (void)createTimeline {
    
    AFVDTimeline *timeline = [[AFVDTimeline alloc] init];
    timeline.delegate = self;
    timeline.dataSource = self;
    [self.view addSubview:timeline.view];
    
    [timeline reloadData];
    
#warning TEMP
    
    UIView *uglyAssLine = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height / 2) - 1, self.view.bounds.size.width, 2)];
    uglyAssLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:uglyAssLine];
#warning ENDTEMP
}

#pragma mark - AFVDTimelineDataSource
- (void)timeline:(AFVDTimeline *)timeline willLoadInitialData:(AFVDTimelineInitialData)initialData {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSUInteger i = 0; i < 20; i++) {
    
        [array addObject:@(i)];
    }
    
    initialData(array);
}

- (void)timeline:(AFVDTimeline *)timeline willLoadAppendedData:(AFVDTimelineAppendedData)appendedData {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    [modelFactory videosAtPageIndex:1 userName:@"" accessToken:@"" success:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
       
        appendedData(videoPlaylistModel.videos);
        
    } failure:^(NSError *error) {
        appendedData(nil);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
