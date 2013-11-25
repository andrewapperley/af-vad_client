//
//  AFVDUrlHasher.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/21/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDUrlHasher : NSObject

+ (NSString *)createSecureURLForResource:(NSString *)resource;

@end