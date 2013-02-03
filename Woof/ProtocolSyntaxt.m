//
//  ProtocolSyntaxt.m
//  Woof
//
//  Created by Mattia Campana on 30/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "ProtocolSyntaxt.h"
#import "SBJson.h"
#import "Parameters.h"
#import "Area.h"
#import "Comment.h"
#import "User.h"
#import "Dog.h"

@implementation ProtocolSyntaxt

+(NSMutableDictionary*) extractWeatherInfo: (NSData*) data{
    //Utilizziamo il metodo JSONValue, aggiunto dalla libreria JSON a NSData tramite una category, per ottenere l'oggetto Objective-C corrispondente all'oggetto JSON ricevuto
    NSDictionary *receivedObject = [data JSONValue];
    
    NSString* weatherCode = [[[[receivedObject objectForKey:PARAM_WEATHER_DATA] objectForKey:PARAM_WEATHER_CURRENT_CONDITION] objectAtIndex:0] objectForKey:PARAM_WEATHER_CODE];
    
    NSString* weatherTemp = [[[[receivedObject objectForKey:PARAM_WEATHER_DATA] objectForKey:PARAM_WEATHER_CURRENT_CONDITION] objectAtIndex:0] objectForKey:PARAM_WEATHER_TEMP_C];
    
    NSString* weatherLocation = [[[[[[receivedObject objectForKey:PARAM_WEATHER_DATA] objectForKey:PARAM_WEATHER_NEAREST_AREA] objectAtIndex:0] objectForKey:PARAM_WEATHER_AREA_NAME] objectAtIndex:0] objectForKey:PARAM_WEATHER_VALUE];
    
    NSString* weatherCountry = [[[[[[receivedObject objectForKey:PARAM_WEATHER_DATA] objectForKey:PARAM_WEATHER_NEAREST_AREA] objectAtIndex:0] objectForKey:@"country"] objectAtIndex:0] objectForKey:PARAM_WEATHER_VALUE];
    
    if([weatherLocation isEqualToString:@"Mailand"] && [weatherCountry isEqualToString:@"Italy"]){
        weatherLocation = @"Milano";
    }
    
    NSMutableDictionary* weatherInfo;
    
    weatherInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   weatherCode, PARAM_WEATHER_CODE,
                   weatherTemp, PARAM_WEATHER_TEMP,
                   weatherLocation, PARAM_WEATHER_LOCATION, nil];
    
    NSLog(@"%@",weatherInfo);
    
    return weatherInfo;
}

/*
 * AREAS
 */

+(NSMutableDictionary *) checkAreas: (NSArray *) areas withLatitude: (NSNumber *) latitude longitude: (NSNumber *) longitude radius: (NSNumber *) radius{
    
    NSMutableArray *areasArray = [[NSMutableArray alloc] init];
    
    for(Area *area in areas){
        NSMutableDictionary *areaDict = [[NSMutableDictionary alloc]init];
        [areaDict setObject:area.myIdArea forKey:PARAM_ID_AREA];
        NSNumber *versionObj = [[NSNumber alloc] initWithInt:area.version];
        [areaDict setObject:versionObj forKey:PARAM_VERSION];
        
        [areasArray addObject:areaDict];
    }
    
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setObject:latitude forKey:PARAM_LATITUDE];
    [requestDictionary setObject:longitude forKey:PARAM_LONGITUDE];
    [requestDictionary setObject:radius forKey:PARAM_RADIUS];
    [requestDictionary setObject:areasArray forKey:PARAM_ARRAY_AREAS];
    
    
    return requestDictionary;
}

+(NSMutableDictionary*) getAreasRequestFromLatitude: (NSNumber*) latitude andLongitude: (NSNumber*) longitude andRadius: (NSNumber*) radius{
    //Creo l'NSMutableDictionary contenente i dati per la richiesta; il dictionary puo' contenere solo oggetti quindi i float devono essere inseriti all'interno di oggetti NSNumber
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setObject:latitude forKey:PARAM_LATITUDE];
    [requestDictionary setObject:longitude forKey:PARAM_LONGITUDE];
    [requestDictionary setObject:radius forKey:PARAM_RADIUS];
    
    return requestDictionary;
}

