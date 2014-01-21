//
//  AFVDSignupView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSignupView.h"

static NSInteger kAFVDTitleXYBuffer = 25;
static NSInteger kAFVDFormItemXBuffer = 25;
static NSInteger kAFVDFormItemYBuffer = 35;
//static NSInteger kAFVDFormYStart = 203;
//static NSInteger kAFVDFormItemSize = 55;
static NSInteger kAFVDCloseArrowYMargin = 9;
static NSInteger kAFVDFormItemInputYBufferSize = 8;
static NSInteger kAFVDFormScrollViewYMargin = 25;
static NSInteger kAFVDFormTextViewWidth = 262;
static NSInteger kAFVDFormTextViewHeight = 27;
static NSInteger kAFVDDraggingViewHeight = 29;

@implementation AFVDSignupView
{
    NSString* username;
    NSString* displayname;
    NSString* password;
    NSString* repassword;
    NSString* email;
    UIImage* profileImage;
    
    UIButton* profileImageSelector;
    CGFloat profileImageSelectorInitialXMargin;
    UIScrollView* formScrollView;
    NSInteger currentFormPage;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    self = [super initWithFrame:frame andDelegate:delegate];
    if (self) {
        
        [self setupUI];
        currentFormPage = 1;
        [self.delegate panelViewIsReady:self];
    }
    return self;
}

#pragma mark - UI Setup Methods

- (void)setupUI {
    [self setupScrollView];
    [self setupCloseArrow];
    [self setupTitle];
    [self setupForm];
    
    [self setupTermsText];
}

- (void)setupScrollView {
    formScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    formScrollView.scrollEnabled = NO;
    formScrollView.showsHorizontalScrollIndicator = formScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:formScrollView];
}

- (void)setupCloseArrow {
    UIImageView* closeArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AFVDPanelCloseArrow"]];
    closeArrow.frame = CGRectMake((self.frame.size.width - closeArrow.frame.size.width)/2, kAFVDCloseArrowYMargin, closeArrow.frame.size.width, closeArrow.frame.size.height);
    [self addSubview:closeArrow];
    
    [self setupDraggingView];
}

- (void)setupDraggingView {
    UIView* draggingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kAFVDDraggingViewHeight)];
    UIPanGestureRecognizer* draggingGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userIsDraggingView:)];
    draggingGesture.minimumNumberOfTouches = 1;
    draggingGesture.maximumNumberOfTouches = 1;
    [draggingView addGestureRecognizer:draggingGesture];
    
    [self addSubview:draggingView];
}

- (void)setupTitle {
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAFVDTitleXYBuffer, kAFVDTitleXYBuffer, 0, 0)];
    titleLabel.text = NSLocalizedString(@"AFVDInitialViewSignUp", nil);
    titleLabel.font = [UIFont fontWithName:kAFVDNormalFont size:26];
    
    CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}];
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleSize.width, titleSize.height);
    
    [self addSubview:titleLabel];
    
    CGFloat formViewStartY = titleLabel.frame.size.height + titleLabel.frame.origin.y + kAFVDFormScrollViewYMargin;
    
    formScrollView.frame = CGRectMake(0, formViewStartY, self.frame.size.width, self.frame.size.height - formViewStartY);
}

- (void)setupForm {
    
    /*Create ProfileImage Selector*/
    NSInteger profileImageSelectorSize      = 100;
    NSInteger profileImageSelectorYMargin   = 20;
    UIImage*  profileImageSelectorImage     = [UIImage imageNamed:@"AFVDProfileImageSelector"];
    
    
    profileImageSelector = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - profileImageSelectorSize)/2, profileImageSelectorYMargin, profileImageSelectorSize, profileImageSelectorSize)];
    profileImageSelectorInitialXMargin = profileImageSelector.frame.origin.x;
    [profileImageSelector setImage:profileImageSelectorImage forState:UIControlStateNormal];
    profileImageSelector.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self createCircleProfileImage];
    
    [profileImageSelector addTarget:self action:@selector(onProfileImageSelector) forControlEvents:UIControlEventTouchUpInside];
    
    [formScrollView addSubview:profileImageSelector];
    
    /*Create form items*/
    NSArray* formItems = @[NSLocalizedString(@"AFVDSignupFormUsername", nil), NSLocalizedString(@"AFVDSignupFormEmail", nil) , NSLocalizedString(@"AFVDSignupFormPassword", nil), NSLocalizedString(@"AFVDSignupFormConfirmPassword", nil)];
    NSInteger currentPage = 0;
    NSInteger itemNumber = 2;
    NSInteger totalPages = 3;
    
    for (NSUInteger i = 0; i < formItems.count; i++) {
        /*Create the Label*/
        UILabel* formItemLabel = [[UILabel alloc] init];
        formItemLabel.text = formItems[i];
        formItemLabel.font = [UIFont fontWithName:kAFVDNormalFont size:11];
        
        CGSize formLabelSize = [formItemLabel.text sizeWithAttributes:@{NSFontAttributeName : formItemLabel.font}];
        
        formItemLabel.frame = CGRectMake((self.frame.size.width*currentPage) + kAFVDFormItemXBuffer*1.25, formScrollView.frame.size.height - (formLabelSize.height + kAFVDFormItemYBuffer*2)*itemNumber, formLabelSize.width, formLabelSize.height);
        
        /*Create Input Boxes*/
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(formItemLabel.frame.origin.x, formItemLabel.frame.origin.y + formItemLabel.frame.size.height + kAFVDFormItemInputYBufferSize, kAFVDFormTextViewWidth, kAFVDFormTextViewHeight)];
        textField.font = [UIFont fontWithName:kAFVDNormalFont size:12];
        textField.tag = i;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, textField.frame.size.height)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.layer.borderWidth = 1.5;
        textField.layer.borderColor = [UIColor colorWithRed:128/255.0 green:129/255.0 blue:123/255.0 alpha:1].CGColor;
        
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        if(i == AFVDSignupFormItem_Email) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        } else if (i == AFVDSignupFormItem_Password || i == AFVDSignupFormItem_RePassword) {
            textField.secureTextEntry = TRUE;
        }
        
        [formScrollView addSubview:formItemLabel];
        [formScrollView addSubview:textField];
        
        itemNumber--;
        if (itemNumber == 0) {
            itemNumber = 2;
            currentPage++;
        }
        
        if (i == formItems.count-1) {
            formScrollView.contentSize = CGSizeMake(formScrollView.frame.size.width*totalPages, formScrollView.contentSize.height);
        }
    }
    
    /*Create Submit Button*/
    NSInteger submitButtonHeight = 32;
    
    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width*(totalPages-1)) + kAFVDFormItemXBuffer, formScrollView.frame.size.height - (submitButtonHeight + kAFVDFormItemXBuffer), self.frame.size.width - kAFVDFormItemXBuffer*2, submitButtonHeight)];
    [submitButton addTarget:self action:@selector(onSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.borderWidth = 3;
    submitButton.layer.borderColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:90/255.0f alpha:1.0f].CGColor;
    submitButton.layer.cornerRadius = 5;
    
    [submitButton setTitle:NSLocalizedString(@"AFVDSignupFormSubmitButton", nil) forState:UIControlStateNormal];
    
    [formScrollView addSubview:submitButton];
}

