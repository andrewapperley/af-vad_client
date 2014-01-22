//
//  AFVDSignupView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSignupView.h"

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
    [super setupUI];
    [self setupTitleWithTitle:NSLocalizedString(@"AFVDInitialViewSignUp", nil)];
    [self setupForm];
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
    
    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width*(totalPages-1)) + kAFVDFormItemXBuffer, formScrollView.frame.size.height - (submitButtonHeight + kAFVDFormItemXBuffer) - kAFVDSubmitButtonBottomMargin, self.frame.size.width - kAFVDFormItemXBuffer*2, submitButtonHeight)];
    [submitButton addTarget:self action:@selector(onSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.borderWidth = 2;
    submitButton.layer.borderColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:90/255.0f alpha:1.0f].CGColor;
    submitButton.layer.cornerRadius = 5;
    
    [submitButton setTitle:NSLocalizedString(@"AFVDSignupFormSubmitButton", nil) forState:UIControlStateNormal];
    
    [formScrollView addSubview:submitButton];
    
    UILabel* termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, submitButton.frame.origin.y + submitButton.frame.size.height + 10, submitButton.frame.size.width, 0)];
#warning Setup clicking on the link to open a new view or webview
    termsLabel.text = NSLocalizedString(@"AFVDSignupFormTerms", nil);
    termsLabel.font = [UIFont fontWithName:kAFVDNormalFont size:10];
    [termsLabel sizeToFit];
    termsLabel.center = CGPointMake(submitButton.center.x, termsLabel.center.y);
    [formScrollView addSubview:termsLabel];
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