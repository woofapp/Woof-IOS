//
//  LocationController.m
//  BackgroundLocation
//
//  Created by Andrea Gerino on 31/05/12.
//  Copyright (c) 2012 EveryWare Technologies. All rights reserved.
//

#import "LocationController.h"

//Definiamo una variabile privata e una property privata estendendo la classe direttamente nel file m
@interface LocationController (){
    
    BOOL isUpdatingLocation;
    
}

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation LocationController

@synthesize delegate, currentLocation, locationManager = _locationManager;//rinominiamo la variabile per evitare che vi si possa accedere direttamente

//riscriviamo il getter della property: in questo metodo inizializziamo il locationManager la prima volta che viene utilizzato
- (CLLocationManager *)locationManager {
    
    if (_locationManager == nil) {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    }
    
    return _locationManager;

}

+ (LocationController *)sharedLocationController
{
    static LocationController *sharedLocationControllerInstance = nil;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{

        sharedLocationControllerInstance = [[self alloc] init];

    });

    return sharedLocationControllerInstance;
}


-(void) startLookingForLocation{

    //Usiamo il getter della property per ottenere il puntatore al locationManager
    CLLocationManager *locationManager = [self locationManager];
    
    //Impostiamo la precisione desiderata
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    //Impostiamo il minimo spostamento dell'utente necessario a far scaturire l'evento di aggiornamento
    locationManager.distanceFilter = 100;

    isUpdatingLocation = YES;
    
    //Avviamo il servizio di aggiornamento della posizione (attenzione: avendo impostato il flag background location nel file info.plist, l'app continuerà ad andare in bkg fino a quando non verrà killata da iOS perché ha bisogno di memoria, non verrà riavviato il telefono o non verrà arrestato il servizio di aggiornamento della posizione
    [locationManager startUpdatingLocation];
    
}

-(void) stopLookingForLocation{
    
    isUpdatingLocation = NO;
    
    [[self locationManager] stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    [self setCurrentLocation:newLocation];
    
    //Notifichiamo il delegate del LocationController della nuova posizione ricevuta (siccome sappiamo che il delegate aderisce al protocollo LocationControllerDelegate possiamo chiamare il metodo senza temere errori)
    [delegate locationControllerDidUpdateLocation:currentLocation];
    
}

- (BOOL) isUpdatingLocation{
    
    return isUpdatingLocation;
    
}

+ (void) storeLastKnownLocation: (CLLocation *) location{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    if(![[userDefaults valueForKey:@"latitude"] isKindOfClass:[NSNull class]] && ![[userDefaults valueForKey:@"longitude"] isKindOfClass:[NSNull class]]){
        
        [userDefaults removeObjectForKey:@"latitude"];
        [userDefaults removeObjectForKey:@"longitude"];
    }
    
    NSNumber *lat = [[NSNumber alloc] initWithDouble:location.coordinate.latitude];
    NSNumber *lon = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
    
    [userDefaults setObject:lat forKey:@"latitude"];
    [userDefaults setObject:lon forKey:@"longitude"];
    [userDefaults synchronize];
    
    
}

+ (CLLocation *) getLastKnownLocation{
    
    CLLocation *location = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![[userDefaults valueForKey:@"latitude"] isKindOfClass:[NSNull class]] && ![[userDefaults valueForKey:@"longitude"] isKindOfClass:[NSNull class]]){
        
        NSNumber *lat = [userDefaults objectForKey:@"latitude"];
        NSNumber *lon = [userDefaults objectForKey:@"longitude"];
    
        location = [[CLLocation alloc]initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    }
    
    return location;
    
}

@end
