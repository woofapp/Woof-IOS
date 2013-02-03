//
//  Token.h
//  Woof
//
//  Created by Mattia Campana on 10/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject{
    
    @private
    NSString *token;
}

@property (nonatomic, retain) NSString *token;

@end
