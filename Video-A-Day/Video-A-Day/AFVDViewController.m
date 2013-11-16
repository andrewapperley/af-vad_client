//
//  AFVDViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDViewController.h"

#warning TEMP VC
#import "AFVDUserModelFactory.h"

@interface AFVDViewController ()

@end

@implementation AFVDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AFVDUserModelFactory *userModelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSString *username = @"andrewApperley";
    NSString *token = @"c60f789ea83ec7452149cce7571f5bb661e53d8a67d37b81bc98d593";
    
    NSLog(@"Start");
    
    [userModelFactory fetchUserModelWithUserName:username accessToken:token completion:^(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish - Success");
            
            UIImageView *profileImage = [[UIImageView alloc] initWithImage:userModel.profileImage];
            [self.view addSubview:profileImage];
            
            profileImage.center = self.view.center;
            
        } else {
            NSLog(@"Finish - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning END TEMP VC

@end
