//
//  LocationControllerDelegate.h
//  BackgroundLocation
//
//  Created by Andrea Gerino on 31/05/12.
//  Copyright (c) 2012 EveryWare Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationControllerDelegate <NSObject>

-(void) locationControllerDidUpdateLocation:(CLLocation*) location;

@end
