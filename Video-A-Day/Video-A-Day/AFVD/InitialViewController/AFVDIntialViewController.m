//
//  AFVDIntialViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDIntialViewController.h"
#import "AFVDUserModelFactory.h"
#import "AFVDSigninUserModel.h"
#import "AFVDSignupUserModel.h"
#import "AFVDKeychain.h"

@interface AFVDIntialViewController ()
{
    UIImageView* _backgroundImageView;
    UIView* _slidingPanel;
    AFVDInitialView* _currentPanelView;
    NSInteger _slidingPaneHeight;
    NSInteger _initialSlidingPanelY;
}
@end

@implementation AFVDIntialViewController

- (id)initWithBackgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    if (self) {
        
        _slidingPaneHeight = kAFVDSlidingPanelHeight;
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        _backgroundImageView.userInteractionEnabled = FALSE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:_backgroundImageView];
    
    [self setupLogo];
    [self setupButtons];
    [self setupSlidingPanel];
}

#pragma mark - UI Setup

- (void)setupLogo {
    UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kAFVDLogoImage]];
    logoView.frame = CGRectMake((self.view.frame.size.width - logoView.frame.size.width)/2, kAFVDLogoYBuffer, logoView.frame.size.width, logoView.frame.size.height);
    logoView.userInteractionEnabled = FALSE;
    
    UILabel* afvdCatchPhraseLabel = [[UILabel alloc] init];
    afvdCatchPhraseLabel.text = NSLocalizedString(@"AFVDInitialViewCreating", nil);
    afvdCatchPhraseLabel.font = [UIFont fontWithName:kAFVDNormalFont size:16];
    
    CGFloat labelWidth = [afvdCatchPhraseLabel.text sizeWithAttributes:@{NSFontAttributeName : afvdCatchPhraseLabel.font}].width;
    CGFloat labelHeight = [afvdCatchPhraseLabel.text sizeWithAttributes:@{NSFontAttributeName : afvdCatchPhraseLabel.font}].height;
    
    afvdCatchPhraseLabel.frame = CGRectMake((self.view.frame.size.width - labelWidth)/2, logoView.frame.origin.y + logoView.frame.size.height + kAFVDCatchPhraseYBuffer, labelWidth, labelHeight);
    afvdCatchPhraseLabel.textColor = UIColorFromRGBA(161, 167, 167, 1);
    
    [_backgroundImageView addSubview:logoView];
    [_backgroundImageView addSubview:afvdCatchPhraseLabel];
    
}

- (void)setupButtons {
    
    /*Signup Button*/
    
    UIImage* signupButtonImage = [UIImage imageNamed:kAFVDSignupImage];
    UIImage* signupButtonImageSelected = nil;//[UIImage imageNamed:kAFVDSignupSelectedImage];
    
    UIButton* signupButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFVDSignupAndSigninXBuffer, self.view.frame.size.height - signupButtonImage.size.height - kAFVDSignupAndSigninYBuffer, signupButtonImage.size.width, signupButtonImage.size.height)];
    [signupButton setBackgroundImage:signupButtonImage forState:UIControlStateNormal];
    [signupButton setBackgroundImage:signupButtonImageSelected forState:UIControlStateHighlighted];
    signupButton.tag = 0;
    [signupButton addTarget:self action:@selector(onSigninSignupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* signupLabel = [[UILabel alloc] init];
    signupLabel.text = NSLocalizedString(@"AFVDInitialViewSignUp", nil);
    signupLabel.font = [UIFont fontWithName:kAFVDNormalFont size:kAFVDPanelSignupLabelFontSize];
    
    CGFloat labelWidth = [signupLabel.text sizeWithAttributes:@{NSFontAttributeName : signupLabel.font}].width;
    CGFloat labelHeight = [signupLabel.text sizeWithAttributes:@{NSFontAttributeName : signupLabel.font}].height;
    
    signupLabel.frame = CGRectMake(((signupButton.frame.size.width - labelWidth)/2) + signupButton.frame.origin.x, signupButton.frame.origin.y + signupButton.frame.size.height + kAFVDSignupAndSigninLabelYBuffer, labelWidth, labelHeight);
    signupLabel.textColor = [UIColor whiteColor];
    
    /*Signin Button*/
    UIImage* signinButtonImage = [UIImage imageNamed:kAFVDSigninImage];
    UIImage* signinButtonImageSelected = nil;//[UIImage imageNamed:kAFVDSigninSelectedImage];
    
    UIButton* signinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - signinButtonImage.size.width - kAFVDSignupAndSigninXBuffer, self.view.frame.size.height - signinButtonImage.size.height - kAFVDSignupAndSigninYBuffer, signinButtonImage.size.width, signinButtonImage.size.height)];
    [signinButton setBackgroundImage:signinButtonImage forState:UIControlStateNormal];
    [signinButton setBackgroundImage:signinButtonImageSelected forState:UIControlStateHighlighted];
    
    signinButton.tag = 1;
    
    [signinButton addTarget:self action:@selector(onSigninSignupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* signinLabel = [[UILabel alloc] init];
    signinLabel.text = NSLocalizedString(@"AFVDInitialViewSignIn", nil);
    signinLabel.font = [UIFont fontWithName:kAFVDNormalFont size:20];
    
    labelWidth = [signinLabel.text sizeWithAttributes:@{NSFontAttributeName : signinLabel.font}].width;
    labelHeight = [signinLabel.text sizeWithAttributes:@{NSFontAttributeName : signinLabel.font}].height;
    
    signinLabel.frame = CGRectMake(((signinButton.frame.size.width - labelWidth)/2) + signinButton.frame.origin.x, signinButton.frame.origin.y + signinButton.frame.size.height + kAFVDSignupAndSigninLabelYBuffer, labelWidth, labelHeight);
    signinLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:signupButton];
    [self.view addSubview:signupLabel];
    [self.view addSubview:signinButton];
    [self.view addSubview:signinLabel];
}

