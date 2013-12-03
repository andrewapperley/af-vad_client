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

NSString *userName = @"jfuellert0001";
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
//    [self loginUser];
//    [self checkIfUsernameIsAvailable];
//    [self fetchUserModel];
//    [self updateUser];
//    [self logoutUser];
//
//    //Videos
#warning TODO : Check when server is updated
//    [self fetchRelationshipModel];
//    [self fetchVideoModel];
//    [self createVideo];
//
//    //Relationship
//    [self createRelationship];
//    [self fetchRelationshipModelIds];
//    [self fetchRelationshipModelFromId];
#warning ENDTODO : Check when server is updated
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

- (void)fetchRelationshipModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSLog(@"Start AFVDVideoRelationshipModel");
    
    [modelFactory fetchVideoRelationshipModelWithUserName:userName relationshipId:relationshipId accessToken:[self accessToken] success:^(AFVDVideoRelationshipModel *videoRelationshipModel, AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            NSLog(@"Finish AFVDVideoRelationshipModel - Success");
            
        } else {
            NSLog(@"Finish AFVDVideoRelationshipModel - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish AFVDVideoRelationshipModel - Failure %d - %@", error.code, error.localizedDescription);
    }];
}

- (void)fetchVideoModel {
    
    AFVDVideoModelFactory *modelFactory = [[AFVDVideoModelFactory alloc] init];
    
    NSUInteger pageIndex = 1;
    
    NSLog(@"Start AFVDVideoPlaylistModel");
    
    [modelFactory fetchVideoPlaylistModelWithUserName:userName playlistId:playlistId accessToken:[self accessToken] pageIndex:pageIndex success:^(AFVDVideoPlaylistModel *videoPlaylistModel, AFVDBaseNetworkModel *networkCallback) {
        
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
    NSString *testVideoString = @"5646w5e4r62438we9r849df";
    NSData *videoData = [testVideoString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *videoContent = [videoData base64EncodedStringWithOptions:0];

    //Video thumbnail
    NSString *testThumbnailString = @"5646w5e4r62438we9r849df";
    NSData *thumbnailData = [testThumbnailString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *thumbnailContent = [thumbnailData base64EncodedStringWithOptions:0];

    NSString *date = @"2013-11-17";
    
    [modelFactory postVideoModelWithUserName:userName relationshipId:relationshipId videoContent:videoContent date:date accessToken:[self accessToken] videoThumbnail:thumbnailContent success:^(AFVDBaseNetworkModel *networkCallback) {
        
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

    NSString *startDate = @"2013-11-19";
    NSString *endDate = @"2014-11-19";
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

- (void)fetchRelationshipModelIds {
    
    AFVDRelationshipModelFactory *modelFactory = [[AFVDRelationshipModelFactory alloc] init];
    
    NSLog(@"Start RelationshipModelIds");
    
    [modelFactory fetchRelationshipModelIdsWithUserName:userName accessToken:[self accessToken] success:^(NSArray *relationshipIds, AFVDBaseNetworkModel *networkCallback) {

        if(networkCallback.success) {
            
            NSLog(@"Finish RelationshipModelIds - Success");
            NSLog(@"Relationship Ids : %@", relationshipIds);
            
        } else {
            NSLog(@"Finish RelationshipModelIds - Failure %d - %@", networkCallback.responseCode, networkCallback.responseMessage);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"Finish RelationshipModelIds - Failure %d - %@", error.code, error.localizedDescription);
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