+(NSMutableArray*) getAreasResponse: (NSData*) data{
    
    NSDictionary *receivedObject = [data JSONValue];
    
    NSMutableArray *areas = [[NSMutableArray alloc] initWithObjects:nil];
    
    for (NSDictionary *obj in [receivedObject objectForKey:PARAM_ARRAY_AREAS]) {
        
        //creo nuovo oggetto area
        Area *newArea = [[Area alloc]init];
        
        [newArea setMyIdArea:[obj objectForKey:PARAM_ID_AREA]];
        [newArea setVersion:[[obj objectForKey:PARAM_VERSION] integerValue]];
        [newArea setMyAddress:[obj objectForKey:PARAM_ADDRESS]];
        [newArea setMyDistance:[[obj objectForKey:PARAM_DISTANCE] doubleValue]];
        
        NSNumber *latitude = [obj objectForKey:PARAM_LATITUDE];
        NSNumber *longitude = [obj objectForKey:PARAM_LONGITUDE];
        
        [newArea setMyRating:[[obj objectForKey:PARAM_RATING] doubleValue]];
        [newArea setMyNRating:[[obj objectForKey:PARAM_NRATING] integerValue]];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        
        newArea.coordinate = coordinate;
        
        Comment *comment = [[Comment alloc]init];
        
        if(![[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_COMMENT] isEqualToString:@"null"]){
        
            [comment setText:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_COMMENT]];
            [comment setDate:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_DATE]];
        
            User *user = [[User alloc]init];
            [user setIdUser:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_IDUSER]];
            [user setName:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_NAME]];
            [user setSurname:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_SURNAME]];
        
            if(![[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_IMAGE] isEqualToString:PARAM_NULL]){
                [user setImage:[[obj objectForKey:PARAM_COMMENTOBJ] objectForKey:PARAM_IMAGE]];
            }
        
            [comment setUser:user];
            NSMutableArray *comments = [[NSMutableArray alloc]init];
            [comments addObject:comment];
            
            [newArea setMyComments:comments];
        }
        
        //aggiungo la nuova area all'array
        [areas addObject:newArea];
        
	}
    
    return areas;
}

+(NSMutableDictionary*) getAreaDetailsRequest: (int) idArea{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdArea = [[NSNumber alloc]initWithInteger:idArea];
    [requestDictionary setObject:myIdArea forKey:PARAM_ID_AREA];
    
    return requestDictionary;
}

+(NSDictionary*) getAreaDetailsResponse: (NSData*) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSString* lastNCheckins = [receivedObject objectForKey:PARAM_LASTNCHECKINS];
    NSString* totalCheckins = [receivedObject objectForKey:PARAM_TOTALCHECKINS];
    
    NSMutableDictionary* areaDetails;
    
    areaDetails = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   lastNCheckins, PARAM_LASTNCHECKINS,
                   totalCheckins, PARAM_TOTALCHECKINS,nil];
    
    return areaDetails;
}

+(NSMutableDictionary *) getLastAreaImageRequest: (int) idArea{
    
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdArea = [[NSNumber alloc]initWithInteger:idArea];
    [requestDictionary setObject:myIdArea forKey:PARAM_ID_AREA];
    
    return requestDictionary;
    
}

+(NSString *) getLastAreaImageResponse: (NSData *) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSString* lastAreaImage = [receivedObject objectForKey:PARAM_IMAGE];
    
    if(lastAreaImage == NULL || [lastAreaImage isEqualToString:@"null"]) return NULL;
    
    return lastAreaImage;
}

+(NSMutableDictionary *) getAreaImagesRequest: (int) idArea{
    
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdArea = [[NSNumber alloc]initWithInteger:idArea];
    [requestDictionary setObject:myIdArea forKey:PARAM_ID_AREA];
    
    return requestDictionary;
    
}

+(NSMutableArray *) getAreaImagesResponse: (NSData *) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSMutableArray *ret = [receivedObject objectForKey:PARAM_IMAGES];
    
    return ret;
}

+(NSMutableDictionary *) getImageRequest: (int) idImage{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdImage = [[NSNumber alloc]initWithInteger:idImage];
    [requestDictionary setObject:myIdImage forKey:PARAM_ID_IMAGE];
    
    return requestDictionary;
}

+(NSString *) getImageResponse: (NSData *) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    return [receivedObject objectForKey:PARAM_IMAGE];
}

/*
 * COMMENTS
 */
+(NSDictionary *) getLastNCommentsRequest: (int) idArea andIndex: (int) index{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdArea = [[NSNumber alloc]initWithInteger:idArea];
    [requestDictionary setObject:myIdArea forKey:PARAM_ID_AREA];
    
    NSNumber *myIndex = [[NSNumber alloc]initWithInteger:index];
    [requestDictionary setObject:myIndex forKey:PARAM_INDEX];
    
    return requestDictionary;
}

+(NSArray *) getLastNCommentsResponse: (NSData*) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    
    for (NSDictionary *obj in [receivedObject objectForKey:PARAM_ARRAYCOMMENTS]){
        
        User *user = [[User alloc]init];
        user.name = [obj objectForKey:PARAM_NAME];
        user.surname = [obj objectForKey:PARAM_SURNAME];
        user.idUser = [obj objectForKey:PARAM_IDUSER];
        
        if(![[obj objectForKey:PARAM_IMAGE] isEqualToString:@"null"]){
            user.image = [obj objectForKey:PARAM_IMAGE];
        }
        
        Comment *comment = [[Comment alloc]init];
        comment.text = [obj objectForKey:PARAM_COMMENT];
        comment.date = [obj objectForKey:PARAM_DATE];
        comment.user = user;
        
        [comments addObject:comment];
    }
    
    if([comments count] == 0)
        return nil;
    
    return comments;
}

