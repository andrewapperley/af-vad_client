//
//  AFVDIntialViewController.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDIntialViewController.h"
#import "AFVDSigninView.h"
#import "AFVDSignupView.h"

/*Some of these constants might be useful to other views in the future so they could be
 extracted to another staticsFile*/

static NSString* kAFVDLogoImage = @"AFVDLogo";
static NSString* kAFVDSigninImage = @"AFVDSigninButton";
static NSString* kAFVDSigninSelectedImage = @"signinButton_selected";
static NSString* kAFVDSignupSelectedImage = @"signupButton_selected";
static NSString* kAFVDSignupImage = @"AFVDSignupButton";
static NSInteger kAFVDCatchPhraseYBuffer = 20;
static NSInteger kAFVDLogoYBuffer = 53;
static NSInteger kAFVDSignupAndSigninXBuffer = 55;
static NSInteger kAFVDSignupAndSigninYBuffer = 47;
static NSInteger kAFVDSignupAndSigninLabelYBuffer = 11;
static NSInteger kAFVDSlidingPanelHeight_iPhone5 = 317;//450;
static NSInteger kAFVDSlidingPanelHeight = 340;
static CGFloat panelViewAnimationDuration = 0.6f;

@interface AFVDIntialViewController ()
{
    UIImageView* _backgroundImageView;
    UIView* _slidingPanel;
    UIView* _currentPanelView;
    NSInteger _slidingPaneHeight;
    NSInteger _initialSlidingPanelY;
    UIAttachmentBehavior* _panAttachmentBehaviour;
    UIDynamicAnimator* _animator;
    UIGravityBehavior* _gravityBehaviour;
    UIPushBehavior* _pushBehavior;
}
@end

@implementation AFVDIntialViewController

