//
//  CommunicationController.m
//  Woof
//
//  Created by Mattia Campana on 31/08/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "CommunicationController.h"
#import "SBJson.h"

static NSString *const REQUEST_URL = @"http://46.252.154.109:8081/woofService/";

@implementation CommunicationController

+(NSData*) doPostRequest: (NSString*) url andData: (NSDictionary*) bodyData{
    
    NSURL *myUrl = [NSURL URLWithString: url];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:myUrl];
    
    [urlRequest setHTTPMethod: @"POST"];
    
    NSString *httpBodyString = @"";
    
    if (bodyData != nil) {
        //Utilizziamo il metodo JSONRepresentation, aggiunto dalla libreria JSON a NSObject tramite una category, per ottenere la rappresentazione JSON dell'oggetto
        httpBodyString = [bodyData JSONRepresentation];
    }
    
    //Generiamo l'oggetto NSData che rappresenta i byte della stringa nella codifica UTF8 e lo impostiamo come body della richiesta
    NSData *httpBodyData = [httpBodyString dataUsingEncoding: NSUTF8StringEncoding];
    [urlRequest setHTTPBody:httpBodyData];
    
    //Impostiamo il campo "Content-Type" nell'header della richiesta
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSHTTPURLResponse *responseMetadata;
    
    //Efettuiamo la richiesta utilizzando una connseeione sincrona. responseMetadata e error sono puntatori a puntatori
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseMetadata error:&error];
    
    //Solo per debug: convertiamo i dati ottenuti dal server in una stringa
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Got form server: %@", responseString);
    
    switch ([responseMetadata statusCode]) {
        case 200:
            return responseData;
            break;
                
        default:
            return nil;
                
    }
    
    return nil;
}

+(NSString*) getWebServiceAddress{
    return REQUEST_URL;
}

@end
