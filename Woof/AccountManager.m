//
//  AccountManager.m
//  Woof
//
//  Created by Mattia Campana on 31/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "AccountManager.h"
#import "DataSource.h"
#import "ProtocolSyntaxt.h"
#import "CommunicationController.h"
#import "Commands.h"
#import "Utility.h"
#import "Parameters.h"
#import "Database.h"

@implementation AccountManager

+(NSString *) simpleLoginWith: (NSString *)email andPassword: (NSString *)password{
    
    //richiesta json
     NSDictionary *request = [ProtocolSyntaxt userLoginRequest:email.uppercaseString andPassword:[Utility sha256HashFor:password]];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_USER_LOGIN];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    NSString *token = NULL;
    
    if(response != NULL){
        //response json
        token = [ProtocolSyntaxt userLoginResponse:response];
        [DataSource setLoginDefaultsWith:email andPassword:password andToken:token];
    }
    
    return token;
}

+(User *) getUserInfoWith:(NSString *)token andEmail:(NSString *)email{
    //richiesta json
    NSDictionary *request = [ProtocolSyntaxt getUserInfoRequest:token andEmail:email];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_USER_INFO];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    //response json
    User *user = [ProtocolSyntaxt getUserInfoResponse:response];
    
    //populate database
    Database *db = [Database sharedDatabase];
    [db insertUser:user];
    [db insertDogsWith:user.dogs andIdUser:user.idUser];
    
    return user;
    
}

+(int) getUserNCheckinsWith:(NSString *)token andIdUser:(NSString *)idUser{
    //richiesta json
    NSDictionary *request = [ProtocolSyntaxt getUserNCheckinsRequest:token andIdUser:idUser];
    
    //costruzione url+command
    NSMutableString *url = [[NSMutableString alloc]initWithString:[CommunicationController getWebServiceAddress]];
    [url appendString:COMMAND_GET_USER_N_CHECKINS];
    
    //risposta dal server
    NSData *response = [CommunicationController doPostRequest:url andData:request];
    
    //response json
    NSDictionary *dictionary = [ProtocolSyntaxt getUserNCheckinsResponse:response];
    
    //populate database
    Database *db = [Database sharedDatabase];
    for (id obj in dictionary) {
        [db insertCheckinWith:[obj objectForKey:PARAM_ID_AREA]andIdUser:idUser andIdDog:[obj objectForKey:PARAM_IDDOG] andDate:[obj objectForKey:PARAM_DATE]];
    }
    
    return [db getUserNCheckins:idUser];
}

@end
