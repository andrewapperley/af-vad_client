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
#import "AFVDUrlHasher.h"
#import "AFVDKeychain.h"
#import "AFVDUserModelFactory.h"
#import "AFVDVideoModelFactory.h"
#import "AFVDRelationshipModelFactory.h"
#import "AFVideoCaptureController.h"

NSString *userName = @"andrewApperley123";
NSString *displayName = @"a_apperley";
NSString *otherUserName = @"andrewApperley12345";
NSString *playlistId = @"d65cab706962faf9396aa94e4193ddb9";
NSString *password = @"Abcde321";
NSString *relationshipId = @"97fb98a484426f662c389bc9f686a1ee";
NSString *email = @"email@email.com";

@interface AFVDViewController ()
{
    AFVideoCaptureController *vc;
}
@end

@implementation AFVDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //User
    //    [self createUser];
    //    [self fetchUserModel];
//#warning TEST     [self deactivateUser];
//    //    [self updateUser];
//    //    [self checkIfUsernameIsAvailable];
//    //    [self loginUser];
//    //    [self logoutUser];
//#warning TEST    [self updateToken];
//    //
//    //    //Relationship
//    //    [self createRelationship];
//    //    [self fetchRelationshipModels];
//    //    [self fetchRelationshipModelFromId];
//    //
//    //    //Videos
//    //    [self createVideo];
//#warning TEST    [self fetchVideoModelsAtPageIndex];
//#warning TEST    [self fetchFavouriteVideoModelsAtPageIndex];
//#warning TEST    [self setUserFavouritedVideo];
//#warning TEST    [self unsetUserFavouritedVideo];
//    [self fetchVideoModel];
    //    [self fetchVideoModel];
//    vc = [AFVideoCaptureController captureControllerWithDefaults];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
}

