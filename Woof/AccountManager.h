//
//  AccountManager.h
//  Woof
//
//  Created by Mattia Campana on 31/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AccountManager : NSObject

+(NSString*) simpleLoginWith: (NSString *)email andPassword: (NSString *)password;
+(User *) getUserInfoWith: (NSString *)token andEmail:(NSString *)email;
+(int) getUserNCheckinsWith:(NSString *)token andIdUser:(NSString *)idUser;

@end
