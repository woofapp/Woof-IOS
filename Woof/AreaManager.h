//
//  AreaManager.h
//  Woof
//
//  Created by Mattia Campana on 02/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"

@interface AreaManager : NSObject

+ (Boolean) checkAreas: (NSArray *) areas inLocation: (CLLocation *) location andRadius: (int) radius;

+ (NSMutableArray*) getAreasFrom: (double) latitude andLongitude: (double) longitude andRadius: (int) radius;

+ (Area*) getAreaDetails: (Area*) area;

+ (NSString *)getLastAreaImage: (int) idArea;

+ (NSMutableArray *) getAreaImages: (int) idArea;

+ (NSString *)getImage:(int)idImage;


/*
 * DB
 */

+ (NSArray *) getAreasFromDB: (double) latitude andLongitude: (double) longitude andRadius: (int) radius;
+ (void) insertAreaInDB: (Area*) area;


/*
 * UserDefaults (SharedPreferencies)
 */

+ (void) setDefaultRadius: (int) radius;
+ (int) getDefaultRadius;

@end
