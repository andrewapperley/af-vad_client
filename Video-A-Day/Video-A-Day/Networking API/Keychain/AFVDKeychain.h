//
//  AFVDKeychain.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 12/1/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDKeychain : NSObject

@property (nonatomic, strong) NSString *accessToken;

#pragma mark - Saving
- (void)save;

#pragma mark - Singleton
+ (instancetype)keychain;

@end
