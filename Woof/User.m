//
//  User.m
//  Woof
//
//  Created by Mattia Campana on 10/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "User.h"
#import "NSDataAdditions.h"

@implementation User

@synthesize idUser;
@synthesize email;
@synthesize password;
@synthesize name;
@synthesize surname;
@synthesize image;
@synthesize city;
@synthesize dogs;
@synthesize token;

-(NSString*)setB64ImageFromUIImage:(UIImage *)img{
   if(img){
		NSData *dataObj = UIImagePNGRepresentation(img);
		self.image = [dataObj base64Encoding];
        
        return self.image;
    }
    
    return nil;
}

-(UIImage *)getImageFromB64String{
    
    UIImage *img = nil;

    if(self.image != nil){
        //NSData *dataObj = [NSData dataWithBase64EncodedString:self.image];
        
        //NSURL *url = [NSURL URLWithString:self.image];
        //NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        /*NSString *str = @"data:image/jpg;base64,";
        str = [str stringByAppendingString:image];
        
        NSLog(@"%@",[NSURL URLWithString:str]);
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];*/
        
        //NSData *dataObj = [NSData dataWithBase64EncodedString:str];
        
        //NSData *imageData = [NSData dataWithBase64EncodedString:image];
        
        
        //img = [UIImage imageWithData:imageData];
        
        NSLog(@"img non nulla: %@",image);
         
        NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:[image UTF8String]]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        return [UIImage imageWithData:imageData];
        
    }
    
    return img;
}

@end
