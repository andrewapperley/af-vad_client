//
//  AFVDUrlHasher.m
//  Video-A-Day
//
//  Created by Andrew Apperley on 11/21/2013.
//  Copyright (c) 2013 AFApps. All rights reserved.
//

#import "AFVDUrlHasher.h"
#import <CommonCrypto/CommonDigest.h>

#pragma - mark
#pragma - URL config

static NSString *const kAFVDSecretKey = @"2ezTY3isQLK0Ne5fwHyA";
static NSString *const kAFVDUserContentBaseURL = @"http://99.232.33.159";



@implementation AFVDUrlHasher


+ (NSString *)createSecureURLForResource:(NSString *)resource andResourcePath:(NSString *)path {
    
    NSString *hexTime = [AFVDUrlHasher stringToHex:[NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]]];
    
    NSString *token = [AFVDUrlHasher createMD5Hash:[NSString stringWithFormat:@"%@%@.%@",kAFVDSecretKey,resource,hexTime]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@/%@%@",kAFVDUserContentBaseURL, path,token,hexTime,resource];
    
    return url;
}

+ (NSString *)createMD5Hash:(NSString *)lurl
{
    unsigned char digest[16];
    
    CC_MD5([lurl UTF8String], (CC_LONG)strlen([lurl UTF8String]), digest);
    
    NSMutableString *output = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (uint i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    
    return output;
}

+ (NSString *)stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

@end