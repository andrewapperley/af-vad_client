//
//  AFVDSigninView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSigninView.h"
#import "AFVDSigninUserModel.h"

@interface AFVDSigninView() {
    NSString* _username;
    NSString* _password;
    UIButton* _submitButton;
}

@end

@implementation AFVDSigninView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    self = [super initWithFrame:frame andDelegate:delegate];
    if (self) {
        
        [self setupUI];
        [self.delegate panelViewIsReady:self andSender:self];
    }
    return self;
}

#pragma mark - UI Setup Methods

- (void)setupUI {
    [super setupUI];
    [self setupTitleWithTitle:NSLocalizedString(@"AFVDInitialViewSignIn", nil)];
    [self setupForm];
}

- (void)setupForm {
    
    /*Create Submit Button*/
    NSInteger submitButtonHeight = 32;
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFVDFormItemXBuffer, _formScrollView.frame.size.height - (submitButtonHeight + kAFVDFormItemXBuffer) - kAFVDSubmitButtonBottomMargin, self.frame.size.width - kAFVDFormItemXBuffer*2, submitButtonHeight)];
    [_submitButton addTarget:self action:@selector(onSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.borderWidth = 2;
    _submitButton.layer.borderColor = UIColorFromRGBA(101, 101, 90, 1).CGColor;
    _submitButton.layer.cornerRadius = 5;
    
    [_submitButton setTitle:NSLocalizedString(@"AFVDSignupFormSubmitButton", nil) forState:UIControlStateNormal];
    
    [_formScrollView addSubview:_submitButton];
    _submitButton.enabled = NO;
    /*Create username/password textviews*/
    
    NSArray* formItems = @[NSLocalizedString(@"AFVDSignupFormUsername", nil), NSLocalizedString(@"AFVDSignupFormPassword", nil)];
    NSInteger itemNumber = 2;
    
    for (NSUInteger i = 0; i < formItems.count; i++) {
        /*Create the Label*/
        UILabel* formItemLabel = [[UILabel alloc] init];
        formItemLabel.text = formItems[i];
        formItemLabel.font = [UIFont fontWithName:kAFVDNormalFont size:11];
        
        CGSize formLabelSize = [formItemLabel.text sizeWithAttributes:@{NSFontAttributeName : formItemLabel.font}];
        
        formItemLabel.frame = CGRectMake(kAFVDFormItemXBuffer*1.25, _formScrollView.frame.size.height - ((formLabelSize.height + kAFVDSigninFormItemYBuffer*2)*itemNumber + _submitButton.frame.size.height + kAFVDSigninFormItemYBuffer), formLabelSize.width, formLabelSize.height);
        
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
        
        if (i == AFVDSigninFormItem_Password) {
            textField.secureTextEntry = TRUE;
        }
        
        [_formScrollView addSubview:formItemLabel];
        [_formScrollView addSubview:textField];
        
        itemNumber--;
        if (itemNumber == 0) {
            itemNumber = 2;
        }
        
    }
}

#pragma mark - UITextViewDelegate Method

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case AFVDSigninFormItem_Username:
            _username = textField.text;
            break;
            
        case AFVDSigninFormItem_Password:
            _password = textField.text;
            break;
    }
    _submitButton.enabled = (_username && _password);
}

#pragma mark - onSubmitButton Method

- (void)onSubmitButton {
    AFVDSigninUserModel* model = [[AFVDSigninUserModel alloc] initWithUsername:_username password:_password];
    if ([_signinDelegate respondsToSelector:@selector(signUserInWithModel:)]) {
        [_signinDelegate signUserInWithModel:model];
    }
}

#pragma mark - Cleanup

- (void)dealloc {
    _signinDelegate = nil;
}

@end