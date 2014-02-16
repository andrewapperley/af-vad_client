//
//  AFVDConstants.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/17/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define IS_IPHONE5 ScreenHeight == 568
#define UIColorFromRGBA($r, $g, $b, $a) ((UIColor *)[UIColor colorWithRed:$r/255.0f green:$g/255.0f blue:$b/255.0f alpha:$a])