- (id)initWithBackgroundImage:(UIImage *)backgroundImage {
    self = [super init];
    if (self) {
        _slidingPaneHeight = IS_IPHONE5 ? kAFVDSlidingPanelHeight_iPhone5 : kAFVDSlidingPanelHeight;
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
    afvdCatchPhraseLabel.text = NSLocalizedString(@"creating memories, one blip at a time", nil);
    afvdCatchPhraseLabel.font = [UIFont fontWithName:kAFVDNormalFont size:16];
    
    CGFloat labelWidth = [afvdCatchPhraseLabel.text sizeWithAttributes:@{NSFontAttributeName : afvdCatchPhraseLabel.font}].width;
    CGFloat labelHeight = [afvdCatchPhraseLabel.text sizeWithAttributes:@{NSFontAttributeName : afvdCatchPhraseLabel.font}].height;
    
    afvdCatchPhraseLabel.frame = CGRectMake((self.view.frame.size.width - labelWidth)/2, logoView.frame.origin.y + logoView.frame.size.height + kAFVDCatchPhraseYBuffer, labelWidth, labelHeight);
    afvdCatchPhraseLabel.textColor = [UIColor colorWithRed:161/255.0 green:167/255.0 blue:167/255.0 alpha:1];
    
    [_backgroundImageView addSubview:logoView];
    [_backgroundImageView addSubview:afvdCatchPhraseLabel];
    
}

- (void)setupButtons {
    
    /*Signup Button*/
    
    UIImage* signupButtonImage = [UIImage imageNamed:kAFVDSignupImage];
    UIImage* signupButtonImageSelected = [UIImage imageNamed:kAFVDSignupSelectedImage];
    
    UIButton* signupButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFVDSignupAndSigninXBuffer, self.view.frame.size.height - signupButtonImage.size.height - kAFVDSignupAndSigninYBuffer, signupButtonImage.size.width, signupButtonImage.size.height)];
    [signupButton setBackgroundImage:signupButtonImage forState:UIControlStateNormal];
    [signupButton setBackgroundImage:signupButtonImageSelected forState:UIControlStateHighlighted];
    signupButton.tag = 0;
    [signupButton addTarget:self action:@selector(onSigninSignupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* signupLabel = [[UILabel alloc] init];
    signupLabel.text = NSLocalizedString(@"Sign Up", nil);
    signupLabel.font = [UIFont fontWithName:kAFVDNormalFont size:20];
    
    CGFloat labelWidth = [signupLabel.text sizeWithAttributes:@{NSFontAttributeName : signupLabel.font}].width;
    CGFloat labelHeight = [signupLabel.text sizeWithAttributes:@{NSFontAttributeName : signupLabel.font}].height;
    
    signupLabel.frame = CGRectMake(((signupButton.frame.size.width - labelWidth)/2) + signupButton.frame.origin.x, signupButton.frame.origin.y + signupButton.frame.size.height + kAFVDSignupAndSigninLabelYBuffer, labelWidth, labelHeight);
    signupLabel.textColor = [UIColor whiteColor];
    
    /*Signin Button*/
    UIImage* signinButtonImage = [UIImage imageNamed:kAFVDSigninImage];
    UIImage* signinButtonImageSelected = [UIImage imageNamed:kAFVDSigninSelectedImage];
    
    UIButton* signinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - signinButtonImage.size.width - kAFVDSignupAndSigninXBuffer, self.view.frame.size.height - signinButtonImage.size.height - kAFVDSignupAndSigninYBuffer, signinButtonImage.size.width, signinButtonImage.size.height)];
    [signinButton setBackgroundImage:signinButtonImage forState:UIControlStateNormal];
    [signinButton setBackgroundImage:signinButtonImageSelected forState:UIControlStateHighlighted];
    
    signinButton.tag = 1;
    
    [signinButton addTarget:self action:@selector(onSigninSignupButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* signinLabel = [[UILabel alloc] init];
    signinLabel.text = NSLocalizedString(@"Sign In", nil);
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
    
    _slidingPanel = [[UIView alloc] initWithFrame:CGRectZero];
    _slidingPanel.layer.anchorPoint = CGPointMake((self.view.frame.size.width - _slidingPanel.frame.size.width)/2, 0);
    _slidingPanel.frame = CGRectMake(0, _backgroundImageView.frame.size.height, _backgroundImageView.frame.size.width, _backgroundImageView.frame.size.height);
    [self.view addSubview:_slidingPanel];
}

#pragma mark - Button Methods

- (void)onSigninSignupButton:(UIControl *)sender {
    
    self.view.userInteractionEnabled = FALSE;
    _currentPanelView = nil;
    
    switch (sender.tag) {
        case AFVDInitialViewOption_Signup:
            [self setPanelHeightAndBlur:_slidingPaneHeight];
            _currentPanelView = [[AFVDSignupView alloc] initWithFrame:CGRectMake(0, 0, _slidingPanel.frame.size.width, _slidingPanel.frame.size.height) andDelegate:self];
        break;
        case AFVDInitialViewOption_Signin:
            [self setPanelHeightAndBlur:_slidingPaneHeight];
            _currentPanelView = [[AFVDSigninView alloc] initWithFrame:CGRectMake(0, 0, _slidingPanel.frame.size.width, _slidingPanel.frame.size.height) andDelegate:self];
        break;
    }
}

#pragma mark - AFVDInitialViewDelegate Methods

- (void)panelViewIsReady:(UIView *)panel {
    [_slidingPanel addSubview:panel];
    
    [UIView animateWithDuration:panelViewAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear animations:^{
        _slidingPanel.frame = CGRectMake(0, (self.view.frame.size.height - _slidingPaneHeight),  _slidingPanel.frame.size.width,  _slidingPaneHeight);
    } completion:^(BOOL finished) {
        _initialSlidingPanelY = _slidingPanel.frame.origin.y;
        self.view.userInteractionEnabled = TRUE;
    }];
    
}

- (void)panelViewIsDragged:(CGPoint)panelsPoint closeView:(BOOL)closeView withVelocity:(NSInteger)velocity {
    [_slidingPanel setCenter:CGPointMake([_slidingPanel center].x, MAX(_initialSlidingPanelY, [_slidingPanel center].y + panelsPoint.y))];
}

- (void)snapPanelToPositionWithVelocity:(NSInteger)velocity andClosePanel:(BOOL)closePanel {
    CGFloat snapPanelAnimationSpeed = 0;
    
    if (velocity <= -50 || velocity >= 50) {
        snapPanelAnimationSpeed = 0.3f;
    } else if (velocity <= -10 || velocity >= 10) {
        snapPanelAnimationSpeed = 0.4f;
    }
    
    [UIView animateWithDuration:snapPanelAnimationSpeed delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear animations:^{
        [_slidingPanel setCenter:CGPointMake([_slidingPanel center].x, MAX(_initialSlidingPanelY, ((closePanel) ? self.view.frame.size.height : _initialSlidingPanelY)))];
    } completion:nil];
    
    if (closePanel) {
        [self closeSlidingPanel];
    }
}

- (void)closeSlidingPanel {
    
}

#pragma mark - Blurring Panel

/*Improve the performance here*/
- (void)setPanelHeightAndBlur:(CGFloat)panelHeight {
    
    for (UIView* v in _slidingPanel.subviews) {
        [v removeFromSuperview];
    }
    
    _slidingPanel.frame = CGRectMake(0, _backgroundImageView.frame.size.height, _backgroundImageView.frame.size.width, panelHeight);
    
    UIImageView* temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _slidingPanel.frame.size.width, _slidingPanel.frame.size.height)];
    
    UIGraphicsBeginImageContext(CGSizeMake(temp.frame.size.width, _backgroundImageView.frame.size.height));
    
    [_backgroundImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef cgImage = tempImage.CGImage;
    CGFloat width = CGImageGetWidth(cgImage);
    CGFloat height = CGImageGetHeight(cgImage);
    CGRect rect = CGRectMake(0, height - panelHeight, width, panelHeight);
    
    CGImageRef cgSubImage = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:cgSubImage];
    tempImage = subImage;
    CGImageRelease(cgSubImage);
    tempImage = [tempImage applyAFVDBlur];
    
    temp.image = tempImage;
    UIGraphicsEndImageContext();
    temp.alpha = 0.98f;
    
    [_slidingPanel addSubview:temp];
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
