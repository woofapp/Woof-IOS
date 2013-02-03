//
//  AreaManager.m
//  Woof
//
//  Created by Mattia Campana on 02/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "AreaManager.h"
#import "ProtocolSyntaxt.h"
#import "CommunicationController.h"
#import "Commands.h"
#import "Parameters.h"
#import "Database.h"

@implementation AreaManager

+ (Boolean) checkAreas: (NSArray *) areas inLocation: (CLLocation *) location andRadius: (int) radius{
    
    Boolean resp = NO;
    
    NSNumber *latitudeObj = [[NSNumber alloc]initWithDouble:location.coordinate.latitude];
    NSNumber *longitudeObj = [[NSNumber alloc]initWithDouble:location.coordinate.longitude];
    NSNumber *radiusObj = [[NSNumber alloc]initWithInt:radius];
    
    NSMutableDictionary *request = [ProtocolSyntaxt checkAreas:areas withLatitude:latitudeObj longitude:longitudeObj radius:radiusObj];
    
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_CHECK_AREAS];
    
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    if(response != nil) resp = [ProtocolSyntaxt getBooleanResponse:response];
    
    return resp;
}

+ (NSMutableArray*) getAreasFrom: (double) latitude andLongitude: (double) longitude andRadius: (int) radius{
    
    NSMutableArray* areas;
    
    NSNumber *lat = [[NSNumber alloc]initWithDouble:latitude];
    NSNumber *lon = [[NSNumber alloc]initWithDouble:longitude];
    NSNumber *rad = [[NSNumber alloc]initWithDouble:radius];
    
    //richiesta json
    NSMutableDictionary *request = [ProtocolSyntaxt getAreasRequestFromLatitude:lat andLongitude:lon andRadius:rad];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_AREAS];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    if(response != nil)
        areas = [ProtocolSyntaxt getAreasResponse:response];
    else
        return nil;
    
    for(Area *area in areas){
        CLLocation *myLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation *areaLoc = [[CLLocation alloc] initWithLatitude:area.coordinate.latitude longitude:area.coordinate.longitude];
        
        CLLocationDistance distance = [myLoc distanceFromLocation:areaLoc];
        
        [area setMyDistance:distance];
    }
    
    return areas;
}

+ (Area*) getAreaDetails: (Area*) area{
    //richiesta json
    NSMutableDictionary *request = [ProtocolSyntaxt getAreaDetailsRequest:[area.myIdArea integerValue]];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_AREA_DETAILS];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    NSDictionary *areaDetails;
    
    if(response != nil)
        areaDetails = [ProtocolSyntaxt getAreaDetailsResponse:response];
    else
        return nil;
    
    [area setLastNCheckins:[[areaDetails objectForKey:PARAM_LASTNCHECKINS] integerValue]];
    [area setTotalCheckins:[[areaDetails objectForKey:PARAM_TOTALCHECKINS] integerValue]];
    
    return area;
}

+ (NSString *)getLastAreaImage: (int) idArea{
    
    //richiesta json
    NSMutableDictionary *request = [ProtocolSyntaxt getLastAreaImageRequest:idArea];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_LAST_AREA_IMAGE];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    NSString *image;
    
    if(response != NULL) image = [ProtocolSyntaxt getLastAreaImageResponse:response];
    
    return image;
}

+ (NSMutableArray *)getAreaImages:(int)idArea{
    
    //richiesta json
    NSMutableDictionary *request = [ProtocolSyntaxt getAreaImagesRequest:idArea];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_AREA_IMAGES];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    NSMutableArray *imagesIds;
    
    if(response != NULL) imagesIds = [ProtocolSyntaxt getAreaImagesResponse:response];
    
    return imagesIds;
}

+ (NSString *)getImage:(int)idImage{
    //richiesta json
    NSMutableDictionary *request = [ProtocolSyntaxt getImageRequest:idImage];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_IMAGE];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    NSString *image;
    
    if(response != NULL) image = [ProtocolSyntaxt getImageResponse:response];
    
    return image;
}

/*
 * DB
 */

+ (NSArray *) getAreasFromDB: (double) latitude andLongitude: (double) longitude andRadius: (int) radius;{
    
    Database *db = [Database sharedDatabase];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    return [db getAreas:loc andRadius:radius];
}

+ (void) insertAreaInDB: (Area*) area{
   // Database *db = [Database sharedDatabase];
    
    //[db insertArea:area];
}

/*
 * NSUserDefaults (SharedPreferencies)
 */

+ (void) setDefaultRadius: (int) radius{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:radius forKey:@"defaultRadius"];
    [defaults synchronize];
}

+ (int) getDefaultRadius{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultRadius"];
}

@end
