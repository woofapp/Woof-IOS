//
//  ImageUtility.h
//  Woof
//
//  Created by Mattia Campana on 03/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>

static float const LANDSCAPE_HEIGHT = 360;
static float const LANDSCAPE_WIDTH = 640;
static float const PORTRAIT_HEIGHT = 640;
static float const PORTRATI_WIDTH = 360;

@interface ImageUtility : NSObject

+(UIImage *) resizeImage: (UIImage *)image;
+(NSString *) compressAndEncodeImage: (UIImage *)image;
+(UIImage *) decodeBase64Image: (NSString *)b64Image;

@end
