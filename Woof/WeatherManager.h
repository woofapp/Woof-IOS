//
//  WeatherManager.h
//  Woof
//
//  Created by Mattia Campana on 31/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherManager : NSObject

+(NSDictionary*)getCurrentWeatherFrom: (CLLocation*)location;

+(NSMutableDictionary*) fetchWeatherInfo: (NSString*) latitude andLongitude: (NSString*) longitude;

+(void) setDefaultWeatherInfo: (NSString *)location andTemp: (NSString*)temp andIcon: (NSString*)icon andDate:(NSDate*) date;

+(NSDictionary*) getDefaultWeatherInfo;

@end
