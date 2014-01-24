//
//  AFVDSigninView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/7/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSigninView.h"
#import "AFVDSigninUserModel.h"

@implementation AFVDSigninView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    self = [super initWithFrame:frame andDelegate:delegate];
    if (self) {
        
        [self setupUI];
        [self.delegate panelViewIsReady:self];
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
    
    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kAFVDFormItemXBuffer, formScrollView.frame.size.height - (submitButtonHeight + kAFVDFormItemXBuffer) - kAFVDSubmitButtonBottomMargin, self.frame.size.width - kAFVDFormItemXBuffer*2, submitButtonHeight)];
    [submitButton addTarget:self action:@selector(onSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    submitButton.layer.borderWidth = 2;
    submitButton.layer.borderColor = [UIColor colorWithRed:101/255.0f green:101/255.0f blue:90/255.0f alpha:1.0f].CGColor;
    submitButton.layer.cornerRadius = 5;
    
    [submitButton setTitle:NSLocalizedString(@"AFVDSignupFormSubmitButton", nil) forState:UIControlStateNormal];
    
    [formScrollView addSubview:submitButton];
    
    /*Create username/password textviews*/
    
    NSArray* formItems = @[NSLocalizedString(@"AFVDSignupFormUsername", nil), NSLocalizedString(@"AFVDSignupFormPassword", nil)];
    NSInteger itemNumber = 2;
    
    for (NSUInteger i = 0; i < formItems.count; i++) {
        /*Create the Label*/
        UILabel* formItemLabel = [[UILabel alloc] init];
        formItemLabel.text = formItems[i];
        formItemLabel.font = [UIFont fontWithName:kAFVDNormalFont size:11];
        
        CGSize formLabelSize = [formItemLabel.text sizeWithAttributes:@{NSFontAttributeName : formItemLabel.font}];
        
        formItemLabel.frame = CGRectMake(kAFVDFormItemXBuffer*1.25, formScrollView.frame.size.height - ((formLabelSize.height + kAFVDSigninFormItemYBuffer*2)*itemNumber + submitButton.frame.size.height + kAFVDSigninFormItemYBuffer), formLabelSize.width, formLabelSize.height);
        
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
        
        if (i == AFVDSigninFormItem_Password) {
            textField.secureTextEntry = TRUE;
        }
        
        [formScrollView addSubview:formItemLabel];
        [formScrollView addSubview:textField];
        
        itemNumber--;
        if (itemNumber == 0) {
            itemNumber = 2;
        }
        
    }
}

#pragma mark - onSubmitButton Method

- (void)onSubmitButton {
    
}

@end