//
//  Database.h
//  Woof
//
//  Created by Mattia Campana on 12/10/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Area.h"
#import "Dog.h"
#import "FMDatabase.h"

@interface Database : NSObject

+ (Database *)sharedDatabase;

@property (retain, nonatomic) NSString *dbPath;
@property (nonatomic) sqlite3 *database;
@property (nonatomic) sqlite3_stmt *sqlStatement;
@property (retain, nonatomic) FMDatabase *db;

/*
 * USERS
 */
- (void) insertUser: (User *) user;
- (User *) getUserWithId: (NSString *) idUser;
- (User *) getUserWithEmail: (NSString *) email;
- (void) updateUser: (User *) user;

/*
 * AREAS
 */

- (void) insertArea: (Area *) area;
- (NSArray *) getAreas: (CLLocation *)location andRadius: (int) radius;

/*
 * DOGS
 */

- (void) insertDogsWith: (NSArray *) dogs andIdUser:(NSString *) idUser;
- (NSArray *) getUserDogs: (NSString *) idUser;
- (void) editDog: (Dog *) dog;
- (void) addDogWith: (Dog *) dog andUser:(NSString *) idUser;
- (void) removeDog: (Dog *) dog;

/*
 * CHECKINS
 */

-(void) insertCheckinWith:(NSString *) idArea andIdUser:(NSString *) idUser andIdDog:(NSString *) idDog andDate:(NSString *) date;
-(int) getUserNCheckins:(NSString *) idUser;

@end