+(NSDictionary *) getCommentsRequest:(int)idArea fromIndex:(int)index{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    NSNumber *myIdArea = [[NSNumber alloc]initWithInteger:idArea];
    [requestDictionary setObject:myIdArea forKey:PARAM_ID_AREA];
    
    NSNumber *myIndex = [[NSNumber alloc]initWithInteger:index];
    [requestDictionary setObject:myIndex forKey:PARAM_INDEX];
    
    return requestDictionary;
}

+(NSArray *) getCommentsResponse:(NSData *)data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary *obj in [receivedObject objectForKey:PARAM_ARRAYCOMMENTS]){
        
        User *user = [[User alloc]init];
        user.name = [obj objectForKey:PARAM_NAME];
        user.surname = [obj objectForKey:PARAM_SURNAME];
        user.idUser = [obj objectForKey:PARAM_IDUSER];
        
        if(![[obj objectForKey:PARAM_IMAGE] isEqualToString:@"null"]){
            user.image = [obj objectForKey:PARAM_IMAGE];
        }
        
        Comment *comment = [[Comment alloc]init];
        comment.text = [obj objectForKey:PARAM_COMMENT];
        comment.date = [obj objectForKey:PARAM_DATE];
        comment.user = user;
        
        [comments addObject:comment];
    }

    if([comments count] == 0)
        return nil;
    
    return comments;
    
}

/*
 * USER
 */
+(NSDictionary *) userLoginRequest: (NSString *)email andPassword:(NSString *)password{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    
    [requestDictionary setObject:email forKey:PARAM_EMAIL];
    [requestDictionary setObject:password forKey:PARAM_PASSWORD];
    
    return requestDictionary;
}

+(NSString *) userLoginResponse: (NSData*) data{
    NSDictionary *receivedObject = [data JSONValue];
    
    NSString *token = [receivedObject objectForKey:PARAM_TOKEN];
    
    if([token isEqualToString:@"null"]) return NULL;
    return token;
}

+(NSDictionary *) getUserInfoRequest: (NSString *)token andEmail:(NSString *)email{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    
    [requestDictionary setObject:email forKey:PARAM_EMAIL];
    [requestDictionary setObject:token forKey:PARAM_TOKEN];
    
    return requestDictionary;
}

+(User *) getUserInfoResponse: (NSData * ) data{
    NSDictionary *receivedObject = [data JSONValue];
    User *user = [[User alloc] init];
    user.idUser = [receivedObject objectForKey:PARAM_IDUSER];
    user.email = [receivedObject objectForKey:PARAM_EMAIL];
    user.name = [receivedObject objectForKey:PARAM_NAME];
    user.surname = [receivedObject objectForKey:PARAM_SURNAME];
    if(![[receivedObject objectForKey:PARAM_CITY] isEqualToString:@"null"]){
        user.city = [receivedObject objectForKey:PARAM_CITY];
    }
    if(![[receivedObject objectForKey:PARAM_IMAGE] isEqualToString:@"null"]){
        user.image = [receivedObject objectForKey:PARAM_IMAGE];
    }
    
    NSMutableArray *dogs = [[NSMutableArray alloc]init];
    for (NSDictionary *obj in [receivedObject objectForKey:PARAM_DOGS]){
        Dog *dog = [[Dog alloc] init];
        dog.idDog = [obj objectForKey:PARAM_IDDOG];
        dog.name = [obj objectForKey:PARAM_NAME];
        dog.race = [obj objectForKey:PARAM_RACE];
        dog.year = [obj objectForKey:PARAM_YEAR];
        
        if(![[obj objectForKey:PARAM_IMAGE] isEqualToString:@"null"]){
            dog.image = [obj objectForKey:PARAM_IMAGE];
        }
        
        [dogs addObject:dog];
    }
    user.dogs = dogs;
    return user;
}

+(NSDictionary *) getUserNCheckinsRequest: (NSString *)token andIdUser:(NSString *)idUser{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    
    [requestDictionary setObject:idUser forKey:PARAM_IDUSER];
    [requestDictionary setObject:token forKey:PARAM_TOKEN];
    
    return requestDictionary;
}

+(NSDictionary *) getUserNCheckinsResponse: (NSData *) data{
    NSDictionary *receivedObject = [data JSONValue];
    return [receivedObject objectForKey:PARAM_CHECKINS];
}


/*
 * GENERIC
 */

+(Boolean) getBooleanResponse: (NSData *) data{
    
    NSDictionary *receivedObject = [data JSONValue];
    
    return [[receivedObject objectForKey:PARAM_RESPONSE] boolValue];
}

@end
