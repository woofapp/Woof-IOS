//
//  LocationController.h
//  BackgroundLocation
//
//  Created by Andrea Gerino on 31/05/12.
//  Copyright (c) 2012 EveryWare Technologies. All rights reserved.
//

//
// NOTE
//
// In questo esercizio ho voluto mostrare come realizzare un proprio oggetto "controller" che gestisca la posizione e come usare la delegation per permettere ad altri oggetti di gestire gli eventi generati
// 
// Questo oggetto supporta un solo delegate ma avrebbe senso permettere a più oggetti di registrarsi come delegate
//  
// Il LocationController poteva essere implementato come singleton ma non lo ho fatto per non farcire troppo l'esempio (cosa che in genere si fa nella pratica)
// 

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationControllerDelegate.h"

@interface LocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocation *currentLocation;

//Questa property conterrà il puntatore all'oggetto delegate del nostro LocationController (qualsiasi oggetto che implementa il protocollo LocationControllerDelegate)
@property (nonatomic,strong) id <LocationControllerDelegate> delegate;

//Definizione di metodi pubblici
-(void) startLookingForLocation;
-(void) stopLookingForLocation;
-(BOOL) isUpdatingLocation;
+ (LocationController *)sharedLocationController;
+ (void) storeLastKnownLocation: (CLLocation *) location;
+ (CLLocation *) getLastKnownLocation;

@end
