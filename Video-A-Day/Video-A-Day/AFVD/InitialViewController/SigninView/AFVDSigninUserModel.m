//
//  AFVDSigninUserModel.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/23/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDSigninUserModel.h"

@implementation AFVDSigninUserModel

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    
    if (self = [super init]) {
        _username       = username;
        _password       = password;
    }
    
    return self;
}

- (instancetype)initWithUsername:(NSString *)username access_token:(NSString *)token {
    
    if (self = [super init]) {
        _username       = username;
        _access_token   = token;
    }
    
    return self;
}

@end