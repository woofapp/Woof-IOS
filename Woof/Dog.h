//
//  Dog.h
//  Woof
//
//  Created by nicola on 01/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

@property (nonatomic, retain) NSString *idDog;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *race;
@property (nonatomic) int year;
@property (nonatomic, retain) NSString *image;

@end
