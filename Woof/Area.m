//
//  Area.m
//  Woof
//
//  Created by Mattia Campana on 02/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "Area.h"

@implementation Area

@synthesize myIdArea;
@synthesize myAddress;
@synthesize myImages;
@synthesize version;
@synthesize myCheckins;
@synthesize myComments;
@synthesize myRating;
@synthesize myNRating;
@synthesize myDistance;
@synthesize coordinate = _coordinate;
@synthesize lastNCheckins;
@synthesize totalCheckins;
@synthesize title;

- (NSString *)subtitle {
    return myAddress;
}

- (void)setCoordinate: (CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}

- (NSComparisonResult)compare:(Area *)otherObject {
    return (self.myDistance >= otherObject.myDistance);
}

@end
