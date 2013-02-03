//
//  DataSource.h
//  Woof
//
//  Created by Mattia Campana on 31/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(void)setLoginDefaultsWith: (NSString *)email andPassword:(NSString *)password andToken:(NSString *)token;
+(NSString*)getEmailDefault;
+(NSString*)getPasswordDefault;
+(NSString*)getTokenDefault;

@end
