//
//  AFVDInitialView.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDInitialView.h"

@implementation AFVDInitialView

- (id)initWithFrame:(CGRect)frame andDelegate:(UIViewController <AFVDInitialViewDelegate> *) delegate {
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
    }
    return self;
}

- (void)setupUI {
    [self setupScrollView];
    [self setupCloseArrow];
    [self setupDraggingView];
}

- (void)setupScrollView {
    _formScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _formScrollView.scrollEnabled = NO;
    _formScrollView.showsHorizontalScrollIndicator = _formScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_formScrollView];
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

- (void)setupTitleWithTitle:(NSString *)title {
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAFVDTitleXYBuffer, kAFVDTitleXYBuffer, 0, 0)];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:kAFVDNormalFont size:26];
    
    CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName : titleLabel.font}];
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleSize.width, titleSize.height);
    
    [self addSubview:titleLabel];
    
    CGFloat formViewStartY = titleLabel.frame.size.height + titleLabel.frame.origin.y + kAFVDFormScrollViewYMargin;
    
    _formScrollView.frame = CGRectMake(0, formViewStartY, self.frame.size.width, self.frame.size.height - formViewStartY);
}

#pragma mark - UIPanGestureMethod

- (void)userIsDraggingView:(UIPanGestureRecognizer *)gesture {
    
    BOOL closingView = NO;
    CGPoint translation = [gesture translationInView:self.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        
        [self.delegate panelViewIsDragged:translation closeView:closingView withVelocity:[gesture velocityInView:self.superview].y andSender:self];
        [gesture setTranslation:CGPointZero inView:self.superview];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gesture velocityInView:self.superview];
        closingView = (velocity.y > 0.0f) ? YES : NO;
        [self.delegate panelViewToSnapToPositionWithVelocity:velocity.y andClosePanel:closingView andSender:self];
        
    }
}

#pragma mark - UITextFieldInput Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_formScrollView setContentOffset:CGPointMake(_formScrollView.contentOffset.x, textField.frame.origin.y - textField.frame.size.height) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_formScrollView setContentOffset:CGPointMake(_formScrollView.contentOffset.x, 0) animated:TRUE];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Cleanup

- (void)dealloc {
    _delegate = nil;
}

@end