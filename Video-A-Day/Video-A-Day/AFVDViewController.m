//
//  AFVDViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/15/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDBaseNetworkModel.h"
#import "AFVDViewController.h"
#import "AFVDUrlHasher.h"

#warning TEMP VC
#import "AFVDUserModelFactory.h"
#import "AFVDVideoModelFactory.h"
#import "AFVDRelationshipModelFactory.h"

NSString *userName = @"jeremyFuelldsfsdert1000";
NSString *displayName = @"Nice Display Name";
NSString *otherUserName = @"someOtherUsername";
NSString *playlistId = @"d65cab706962faf9396aa94e4193ddb9";
NSString *password = @"Abcde321";
NSString *relationshipId = @"a06b085bea0843446b52c525ab1a84ed";
NSString *email = @"email@email.com";

@interface AFVDViewController ()

@end

@implementation AFVDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //User
//    //Already created both users and will fail saying user already exists so there is no point in calling this
//    //as it works :)
//    [self createUser];
    [self loginUser];
//    [self checkIfUsernameIsAvailable];
//    [self updateUser];
    [self fetchUserModel];
//
//    //Videos
//    [self fetchRelationshipModel];
//    [self fetchVideoModel];
//    [self createVideo];

    //Relationship
//    [self createRelationship];
//    [self fetchRelationshipModelIds];
//    [self fetchRelationshipModelFromId];

}

- (void)createUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDCreateUser");
    
    NSData *testProfileImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"face.jpg"], 1) ;
    
    [modelFactory createUserWithUsername:userName password:password displayName:displayName email:email profileImage:testProfileImageData completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDCreateUser - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Proceed to user login...");
            [self loginUser];

        } else {
            NSLog(@"Finish AFVDCreateUser - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)checkIfUsernameIsAvailable {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];

    NSLog(@"Start AFVDCheckIfUsernameIsAvailable");
    
    [modelFactory checkIfUsernameIsAvailable:userName completion:^(AFVDBaseNetworkModel *networkCallback, BOOL isUsernameAvailable) {
        
        if(isUsernameAvailable) {
            
            NSLog(@"Finish AFVDCheckIfUsernameIsAvailable - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        } else {
            NSLog(@"Finish AFVDCheckIfUsernameIsAvailable - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)updateUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUpdateUser");
    
    NSData *testProfileImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"face.jpg"], 1) ;
    NSSet *relationshipSet = [NSSet setWithObjects:@"9823y4923r28793y987", @"wiuwe9r83r2oiu3r2362", nil];
    
    [modelFactory updateUserWithUsername:userName accessToken:@"f1c94fd3d933aaf6f78fd1ab6058e10ae973831b9f911d04fcd40a33" displayName:@"New Display Name" email:email profileImage:testProfileImageData relationships:relationshipSet completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUpdateUser - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Proceed to fetch user data...");
            [self fetchUserModel];
            
        } else {
            NSLog(@"Finish AFVDUpdateUser - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
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
            NSLog(@"Proceed to fetch user data...");
            [self fetchUserModel];
        } else {
            NSLog(@"Finish AFVDLogin - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchUserModel {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUserModel");
    
    [modelFactory fetchUserModelWithUserName:userName accessToken:getAccessToken completion:^(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUserModel - Success");
            NSLog(@"%@",userModel.userImageUrl);
            NSString *profileImageURL = userModel.userImageUrl;
            NSTimeInterval timeInterval = 60 * 30; // 30 minutes
            NSDate *date = [[NSDate date] dateByAddingTimeInterval:timeInterval];
            
            UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
            [self.view addSubview:profileImage];
            profileImage.center = self.view.center;

            #warning TODO : Add block support to image handling

            [profileImage setImageWithURL:profileImageURL placeholderImage:nil expiryDate:date willCache:TRUE];
            
            
        } else {
            NSLog(@"Finish AFVDUserModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}


- (void)fetchRelationshipModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSLog(@"Start AFVDVideoRelationshipModel");
    
    [modelFactory fetchVideoRelationshipModelWithUserName:userName relationshipId:relationshipId accessToken:getAccessToken completion:^(AFVDVideoRelationshipModel *videoRelationshipModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoRelationshipModel - Success");
            
        } else {
            NSLog(@"Finish AFVDVideoRelationshipModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchVideoModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSUInteger pageIndex = 1;
    
    NSLog(@"Start AFVDVideoPlaylistModel");
    
    [modelFactory fetchVideoPlaylistModelWithUserName:userName playlistId:playlistId accessToken:getAccessToken pageIndex:pageIndex completion:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoPlaylistModel - Success");
            NSLog(@"AFVDVideoPlaylistModel User - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).userName);
            NSLog(@"AFVDVideoPlaylistModel Video ID - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).videoId);
            NSLog(@"AFVDVideoPlaylistModel Date - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).date);
            
        } else {
            NSLog(@"Finish AFVDVideoPlaylistModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
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

    NSString *date = @"2013-11-17";
    
    [modelFactory postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:getAccessToken videoThumbnail:thumbnailContent completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish VideoCreation - Success");
            
        } else {
            NSLog(@"Finish VideoCreation - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)createRelationship {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];

    NSLog(@"Start RelationshipCreation");

    NSString *startDate = @"2013-11-19";
    NSString *endDate = @"2014-11-19";
    NSArray *users = @[userName, otherUserName];
    
    [modelFactory postRelationshipModelWithUserName:userName accessToken:getAccessToken startDate:startDate endDate:endDate users:users completion:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipCreation - Success");
            
        } else {
            NSLog(@"Finish RelationshipCreation - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchRelationshipModelIds {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];
    
    NSLog(@"Start RelationshipModelIds");
    
    [modelFactory fetchRelationshipModelIdsWithUserName:userName accessToken:getAccessToken completion:^(NSArray *relationshipIds, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipModelIds - Success");
            NSLog(@"Relationship Ids : %@", relationshipIds);
            
        } else {
            NSLog(@"Finish RelationshipModelIds - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    }];
}

- (void)fetchRelationshipModelFromId {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];
    
    NSLog(@"Start RelationshipModelFromId");
    
    [modelFactory fetchRelationshipModelWithUserName:userName accessToken:getAccessToken relationshipId:relationshipId completion:^(AFVDRelationshipModel *relationshipModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipModel - Success");
            NSLog(@"RelationshipModel : %@", relationshipModel);
            
        } else {
            NSLog(@"Finish RelationshipModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
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