- (void)setupSlidingPanel {
    
    _slidingPanel = [[UIView alloc] init];
    _slidingPanel.layer.anchorPoint = CGPointMake((self.view.frame.size.width - _slidingPanel.frame.size.width)/2, 0);
    _slidingPanel.frame = CGRectMake(0, _backgroundImageView.frame.size.height, _backgroundImageView.frame.size.width, _backgroundImageView.frame.size.height);
    [self.view addSubview:_slidingPanel];
}

#pragma mark - Button Methods

- (void)onSigninSignupButton:(UIControl *)sender {
    
    self.view.userInteractionEnabled = FALSE;
    _currentPanelView = nil;
    [self setPanelHeightAndBlur:_slidingPaneHeight];
    CGRect panelFrame = CGRectMake(0, 0, _slidingPanel.frame.size.width, _slidingPanel.frame.size.height);
    
    switch (sender.tag) {
        case AFVDInitialViewOption_Signup:
            _currentPanelView = [[AFVDSignupView alloc] initWithFrame:panelFrame andDelegate:self];
            ((AFVDSignupView *)_currentPanelView).signupDelegate = self;
        break;
        case AFVDInitialViewOption_Signin:
            _currentPanelView = [[AFVDSigninView alloc] initWithFrame:panelFrame andDelegate:self];
            ((AFVDSigninView *)_currentPanelView).signinDelegate = self;
        break;
    }
    
}

#pragma mark - AFVDInitialViewDelegate Methods

- (void)panelViewIsReady:(UIView *)panel andSender:(AFVDInitialView *__weak)sender {
    [_slidingPanel addSubview:panel];
    
    [UIView animateWithDuration:kPanelViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear animations:^{
        _slidingPanel.frame = CGRectMake(0, (self.view.frame.size.height - _slidingPaneHeight),  _slidingPanel.frame.size.width,  _slidingPaneHeight);
    } completion:^(BOOL finished) {
        _initialSlidingPanelY = _slidingPanel.frame.origin.y;
        self.view.userInteractionEnabled = TRUE;
    }];
    
}

- (void)panelViewIsDragged:(CGPoint)panelsPoint closeView:(BOOL)closeView withVelocity:(CGFloat)velocity andSender:(AFVDInitialView *__weak)sender {
    [_slidingPanel setCenter:CGPointMake([_slidingPanel center].x, MAX(_initialSlidingPanelY, [_slidingPanel center].y + panelsPoint.y))];
}