- (void)createUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDCreateUser");
    
    NSData *testProfileImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"face.jpg"], 1) ;
    
    [modelFactory createUserWithUsername:userName password:password displayName:displayName email:email profileImage:testProfileImageData success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDCreateUser - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Proceed to user login...");
            [self loginUser];
            
        } else {
            NSLog(@"Finish AFVDCreateUser - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDCreateUser - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)updateToken {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start UpdateToken");
        
    [modelFactory fetchUserUpdateTokenWithUsername:userName accessToken:[self accessToken] success:^(NSString *accessToken, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish UpdateToken - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Access token : %@", accessToken);
            
        } else {
            NSLog(@"Finish UpdateToken - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"Finish UpdateToken - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchVideoModelsAtPageIndex {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSLog(@"Start AFVDFetchModelsAtIndex");
    
    NSUInteger pageIndex = 0;
    [modelFactory videosAtPageIndex:pageIndex userName:userName accessToken:[self accessToken] success:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDFetchModelsAtIndex - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Count : %d\nModels - %@", videoPlaylistModel.totalNumberOfPages, videoPlaylistModel.videos);
        } else {
            NSLog(@"Finish AFVDFetchModelsAtIndex - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDFetchModelsAtIndex - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchFavouriteVideoModelsAtPageIndex {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSLog(@"Start AFVDFetchFavouriteVideos");
    
    NSUInteger pageIndex = 0;
    [modelFactory favouriteVideosAtPageIndex:pageIndex userName:userName accessToken:[self accessToken] success:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDFetchFavouriteVideos - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Count : %d\nModels - %@", videoPlaylistModel.totalNumberOfPages, videoPlaylistModel.videos);
        } else {
            NSLog(@"Finish AFVDFetchFavouriteVideos - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDFetchFavouriteVideos - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)setUserFavouritedVideo {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSLog(@"Start AFVDSetFavouriteVideo");
    
    NSString *videoId = @"652634546253546";
    NSDate *date = [NSDate date];
    
    [modelFactory setFavouriteVideoWithUserName:userName accessToken:[self accessToken] videoId:videoId favouritedDate:date success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDSetFavouriteVideo - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        } else {
            NSLog(@"Finish AFVDSetFavouriteVideo - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDSetFavouriteVideo - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)unsetUserFavouritedVideo {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];

    NSLog(@"Start AFVDRemoveFavouriteVideo");
    
    NSString *videoId = @"652634546253546";
    
    [modelFactory removeFavouriteVideoWithUserName:userName accessToken:[self accessToken] videoId:videoId success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDRemoveFavouriteVideo - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        } else {
            NSLog(@"Finish AFVDRemoveFavouriteVideo - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDRemoveFavouriteVideo - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)checkIfUsernameIsAvailable {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];

    NSLog(@"Start AFVDCheckIfUsernameIsAvailable");
    
    [modelFactory checkIfUsernameIsAvailable:userName success:^(AFVDBaseNetworkModel *networkCallback, BOOL isUsernameAvailable) {
        
        if(isUsernameAvailable) {
            
            NSLog(@"Finish AFVDCheckIfUsernameIsAvailable - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        } else {
            NSLog(@"Finish AFVDCheckIfUsernameIsAvailable - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDCheckIfUsernameIsAvailable - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)updateUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUpdateUser");
    
    NSData *testProfileImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"face.jpg"], 1) ;
    
    [modelFactory updateUserWithUsername:userName accessToken:[self accessToken] displayName:@"Jeremy" email:email profileImage:testProfileImageData success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUpdateUser - Success %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
            NSLog(@"Proceed to fetch user data...");
            [self fetchUserModel];
            
        } else {
            NSLog(@"Finish AFVDUpdateUser - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDUpdateUser - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)loginUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDLogin");
    
    [modelFactory fetchUserModelAndAccessTokenWithUserName:userName andPassword:password accessToken:[self accessToken] success:^(AFVDUserModel *userModel, NSString *accessToken, AFVDBaseNetworkModel *networkCallback) {

        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDLogin - Success");
            NSLog(@"Access Token - %@", accessToken);
            NSLog(@"Proceed to fetch user data...");
            [self fetchUserModel];
        } else {
            NSLog(@"Finish AFVDLogin - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDLogin - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchUserModel {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start AFVDUserModel");
    
    [modelFactory fetchUserModelWithUserName:userName accessToken:[self accessToken] success:^(AFVDUserModel *userModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDUserModel - Success");
            NSLog(@"%@",userModel.userImageUrl);
            NSString *profileImageURL = [AFVDUrlHasher createSecureURLForResource:userModel.userImageUrl];
            
            UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
            [self.view addSubview:profileImage];
            profileImage.center = self.view.center;
            profileImage.alpha = 1;

//            __block UIImageView *weakProfileImage = profileImage;
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:profileImageURL]];
            [profileImage setImageWithURL:[NSURL URLWithString:profileImageURL]];
//            [profileImage setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                
//                [UIView animateWithDuration:0.5f animations:^{
//                   
//                    weakProfileImage.alpha = 1;
//                }];
//                
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                NSLog(@"Failed to load image from URL : %@", request.URL.absoluteString);
//            }];
            
        } else {
            NSLog(@"Finish AFVDUserModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDUserModel - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)logoutUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start Logout user");
    
    [modelFactory fetchLogoutUserWithUsername:userName accessToken:[self accessToken] success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish Logout user - Success");
            [self setAccessToken:nil];
        } else {
            NSLog(@"Finish Logout user - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish Logout user - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)deactivateUser {
    
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSLog(@"Start Deactivate user");
    
    [modelFactory fetchDeactivateUser:userName password:password accessToken:[self accessToken] success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish Deactivate user - Success");
        } else {
            NSLog(@"Finish Deactivate user - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish Deactivate user - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchVideoModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSUInteger pageIndex = 1;
    
    NSLog(@"Start AFVDVideoPlaylistModel");
    
    [modelFactory videosAtPageIndex:pageIndex userName:userName accessToken:[self accessToken] success:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoPlaylistModel - Success");
            NSLog(@"AFVDVideoPlaylistModel User - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).userName);
            NSLog(@"AFVDVideoPlaylistModel Video ID - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).videoId);
            NSLog(@"AFVDVideoPlaylistModel Date - %@", ((AFVDVideoModel *)videoPlaylistModel.videos[0]).date);
            
        } else {
            NSLog(@"Finish AFVDVideoPlaylistModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDVideoPlaylistModel - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)createVideo {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];

    NSLog(@"Start VideoCreation");

    //Video content
//    NSString *testVideoString = @"5646w5e4r62438we9r849df";
    NSData *videoData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"baileys_5sec" ofType:@"mov"]];//[testVideoString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *videoContent = [videoData base64EncodedStringWithOptions:0];

    //Video thumbnail
//    NSString *testThumbnailString = @"5646w5e4r62438we9r849df";
    NSData *thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"face.jpg"], 1) ;

    NSString *thumbnailContent = [thumbnailData base64EncodedStringWithOptions:0];

    NSDate *date = [NSDate date];
    
    NSString *description = @"This is a video!";
    
    [modelFactory postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:[self accessToken] videoThumbnail:thumbnailContent andVideoDescription:description success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish VideoCreation - Success");
            
        } else {
            NSLog(@"Finish VideoCreation - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish VideoCreation - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)createRelationship {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];

    NSLog(@"Start RelationshipCreation");

    NSString *startDate = [[NSDate date] description];//@"2013-11-19";
    NSString *endDate = [[NSDate date] description];//@"2014-11-19";
    NSArray *users = @[userName, otherUserName];
    
    [modelFactory postRelationshipModelWithUserName:userName accessToken:[self accessToken] startDate:startDate endDate:endDate users:users success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipCreation - Success");
            
        } else {
            NSLog(@"Finish RelationshipCreation - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish RelationshipCreation - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchRelationshipModels {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];
    
    NSLog(@"Start RelationshipModels");
    
    [modelFactory fetchRelationshipModelsWithUserName:userName accessToken:[self accessToken] success:^(NSArray *relationshipIds, AFVDBaseNetworkModel *networkCallback) {

        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipModels - Success");
            NSLog(@"Relationship Ids : %@", relationshipIds);
            
        } else {
            NSLog(@"Finish RelationshipModels - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish RelationshipModels - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchRelationshipModelFromId {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];
    
    NSLog(@"Start RelationshipModelFromId");
    
    [modelFactory fetchRelationshipModelWithUserName:userName accessToken:[self accessToken] relationshipId:relationshipId success:^(AFVDRelationshipModel *relationshipModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipModel - Success");
            NSLog(@"RelationshipModel : %@", relationshipModel);
            
        } else {
            NSLog(@"Finish RelationshipModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish RelationshipModel - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

#pragma mark - Token handling
- (void)setAccessToken:(NSString *)accessToken {
    
    [[AFVDKeychain keychain] setAccessToken:accessToken];
}

- (NSString *)accessToken {
    
    return [[AFVDKeychain keychain] accessToken];
}

#warning END TEMP VC


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
