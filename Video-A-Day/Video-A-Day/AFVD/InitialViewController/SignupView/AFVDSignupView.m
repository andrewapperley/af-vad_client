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
    titleLabel.text = NSLocalizedString(@"Sign Up", nil);
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
    NSInteger profileImageSelectorYMargin   = 0;
    UIImage*  profileImageSelectorImage     = [UIImage imageNamed:@"AFVDProfileImageSelector"];
    
    
    UIButton* profileImageSelector = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - profileImageSelectorSize)/2, profileImageSelectorYMargin, profileImageSelectorSize, profileImageSelectorSize)];
    [profileImageSelector setImage:profileImageSelectorImage forState:UIControlStateNormal];
    
    [formScrollView addSubview:profileImageSelector];
    
    /*Create form items*/
    NSArray* formItems = @[NSLocalizedString(@"Username", nil), NSLocalizedString(@"Email", nil) , NSLocalizedString(@"Password", nil), NSLocalizedString(@"Confirm Password", nil)];
    NSInteger currentPage = 0;
    NSInteger itemNumber = 2;
    NSInteger totalPages = 3;
    
    for (NSUInteger i = 0; i < formItems.count; i++) {
        /*Create the Label*/
        UILabel* formItemLabel = [[UILabel alloc] init];
        formItemLabel.text = formItems[i];
        formItemLabel.font = [UIFont fontWithName:kAFVDNormalFont size:11];
        
        CGSize formLabelSize = [formItemLabel.text sizeWithAttributes:@{NSFontAttributeName : formItemLabel.font}];
        
        formItemLabel.frame = CGRectMake((self.frame.size.width*currentPage) + kAFVDFormItemXBuffer*1.25, formScrollView.frame.size.height - (formLabelSize.height  + kAFVDFormItemXBuffer*2)*itemNumber, formLabelSize.width, formLabelSize.height);
        
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

#pragma mark - UITextFieldInput Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [formScrollView setContentOffset:CGPointMake(formScrollView.contentOffset.x, textField.frame.origin.y + 2) animated:YES];
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
        case 3:
            
            break;
    }
    
    if (goToNewPage) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [formScrollView setContentOffset:CGPointMake(self.frame.size.width*(currentFormPage-1), 0) animated:YES];
        });
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [formScrollView setContentOffset:CGPointMake(formScrollView.contentOffset.x, 0) animated:TRUE];
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Cleanup

- (void)dealloc {
    _signupDelegate = nil;
}

@end