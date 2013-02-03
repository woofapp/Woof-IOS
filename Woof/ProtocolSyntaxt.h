//
//  ProtocolSyntaxt.h
//  Woof
//
//  Created by Mattia Campana on 30/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ProtocolSyntaxt : NSObject

+(NSMutableDictionary*) extractWeatherInfo: (NSData*) data;

/*
 * AREAS
 */

+(NSMutableDictionary *) checkAreas: (NSArray *) areas withLatitude: (NSNumber *) latitude longitude: (NSNumber *) longitude radius: (NSNumber *) radius;

+(NSMutableDictionary*) getAreasRequestFromLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andRadius: (NSNumber*) radius;

+(NSMutableArray*) getAreasResponse: (NSData*) data;

+(NSMutableDictionary*) getAreaDetailsRequest: (int) idArea;

+(NSDictionary*) getAreaDetailsResponse: (NSData*) data;

+(NSMutableDictionary *) getLastAreaImageRequest: (int) idArea;

+(NSString *) getLastAreaImageResponse: (NSData *) data;

+(NSMutableDictionary *) getAreaImagesRequest: (int) idArea;

+(NSMutableArray *) getAreaImagesResponse: (NSData *) data;

+(NSMutableDictionary *) getImageRequest: (int) idImage;

+(NSString *) getImageResponse: (NSData *) data;

/*
 * COMMENTS
 */

+(NSDictionary *) getLastNCommentsRequest: (int) idArea andIndex: (int) index;

+(NSArray *) getLastNCommentsResponse: (NSData*) data;

+(NSDictionary *) getCommentsRequest: (int) idArea fromIndex: (int) index;

+(NSArray *) getCommentsResponse: (NSData*) data;

/*
 * USER
 */

+(NSDictionary *) userLoginRequest: (NSString *)email andPassword:(NSString *)password;

+(NSString *) userLoginResponse: (NSData*) data;

+(NSDictionary *) getUserInfoRequest: (NSString *)token andEmail:(NSString *)email;

+(User *) getUserInfoResponse: (NSData * ) data;

+(NSDictionary *) getUserNCheckinsRequest: (NSString *)token andIdUser:(NSString *)idUser;

+(NSDictionary *) getUserNCheckinsResponse: (NSData *) data;

/*
 * GENERIC
 */

+(Boolean) getBooleanResponse: (NSData *) data;

@end
