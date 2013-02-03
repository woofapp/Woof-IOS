//
//  CommunicationController.h
//  Woof
//
//  Created by Mattia Campana on 31/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunicationController : NSObject

+(NSString*) getWebServiceAddress;
+(NSData*) doPostRequest: (NSString*) url andData: (NSDictionary*) dati;

@end