- (void)setupTermsText {
    
}

#pragma mark - UIPanGestureMethod

- (void)userIsDraggingView:(UIPanGestureRecognizer *)gesture {
    
    BOOL closingView = NO;
    CGPoint translation = [gesture translationInView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        [self.delegate panelViewIsDragged:translation closeView:closingView withVelocity:0];
        [gesture setTranslation:CGPointZero inView:self.superview];
    
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
    
        CGPoint velocity = [gesture velocityInView:self.superview];
        closingView = (velocity.y > 0.0f) ? YES : NO;
        [self.delegate snapPanelToPositionWithVelocity:velocity.y andClosePanel:closingView];
    
    }
}

#pragma mark - ProfileImageSelector Target Method

- (void)onProfileImageSelector {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info[UIImagePickerControllerEditedImage]) {
        profileImage = [info[UIImagePickerControllerEditedImage] copy];
    } else {
        profileImage = [info[UIImagePickerControllerOriginalImage] copy];
    }
    [profileImageSelector setImage:profileImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCircleProfileImage {
    
    NSInteger radius = profileImageSelector.frame.size.width;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    circle.frame = CGRectMake(0, 0, radius, radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 1;
    
    [profileImageSelector.layer setMask:circle];
}

#pragma mark - Submit Button Target Method

- (void)onSubmitButton {
    AFVDSignupUserModel* signupModel = [[AFVDSignupUserModel alloc] initWithUsername:username password:password email:email profileImage:(!profileImage) ? profileImageSelector.imageView.image : profileImage];
    
    [_signupDelegate signUserUpWithModel:signupModel];
}

#pragma mark - UITextFieldInput Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [formScrollView setContentOffset:CGPointMake(formScrollView.contentOffset.x, textField.frame.origin.y - textField.frame.size.height) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    
    [formScrollView setContentOffset:CGPointMake(formScrollView.contentOffset.x, 0) animated:YES];
    
    BOOL goToNewPage = NO;
    
    switch (currentFormPage) {
        case 1:
            if (textField.tag == AFVDSignupFormItem_Username) {
                username = ([_signupDelegate validInput:textField.text forType:AFVDSignupFormItem_Username]) ? textField.text : @"";
            } else if (textField.tag == AFVDSignupFormItem_Email) {
                email = ([_signupDelegate validInput:textField.text forType:AFVDSignupFormItem_Email]) ? textField.text : @"";
            }
            if (username.length > 0 && email.length > 0) {
                currentFormPage++;
                goToNewPage = YES;
            }
            break;
        case 2:
            if (textField.tag == AFVDSignupFormItem_Password) {
                password = textField.text;
            } else if (textField.tag == AFVDSignupFormItem_RePassword) {
                repassword = textField.text;
            }
            
            if ((password && repassword) && [_signupDelegate validInput:[NSString stringWithFormat:@"%@/*&*/%@",password, repassword] forType:AFVDSignupFormItem_Password]) {
                currentFormPage++;
                goToNewPage = YES;
            }
            break;
    }
    
    if (goToNewPage) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [formScrollView setContentOffset:CGPointMake(self.frame.size.width*(currentFormPage-1), 0) animated:YES];
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                profileImageSelector.alpha = 0;
            } completion:^(BOOL finished) {
                profileImageSelector.frame = CGRectMake((self.frame.size.width*(currentFormPage-1)) + profileImageSelectorInitialXMargin, profileImageSelector.frame.origin.y, profileImageSelector.frame.size.width, profileImageSelector.frame.size.height);
                [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    profileImageSelector.alpha = 1;
                } completion:nil];
            }];
            
        });
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [formScrollView setContentOffset:CGPointMake(formScrollView.contentOffset.x, 0) animated:TRUE];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Cleanup

- (void)dealloc {
    _signupDelegate = nil;
}

@end