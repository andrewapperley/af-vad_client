//
//  AFVDSignupUserModel.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/18/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDSignupUserModel : NSObject
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email profileImage:(UIImage *)profileImage;
@property(nonatomic, strong, readonly)NSString* username;
@property(nonatomic, strong, readonly)NSString* password;
@property(nonatomic, strong, readonly)NSString* email;
@property(nonatomic, strong, readonly)UIImage* profileImage;
@end
