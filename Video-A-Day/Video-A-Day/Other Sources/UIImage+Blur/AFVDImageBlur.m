//
//  AFVDImageBlur.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 1/10/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import "AFVDImageBlur.h"

@implementation UIImage (AFVDImageBlur)

- (UIImage *)applyAFVDBlur {
    
    NSAssert([self isKindOfClass:[UIImage class]], @"Image must be class type of UIImage");
    
    return [self applyBlurWithRadius:25 tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] saturationDeltaFactor:0.7 maskImage:nil];
}

@end