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
static NSInteger kAFVDFormYStart = 203;
static NSInteger kAFVDFormItemSize = 55;
static NSInteger kAFVDFormItemInputYBufferSize = 8;

@implementation AFVDSignupView
{
    NSString* username;
    NSString* displayname;
    NSString* password;
    NSString* repassword;
    NSString* email;
    UIImage* profileImage;
    
    UIScrollView* formScrollView;
}

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
    [self setupTitle];
    [self setupForm];
    [self setupButtons];
    [self setupTermsText];
}

- (void)setupTitle {
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAFVDTitleXYBuffer, kAFVDTitleXYBuffer, 0, 0)];
    titleLabel.text = NSLocalizedString(@"Sign Up", nil);
    titleLabel.font = [UIFont fontWithName:kAFVDNormalFont size:26];
    
    CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}];
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleSize.width, titleSize.height);
    
    [self addSubview:titleLabel];
}

- (void)setupForm {
    
    NSArray* formItems = @[NSLocalizedString(@"Username", nil), NSLocalizedString(@"Display Name", nil), NSLocalizedString(@"Password", nil), NSLocalizedString(@"Confirm Password", nil), NSLocalizedString(@"Email", nil)];
    
    for (NSUInteger i = 0; i < formItems.count; i++) {
        /*Create the Label*/
        UILabel* formItemLabel = [[UILabel alloc] init];
        formItemLabel.text = formItems[i];
        formItemLabel.font = [UIFont fontWithName:kAFVDNormalFont size:11];
        
        CGSize formLabelSize = [formItemLabel.text sizeWithAttributes:@{NSFontAttributeName : formItemLabel.font}];
        
        formItemLabel.frame = CGRectMake(kAFVDFormItemXBuffer, kAFVDFormYStart + (formLabelSize.height + kAFVDFormItemSize)*i, formLabelSize.width, formLabelSize.height);
        
        /*Create Input Boxes*/
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(formItemLabel.frame.origin.x, formItemLabel.frame.origin.y + formItemLabel.frame.size.height + kAFVDFormItemInputYBufferSize, 262, 27)];
        textField.font = [UIFont fontWithName:kAFVDNormalFont size:14];
        textField.tag = i;
        textField.delegate = self;
        
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 27)];
        textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 27)];
        
        textField.layer.borderWidth = 3;
        textField.layer.borderColor = [UIColor colorWithRed:128/255.0 green:129/255.0 blue:123/255.0 alpha:1].CGColor;
        
        [self addSubview:formItemLabel];
        [self addSubview:textField];
    }
}

- (void)setupButtons {
    
}

- (void)setupTermsText {
    
}

#pragma mark - UITextFieldInput Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField; {
    
}
@end