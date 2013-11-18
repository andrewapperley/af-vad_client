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

- (void)fetchUserModel {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUserModel");
    
    [modelFactory fetchUserModelWithUserName:userName accessToken:token completion:^(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUserModel - Success");
            
            NSString *profileImageURL = userModel.userImageUrl;
            NSTimeInterval timeInterval = 60 * 30; // 30 minutes
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:timeInterval];
            
            UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
            [profileImage setImageWithURL:profileImageURL placeholderImage:nil expiryDate:date willCache:TRUE];
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

- (void)loginUser {
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    NSLog(@"Start AFVDLogin");
    
    [modelFactory fetchUserModelAndAccessTokenWithUserName:userName andPassword:password completion:^(AFVDUserModel *userModel, NSString *access_token, AFVDBaseNetworkModel *networkCallback){
        if (networkCallback.success) {
            NSLog(@"Finish AFVDLogin - Success");
            NSLog(@"Access Token - %@", access_token);
        }
    }];
    [self createVideo];
}

- (void)createVideo {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];

    NSLog(@"Start VideoCreation");

    //Video content
    NSString *testVideoString = @"5646w5e4r62438we9r849df";
    NSData *videoData = [testVideoString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *videoContent = [videoData base64EncodedStringWithOptions:0];

    //Video thumbnail
    NSString *testThumbnailString = @"5646w5e4r62438we9r849df";
    NSData *thumbnailData = [testThumbnailString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *thumbnailContent = [thumbnailData base64EncodedStringWithOptions:0];

    NSString *relationshipId = @"123456789";
    NSString *date = @"2013-11-17";
    
    [modelFactory postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:token videoThumbnail:thumbnailContent completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish VideoCreation - Success");
            
        } else {
            NSLog(@"Finish VideoCreation - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

#warning END TEMP VC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
