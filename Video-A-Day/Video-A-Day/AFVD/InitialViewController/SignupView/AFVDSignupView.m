//
//  AFVDSignupView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSignupView.h"
#import "AFVDSignupUserModel.h"

@implementation AFVDSignupView
{
    NSString* _username;
    NSString* _displayname;
    NSString* _password;
    NSString* _repassword;
    NSString* _email;
    UIImage* _profileImage;
    
    UIButton* _profileImageSelector;
    CGFloat _profileImageSelectorInitialXMargin;
    NSInteger _currentFormPage;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    self = [super initWithFrame:frame andDelegate:delegate];
    if (self) {
        
        [self setupUI];
        /*Setting first page var so the form starts at the beginning*/
        _currentFormPage = 1;
        [self.delegate panelViewIsReady:self andSender:self];
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
    
    
    _profileImageSelector = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - profileImageSelectorSize)/2, profileImageSelectorYMargin, profileImageSelectorSize, profileImageSelectorSize)];
    _profileImageSelectorInitialXMargin = _profileImageSelector.frame.origin.x;
    [_profileImageSelector setImage:profileImageSelectorImage forState:UIControlStateNormal];
    _profileImageSelector.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _profileImageSelector.layer.cornerRadius = CGRectGetWidth(_profileImageSelector.bounds) * 0.5f;
    _profileImageSelector.clipsToBounds = YES;
//    [self createCircleProfileImage];
    
    [_profileImageSelector addTarget:self action:@selector(onProfileImageSelector) forControlEvents:UIControlEventTouchUpInside];
    
    [_formScrollView addSubview:_profileImageSelector];
    
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
        
        formItemLabel.frame = CGRectMake((self.frame.size.width*currentPage) + kAFVDFormItemXBuffer*1.25, _formScrollView.frame.size.height - (formLabelSize.height + kAFVDFormItemYBuffer*2)*itemNumber, formLabelSize.width, formLabelSize.height);
        
        /*Create Input Boxes*/
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(formItemLabel.frame.origin.x, formItemLabel.frame.origin.y + formItemLabel.frame.size.height + kAFVDFormItemInputYBufferSize, kAFVDFormTextViewWidth, kAFVDFormTextViewHeight)];
        textField.font = [UIFont fontWithName:kAFVDNormalFont size:12];
        textField.tag = i;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, textField.frame.size.height)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.layer.borderWidth = kAFVDInitialViewTextFieldBorder;
        textField.layer.borderColor = UIColorFromRGBA(128, 129, 123, 1).CGColor;
        
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        if(i == AFVDSignupFormItem_Email) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        } else if (i == AFVDSignupFormItem_Password || i == AFVDSignupFormItem_RePassword) {
            textField.secureTextEntry = TRUE;
        }
        
        [_formScrollView addSubview:formItemLabel];
        [_formScrollView addSubview:textField];
        
        itemNumber--;
        if (itemNumber == 0) {
            itemNumber = 2;
            currentPage++;
        }
        
        if (i == formItems.count-1) {
            _formScrollView.contentSize = CGSizeMake(_formScrollView.frame.size.width*totalPages, _formScrollView.contentSize.height);
        }
    }
    
    /*Create Submit Button*/
    NSInteger submitButtonHeight = 32;
    
    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width*(totalPages-1)) + kAFVDFormItemXBuffer, _formScrollView.frame.size.height - (submitButtonHeight + kAFVDFormItemXBuffer) - kAFVDSubmitButtonBottomMargin, self.frame.size.width - kAFVDFormItemXBuffer*2, submitButtonHeight)];
    [submitButton addTarget:self action:@selector(onSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.borderWidth = 2;
    submitButton.layer.borderColor = UIColorFromRGBA(101, 101, 90, 1).CGColor;
    submitButton.layer.cornerRadius = 5;
    
    [submitButton setTitle:NSLocalizedString(@"AFVDSignupFormSubmitButton", nil) forState:UIControlStateNormal];
    
    [_formScrollView addSubview:submitButton];
    
    UILabel* termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, submitButton.frame.origin.y + submitButton.frame.size.height + 10, submitButton.frame.size.width, 0)];
