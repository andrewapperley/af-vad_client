//
//  AFVDSignupUserModel.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSignupUserModel.h"

@implementation AFVDSignupUserModel
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email profileImage:(UIImage *)profileImage {
    if (self = [super init]) {
        _username       = username;
        _password       = password;
        _email          = email;
        _profileImage   = profileImage;
    }
    return self;
}
@end
