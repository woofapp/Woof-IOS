//
//  Comment.h
//  Woof
//
//  Created by Mattia Campana on 10/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject{
    
    @private
    User *User;
    NSString *text;
    NSString *date;
    
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *date;

-(Comment*) initWithUser: (User*) aUser text: (NSString*) text date: (NSString*) date;

@end