#warning Setup clicking on the link to open a new view or webview
    termsLabel.text = NSLocalizedString(@"AFVDSignupFormTerms", nil);
    termsLabel.font = [UIFont fontWithName:kAFVDNormalFont size:10];
    [termsLabel sizeToFit];
    termsLabel.center = CGPointMake(submitButton.center.x, termsLabel.center.y);
    [_formScrollView addSubview:termsLabel];
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
        _profileImage = [info[UIImagePickerControllerEditedImage] copy];
    } else {
        _profileImage = [info[UIImagePickerControllerOriginalImage] copy];
    }
    [_profileImageSelector setImage:_profileImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)createCircleProfileImage {
    
//    NSInteger radius = _profileImageSelector.frame.size.width;
//    
//    CAShapeLayer *circle = [CAShapeLayer layer];
//    
//    circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
//    circle.frame = CGRectMake(0, 0, radius, radius);
//    
//    // Configure the apperence of the circle
//    circle.fillColor = [UIColor blackColor].CGColor;
//    circle.lineWidth = 1;
//    
//    [_profileImageSelector.layer setMask:circle];
    _profileImageSelector.layer.cornerRadius = CGRectGetWidth(_profileImageSelector.bounds) * 0.5f;
    _profileImageSelector.clipsToBounds = YES;
}

#pragma mark - Submit Button Target Method

- (void)onSubmitButton {
    AFVDSignupUserModel* signupModel = [[AFVDSignupUserModel alloc] initWithUsername:_username password:_password email:_email profileImage:(!_profileImage) ? _profileImageSelector.imageView.image : _profileImage];
    
    if ([_signupDelegate respondsToSelector:@selector(signUserUpWithModel:)]) {
        [_signupDelegate signUserUpWithModel:signupModel];
    }
    
}

#pragma mark - UITextFieldInput Delegate Methods


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [_formScrollView setContentOffset:CGPointMake(_formScrollView.contentOffset.x, 0) animated:YES];
    BOOL goToNewPage = NO;
    
    switch (_currentFormPage) {
        case 1:
            if (textField.tag == AFVDSignupFormItem_Username) {
                _username = ([_signupDelegate validInput:textField.text forType:AFVDSignupFormItem_Username]) ? textField.text : @"";
            } else if (textField.tag == AFVDSignupFormItem_Email) {
                _email = ([_signupDelegate validInput:textField.text forType:AFVDSignupFormItem_Email]) ? textField.text : @"";
            }
            if (_username.length > 0 && _email.length > 0) {
                _currentFormPage++;
                goToNewPage = YES;
            }
        break;
        case 2:
            if (textField.tag == AFVDSignupFormItem_Password) {
                _password = textField.text;
            } else if (textField.tag == AFVDSignupFormItem_RePassword) {
                _repassword = textField.text;
            }
            
            if ((_password && _repassword) && [_signupDelegate validInput:[NSString stringWithFormat:@"%@/*&*/%@",_password, _repassword] forType:AFVDSignupFormItem_Password]) {
                _currentFormPage++;
                goToNewPage = YES;
            }
        break;
    }
    
    if (goToNewPage) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_formScrollView setContentOffset:CGPointMake(self.frame.size.width*(_currentFormPage-1), 0) animated:YES];
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _profileImageSelector.alpha = 0;
            } completion:^(BOOL finished) {
                _profileImageSelector.frame = CGRectMake((self.frame.size.width*(_currentFormPage-1)) + _profileImageSelectorInitialXMargin, _profileImageSelector.frame.origin.y, _profileImageSelector.frame.size.width, _profileImageSelector.frame.size.height);
                [UIView animateWithDuration:kAFVDSignupNextPageDuration delay:kAFVDSignupNextPageDelay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _profileImageSelector.alpha = 1;
                } completion:nil];
            }];
            
        });
    }
}

#pragma mark - Cleanup

- (void)dealloc {
    _signupDelegate = nil;
}

@end