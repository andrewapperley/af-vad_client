//
//  AFVDSigninUserModel.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/23/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDSigninUserModel : NSObject

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

- (instancetype)initWithUsername:(NSString *)username accessToken:(NSString *)token;

@property(nonatomic, strong, readonly)NSString* username;

@property(nonatomic, strong, readonly)NSString* password;

@property(nonatomic, strong, readonly)NSString* accessToken;

@end