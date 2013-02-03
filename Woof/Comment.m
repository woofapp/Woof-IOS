//
//  Comment.m
//  Woof
//
//  Created by Mattia Campana on 10/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize user;
@synthesize text;
@synthesize date;

-(Comment*) initWithUser: (User*) aUser text: (NSString*) aText date: (NSString*) aDate{
    
    self = [super init];
    if(self){
        self.user = aUser;
        self.text = aText;
        self.date = aDate;
    }
    
    return self;
}

@end
