//
//  FormValidator.m
//  Woof
//
//  Created by nicola on 01/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "FormValidator.h"

@implementation FormValidator
+ (BOOL) validateEmail: (NSString *) candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
@end
