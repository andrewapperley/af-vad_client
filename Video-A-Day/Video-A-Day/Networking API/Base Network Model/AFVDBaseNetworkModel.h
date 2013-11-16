//
//  AFVDBaseNetworkModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/16/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDBaseNetworkModel : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic) NSUInteger responseCode;
@property (nonatomic, strong, readonly) NSString *responseMessage;
@property (nonatomic, strong, readonly) NSDictionary *responseData;

@end
