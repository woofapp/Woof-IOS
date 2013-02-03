//
//  FormatText.h
//  Woof
//
//  Created by Mattia Campana on 02/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatText : NSObject

+(NSString*) toUpperEveryFirstChar: (NSString *)originalString;

+(NSString *) formatComment: (NSString *) originalComment withQuotes:(BOOL)quotes;

+(NSString *)captilizeParagraph:(NSString *)paragraph;

+(NSString *)formatDate: (NSString *)originalDate;

@end
