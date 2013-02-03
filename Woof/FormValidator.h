//
//  FormValidator.h
//  Woof
//
//  Created by nicola on 01/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormValidator : NSObject

+ (BOOL) validateEmail: (NSString *) candidate;
@end
