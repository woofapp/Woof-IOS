//
//  ImageUtility.m
//  Woof
//
//  Created by Mattia Campana on 03/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "ImageUtility.h"
#import "Base64.h"

@implementation ImageUtility

+(UIImage *) resizeImage: (UIImage *)image{
    
    CGSize newSize;
    
    if(image.size.width > image.size.height) newSize = CGSizeMake(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT);
    else newSize = CGSizeMake(PORTRATI_WIDTH, PORTRAIT_HEIGHT);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString *)compressAndEncodeImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    
    [Base64 initialize];
    return [Base64 encode:data];
}

+(UIImage *)decodeBase64Image:(NSString *)b64Image{
    [Base64 initialize];
    
    NSData* data = [Base64 decode:b64Image];
    
    return [UIImage imageWithData:data];
}

@end
