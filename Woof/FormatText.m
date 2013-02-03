//
//  FormatText.m
//  Woof
//
//  Created by Mattia Campana on 02/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "FormatText.h"

@implementation FormatText

+(NSString*) toUpperEveryFirstChar: (NSString *)originalString{
    
    NSString *returnString = @"";
    
    NSArray *fields = [originalString componentsSeparatedByString:@" "];
    
    for(NSString *s in fields)
        returnString = [[returnString stringByAppendingString:[s capitalizedString]] stringByAppendingString:@" "];
    
    returnString = [returnString substringToIndex:[returnString length] - 1];
    
    return returnString;
}

+(NSString *) formatComment: (NSString *) originalComment withQuotes:(BOOL)quotes{
    if([originalComment length] == 0) return originalComment;
    
    NSString *tempComment = @"";
    tempComment = [FormatText captilizeParagraph:originalComment];
    
    if([tempComment length] >= 80) tempComment = [[tempComment substringWithRange:NSMakeRange(0, 80)] stringByAppendingString:@"..."];
    
    NSString *newComment = @"";
    if(quotes) newComment = [[@"\"" stringByAppendingString:tempComment] stringByAppendingString:@"\""];
    else newComment = tempComment;
    
    return newComment;
}

+(NSString *)captilizeParagraph:(NSString *)paragraph {
    
    if ([paragraph length] == 0) return paragraph;
    
    NSArray *sentences = [paragraph componentsSeparatedByString:@"."];
    
    NSString *newParagraph = @"";
    
    for (NSString *sentence in sentences){
        if([sentence length] >0){
            newParagraph = [sentence lowercaseString];
            newParagraph = [[[newParagraph substringToIndex:1] uppercaseString] stringByAppendingString:[newParagraph substringFromIndex:1]];
        }
        newParagraph = [newParagraph stringByAppendingString:@"."];
    }
    
    return newParagraph;
}

+(NSString *)formatDate:(NSString *)originalDate{
    
    if([originalDate length] == 0) return originalDate;
    
    NSString *dateString = [originalDate componentsSeparatedByString:@" "][0];
    NSArray *parts = [dateString componentsSeparatedByString:@"-"];
    
    NSString *date = [[[[parts[2] stringByAppendingString:@"/"] stringByAppendingString:parts[1]] stringByAppendingString:@"/"] stringByAppendingString:parts[0]];
    
    return date;
}

@end
