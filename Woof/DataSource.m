//
//  DataSource.m
//  Woof
//
//  Created by Mattia Campana on 31/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+(void)setLoginDefaultsWith: (NSString *)email andPassword:(NSString *)password andToken:(NSString *)token{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:email forKey:@"email"];
    [defaults setValue:password forKey:@"password"];
    [defaults setValue:token forKey:@"token"];
    
    [defaults synchronize];
}

+(NSString*)getEmailDefault{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"email"];
}

+(NSString*)getPasswordDefault{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"password"];
}

+(NSString*)getTokenDefault{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"token"];
}



@end
