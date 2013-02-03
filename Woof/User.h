//
//  User.h
//  Woof
//
//  Created by Mattia Campana on 10/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface User : NSObject{
    
    @private
    NSString *idUser;
    NSString *email;
    NSString *password;
    NSString *name;
    NSString *surname;
    NSString *image;
    NSString *city;
    NSArray *dogs;
    Token *token;
}

@property (nonatomic, retain) NSString *idUser;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *surname;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSArray *dogs;
@property (nonatomic, retain) Token *token;

-(NSString*)setB64ImageFromUIImage:(UIImage *)img;

-(UIImage *)getImageFromB64String;

@end
