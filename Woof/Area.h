//
//  Area.h
//  Woof
//
//  Created by Mattia Campana on 02/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Area : NSObject <MKAnnotation>{
    
    CLLocationCoordinate2D _coordinate;
    
    @private
    NSString *myIdArea;
    NSString *myAddress;
    NSArray *myImages;
    int version;
    NSArray *myCheckins;
    NSArray *myComments;
    double myRating;
    int myNRating;
    double myDistance;
    int lastNCheckins;
    int totalCheckins;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *myIdArea;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *myAddress;
@property (nonatomic, retain) NSArray *myImages;
@property (nonatomic) int version;
@property (nonatomic, retain) NSArray *myCheckins;
@property (nonatomic, retain) NSArray *myComments;
@property (nonatomic) double myRating;
@property (nonatomic) int myNRating;
@property (nonatomic) double myDistance;
@property (nonatomic) int lastNCheckins;
@property (nonatomic) int totalCheckins;

- (void)setCoordinate: (CLLocationCoordinate2D)newCoordinate;
- (NSComparisonResult)compare:(Area *)otherObject;

@end
