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
#import "AFVDVideoModelFactory.h"

NSString *userName = @"andrewApperley";
NSString *token = @"c60f789ea83ec7452149cce7571f5bb661e53d8a67d37b81bc98d593";
NSString *password = @"Abcde321";

@interface AFVDViewController ()

@end

@implementation AFVDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self fetchUserModel];
    [self fetchRelationshipModel];
    [self fetchVideoModel];
    [self loginUser];
}

- (void)loginUser {
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
      NSLog(@"Start AFVDLogin");
    
    [modelFactory fetchUserModelAndAccessTokenWithUserName:userName andPassword:password completion:^(AFVDUserModel *userModel, NSString *access_token, AFVDBaseNetworkModel *networkCallback){
        if (networkCallback.success) {
            NSLog(@"Finish AFVDLogin - Success");
            NSLog(@"Access Token - %@", access_token);
        }
    }];
}

- (void)fetchUserModel {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUserModel");
    
    [modelFactory fetchUserModelWithUserName:userName accessToken:token completion:^(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUserModel - Success");
            
            UIImageView *profileImage = [[UIImageView alloc] initWithImage:userModel.profileImage];
            [self.view addSubview:profileImage];
            
            profileImage.center = self.view.center;
            
        } else {
            NSLog(@"Finish AFVDUserModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchRelationshipModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSString *relationshipId = @"123456789";
    
    NSLog(@"Start AFVDVideoRelationshipModel");
    
    [modelFactory fetchVideoRelationshipModelWithUserName:userName relationshipId:relationshipId accessToken:token completion:^(AFVDVideoRelationshipModel *videoRelationshipModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoRelationshipModel - Success");
            
        } else {
            NSLog(@"Finish AFVDVideoRelationshipModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchVideoModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSString *playlistId = @"123456789";
    NSUInteger pageIndex = 0;
    
    NSLog(@"Start AFVDVideoPlaylistModel");
    
    [modelFactory fetchVideoPlaylistModelWithUserName:userName playlistId:playlistId accessToken:token pageIndex:pageIndex completion:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoPlaylistModel - Success");
            
        } else {
            NSLog(@"Finish AFVDVideoPlaylistModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
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
