//
//  Utility.m
//  Woof
//
//  Created by nicola on 01/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation Utility

+(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }

    return ret;
}

@end
