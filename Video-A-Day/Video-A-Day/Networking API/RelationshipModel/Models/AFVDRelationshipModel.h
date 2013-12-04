//
//  AFVDRelationshipModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFVDUserModel;

@interface AFVDRelationshipModel : NSObject

@property (nonatomic, strong, readonly) NSString *relationshipId;
@property (nonatomic, strong, readonly) AFVDUserModel *userOne;
@property (nonatomic, strong, readonly) AFVDUserModel *userTwo;
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;
@property (nonatomic) BOOL finished;

@end
