//
//  SearchedLocationPoint.h
//  Woof
//
//  Created by Mattia Campana on 28/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SearchedLocationPoint : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
