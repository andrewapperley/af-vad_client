//
//  AFVDBaseNetworkStatics.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/27/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#pragma mark - Class forwards
@class AFVDBaseNetworkModel;

#pragma mark - Network callback block typedefs
typedef void(^AFVDBaseNetworkSuccess)(AFVDBaseNetworkModel *networkCallback);
typedef void(^AFVDBaseNetworkFailure)(NSError *error);

#pragma mark - Network base URL
#ifndef BASE_NETWORK_URL
#define BASE_NETWORK_URL (IS_LOCAL_MACHINE ? @"http://192.168.0.14:5000" : @"http://99.232.33.159:5000")
#endif

#pragma mark - Network date formatting
extern NSString *kAFVDBaseNetworkDefaultDateFormat;
extern NSString *kAFVDBaseNetworkDefaultDateDisplayMonthDayYearFormat;
extern NSString *kAFVDBaseNetworkDefaultDateDisplayHourMinutesFormat;