- (void)panelViewToSnapToPositionWithVelocity:(NSInteger)velocity andClosePanel:(BOOL)closePanel andSender:(AFVDInitialView *__weak)sender {
    CGFloat snapPanelAnimationSpeed = 0;
    
    if (velocity <= -kAFVDSnapPanelVelocityHighThreshold || velocity >= kAFVDSnapPanelVelocityHighThreshold) {
        snapPanelAnimationSpeed = kAFVDSnapPanelAnimationSlowSpeed;
    } else if (velocity <= -kAFVDSnapPanelVelocityLowThreshold || velocity >= kAFVDSnapPanelVelocityLowThreshold) {
        snapPanelAnimationSpeed = kAFVDSnapPanelAnimationSpeed;
    }
    
    [UIView animateWithDuration:snapPanelAnimationSpeed delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear animations:^{
        [_slidingPanel setCenter:CGPointMake([_slidingPanel center].x, MAX(_initialSlidingPanelY, ((closePanel) ? self.view.frame.size.height : _initialSlidingPanelY)))];
    } completion:^(BOOL finished) {
        if (closePanel) {
            [self closeSlidingPanel];
        }
    }];
}

- (void)closeSlidingPanel {
    for (UIView* v in _slidingPanel.subviews) {
        [v removeFromSuperview];
    }
    _currentPanelView = nil;
}

#pragma mark - AFVDSigninDelegate Method

- (void)signUserInWithModel:(AFVDSigninUserModel *)model {
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    [modelFactory fetchUserModelAndAccessTokenWithUserName:model.username andPassword:model.password accessToken:model.accessToken success:^(AFVDUserModel *userModel, NSString *accessToken, AFVDBaseNetworkModel *networkCallback) {
            /*Go to Timeline VC, do this when you integrate the Timeline*/
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AFVDSigninForFailureTitle", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"AFVDSigninForFailureButtonTitle", nil) otherButtonTitles:nil, nil] show];
    }];
}

#pragma mark - AFVDSignupDelegate Methods

- (BOOL)validInput:(NSString *)input forType:(AFVDSignupFormItemTypes)type {
    
    input = [input stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    switch (type) {
        case AFVDSignupFormItem_Username:
            if (input.length >= 3) {
#warning /*Do username check call here*/
                return YES;
            }
            break;
        case AFVDSignupFormItem_Email:
            if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"] evaluateWithObject:input]) {
                return YES;
            }
            break;
        case AFVDSignupFormItem_Password:
        case AFVDSignupFormItem_RePassword: {
            NSArray* passwords = [input componentsSeparatedByString:@"/*&*/"];
            if (passwords.count == 2) {
                if ([(NSString *)passwords.firstObject isEqualToString:(NSString *)passwords.lastObject]) {
                    return YES;
                }
            }
            break;
        }
    }
    return NO;
}

- (void)signUserUpWithModel:(AFVDSignupUserModel *)model {
    AFVDUserModelFactory *modelFactory = [[AFVDUserModelFactory alloc] init];
    
    NSData *profileImageData = UIImageJPEGRepresentation(model.profileImage, 1) ;
    
    [modelFactory createUserWithUsername:model.username password:model.password displayName:model.username email:model.email profileImage:profileImageData success:^(AFVDBaseNetworkModel *networkCallback) {
        
        if(networkCallback.success) {
            
            [self panelViewToSnapToPositionWithVelocity:50 andClosePanel:YES andSender:_currentPanelView];
            
        } else {

        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Blurring Panel

/*Improve the performance here*/
- (void)setPanelHeightAndBlur:(CGFloat)panelHeight {
    
    for (UIView* v in _slidingPanel.subviews) {
        [v removeFromSuperview];
    }
    
    _slidingPanel.frame = CGRectMake(0, _backgroundImageView.frame.size.height, _backgroundImageView.frame.size.width, panelHeight);
    
    UIImageView* temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _slidingPanel.frame.size.width, _slidingPanel.frame.size.height)];
    
    temp.image = [[UIImage imageScreenshotFromView:_backgroundImageView size:_slidingPanel.frame.size offset:CGSizeMake(0, panelHeight) newHeight:panelHeight] applyAFVDBlur];
    temp.alpha = kAFVDSlidingPanelAlpha;
    
    [_slidingPanel addSubview:temp];
//    _slidingPanel.backgroundColor = [UIColor whiteColor];
//    _slidingPanel.alpha = 0.9f;
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
