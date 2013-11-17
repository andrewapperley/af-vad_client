//
//  AFVDConstants.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/17/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma - User Section

// Access Token
static NSString * const kAFVDAccessToken = @"userAccessToken";
#define setAccessToken(x) \
                        [[NSUserDefaults standardUserDefaults] setObject:x forKey:kAFVDAccessToken]; \
                                                     [[NSUserDefaults standardUserDefaults] synchronize];

#define getAccessToken ( [[NSUserDefaults standardUserDefaults] objectForKey:kAFVDAccessToken])