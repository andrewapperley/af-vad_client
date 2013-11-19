//
//  AFVDRelationshipModel.h
//  Video-A-Day
//
//  Created by Jeremy Fuellert on 11/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFVDRelationshipModel : NSObject

@property (nonatomic, strong, readonly) NSString *relationshipId;
@property (nonatomic, strong, readonly) NSString *startDate;
@property (nonatomic, strong, readonly) NSString *endDate;
@property (nonatomic, strong, readonly) NSArray *playlists;
@property (nonatomic, strong, readonly) NSArray *users;
@property (nonatomic) BOOL shouldHideVideosUntilEndDateIsMet;

@end
