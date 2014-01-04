//
//  AFVDVideoFilterController.h
//  Video-A-Day
//
//  Created by Andrew Apperley on 12/18/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import <MessageUI/MessageUI.h>

@interface AFVDVideoFilterController : UIViewController<GPUImageMovieWriterDelegate, MFMailComposeViewControllerDelegate>

- (instancetype)initWithVideoURL:(NSURL *)lvideoURL;

@end