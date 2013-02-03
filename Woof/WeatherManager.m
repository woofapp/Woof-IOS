//
//  WeatherManager.m
//  Woof
//
//  Created by Mattia Campana on 31/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "WeatherManager.h"
#import "CommunicationController.h"
#import "ProtocolSyntaxt.h"
#import "Parameters.h"

@implementation WeatherManager

+(NSDictionary*)getCurrentWeatherFrom: (CLLocation*)location{
    
    NSDictionary *weatherInfo = [WeatherManager getDefaultWeatherInfo];
    NSDate *date = [weatherInfo objectForKey:@"weatherDate"];
    
    //controllo se sono già state salvate le info e se è passata almeno un'ora
    if(location != NULL && (weatherInfo.count == 0 || [date timeIntervalSinceNow] >= 3600 || date == NULL)){
        
        //scarico le info aggiornate
        NSString *latitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.latitude];
        NSString *longitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.longitude];
        
        weatherInfo = [WeatherManager fetchWeatherInfo:latitude andLongitude:longitude];

        [WeatherManager setDefaultWeatherInfo:[weatherInfo objectForKey:@"weatherLocation"]
                                      andTemp:[weatherInfo objectForKey:@"weatherTemp"]
                                      andIcon:[weatherInfo objectForKey:@"weatherIcon"]
                                      andDate:[NSDate date]];
    }
    
    return weatherInfo;
}

+(NSString*) getWeatherIconFrom: (int) weatherCode{
    
    NSString *weatherIcon = nil;
    
    switch (weatherCode) {
        //Snow codes
        case 395:
        case 392:
        case 377:
        case 374:
        case 371:
        case 368:
        case 365:
        case 350:
        case 338:
        case 335:
        case 332:
        case 329:
        case 326:
        case 323:
        case 320:
        case 317:
        case 230:
        case 227:
        case 179:
            
            weatherIcon = @"snow@2.png";
            break;
        
        //Rain codes
        case 362:
        case 359:
        case 356:
        case 353:
        case 314:
        case 311:
        case 308:
        case 305:
        case 302:
        case 299:
        case 296:
        case 293:
        case 284:
        case 281:
        case 266:
        case 263:
        case 185:
        case 182:
        case 176:
            
            weatherIcon = @"rain@2.png";
            break;
        
        //Thunder codes
        case 389:
        case 386:
        case 200:
            
            weatherIcon = @"thunder@2.png";
            break;
        
        //Sun codes
        case 113:
            weatherIcon = @"sunny@2.png";
            break;
        //Mostly Cloudy codes
        case 116:
            weatherIcon = @"mostly_cloudy@2.png";
            break;
            
        //Cloudy codes
        case 122:
        case 119:
            weatherIcon = @"cloudy@2.png";
            break;
            
        //Haze code
        case 260:
        case 248:
        case 143:
            weatherIcon = @"haze@2.png";
            break;
            
        default:
            break;
    }
    
    
    
    return weatherIcon;
}

+(NSMutableDictionary*) fetchWeatherInfo: (NSString*) latitude andLongitude: (NSString*) longitude{
    
    //Creo la stringa che rappresenta l'url per richiede le informazioni meteo
    NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://free.worldweatheronline.com/feed/weather.ashx?q="];
    [url appendString:latitude];
    [url appendString:@","];
    [url appendString:longitude];
    [url appendString:@"&fx=no&format=json&num_of_days=1&key=c7356e22ab132640123008&includeLocation=yes"];
    
    //mando la richiesta al CommunicationController
    NSData* responseData = [CommunicationController doPostRequest:url andData:nil];
    
    if (responseData != nil) {
        NSMutableDictionary* weatherInfo = [ProtocolSyntaxt extractWeatherInfo:responseData];
        
        int weatherCode = [[weatherInfo objectForKey:PARAM_WEATHER_CODE] integerValue];
        
        NSString *image = [self getWeatherIconFrom:weatherCode];
        
        [weatherInfo setObject:image forKey:PARAM_WEATHER_ICON];

        return weatherInfo;
    }
    
    return nil;
}

+(void) setDefaultWeatherInfo: (NSString *)location andTemp: (NSString*)temp andIcon: (NSString*)icon andDate: (NSDate*) date{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:location forKey:@"weatherLocation"];
    [defaults setValue:temp forKey:@"weatherTemp"];
    [defaults setValue:icon forKey:@"weatherIcon"];
    [defaults setObject:date forKey:@"weatherDate"];

    [defaults synchronize];
}

+(NSDictionary*) getDefaultWeatherInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //NSData *data = [NSData alloc] ini
    
    NSDictionary *weatherInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [defaults stringForKey:@"weatherLocation"], @"weatherLocation",
                                [defaults stringForKey:@"weatherTemp"], @"weatherTemp",
                                [defaults stringForKey:@"weatherIcon"], @"weatherIcon",
                                [defaults objectForKey:@"weatherDate"], @"weatherDate",nil];
    
    return weatherInfo;
}

@end
