//
//  Database.m
//  Woof
//
//  Created by Mattia Campana on 12/10/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "Database.h"
#import "FMDatabaseAdditions.h"

@implementation Database

@synthesize dbPath, database, sqlStatement,db;

+ (Database *)sharedDatabase
{
    static Database *sharedDatabase = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        sharedDatabase = [[self alloc] init];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *sqlPath = [documentsDirectory stringByAppendingPathComponent:@"Woof.sqlite"];
        
        if ([fileManager fileExistsAtPath:sqlPath] == NO) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"Woof" ofType:@"sqlite"];
            [fileManager copyItemAtPath:resourcePath toPath:sqlPath error:&error];
        }
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Woof.sqlite"];
        sharedDatabase.db = [FMDatabase databaseWithPath:path];
        
        [sharedDatabase.db setLogsErrors:FALSE];
        [sharedDatabase.db setTraceExecution:FALSE];
        
        if(![sharedDatabase.db open]){
            NSLog(@"Errore apertura db!");
            sharedDatabase = nil;
        }else{
            NSLog(@"DB Aperto!");
        }
        
        
    });
    
    return sharedDatabase;
}

/*
 * USERS
 */
- (void) insertUser: (User *) user{
    
    NSMutableString *insertSQL = [[NSMutableString alloc]initWithFormat:@"INSERT INTO users (idUser, email, name, surname, city, image) VALUES(%@,'%@','%@','%@',", user.idUser, user.email, user.name, user.surname];
    
    if(user.city != nil)
        [insertSQL appendFormat:@"'%@',",user.city];
    else
        [insertSQL appendFormat:@"%@,",nil];
    
    if(user.image != nil)
        [insertSQL appendFormat:@"'%@'",user.image];
    else
        [insertSQL appendFormat:@"%@",nil];
    
    [insertSQL appendString:@")"];
    
    [db executeUpdate:insertSQL];
    
}

- (User *) getUserWithId: (NSString *) idUser{
    
    User *user = nil;
    
    FMResultSet *rs = [db executeQuery:@"SELECT * from users WHERE idUser = ?",idUser];
    
    while([rs next]){
        user = [[User alloc]init];
        
        user.idUser = idUser;
        user.email = [rs stringForColumn:@"email"];
        user.name = [rs stringForColumn:@"name"];
        user.surname = [rs stringForColumn:@"surname"];
        user.city = [rs stringForColumn:@"city"];
        user.image = [rs stringForColumn:@"image"];
    }
    
    return user;
}

- (User *) getUserWithEmail: (NSString *) email{
    User *user = nil;
    
    FMResultSet *rs = [db executeQuery:@"SELECT * from users WHERE email = ?",email];
    
    while([rs next]){
        user = [[User alloc]init];
        
        user.idUser = [rs stringForColumn:@"iduser"];
        user.email = email;
        user.name = [rs stringForColumn:@"name"];
        user.surname = [rs stringForColumn:@"surname"];
        user.city = [rs stringForColumn:@"city"];
        user.image = [rs stringForColumn:@"image"];
    }
    
    return user;
}

- (void) updateUser: (User *) user{
    
    [db executeUpdate:@"UPDATE users SET email = ?, name = ?, surname = ?, city = ?, image = ? WHERE idUser = ?",user.email,user.name,user.surname,user.city,user.image,user.idUser];
    
}

/*
 * AREAS
 */

- (void) insertArea: (Area *) area{
    
    NSMutableString *insertSQL = [[NSMutableString alloc]initWithFormat:@"INSERT INTO areas (idArea, address, latitude, longitude, version, image) VALUES(%@,'%@','%f',%f, %d,", area.myIdArea, area.myAddress, area.coordinate.latitude, area.coordinate.longitude, area.version];
    
    if(area.myImages != nil && [area.myImages count] != 0)
        [insertSQL appendFormat:@"'%@'",[area.myImages objectAtIndex:0]];
    else
        [insertSQL appendFormat:@"%@",nil];
    
    [insertSQL appendString:@")"];
    
    [db executeUpdate:insertSQL];
}

- (NSArray *) getAreas: (CLLocation *)location andRadius: (int) radius{
    
    NSMutableArray *areaArray = nil;
    
    FMResultSet *rs = [db executeQuery:@"SELECT * from areas"];
    
    while([rs next]){
        
        double lat = [rs doubleForColumn:@"latitude"];
        double lon = [rs doubleForColumn:@"longitude"];
        
        CLLocation *coord = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        
        CLLocationDistance distance = [location distanceFromLocation:coord];
        
        if(distance <= radius){
            
            if(areaArray == nil)
                areaArray = [[NSMutableArray alloc]init];
            
            Area *area = [[Area alloc]init];
            
            area.myIdArea = [rs stringForColumn:@"idArea"];
            area.myAddress = [rs stringForColumn:@"address"];
            area.version = [rs intForColumn:@"version"];
            area.coordinate = coord.coordinate;
            
            NSString *img = [rs stringForColumn:@"image"];
            area.myImages = [[NSArray alloc] initWithObjects:img, nil];
            
            [areaArray addObject:area];
        }
    }
    
    return areaArray;
}

/*
 * DOGS
 */

- (void) insertDogsWith: (NSArray *) dogs andIdUser:(NSString *) idUser{
    for (Dog *dog in dogs) {
        [self addDogWith:dog andUser:idUser];
    }
}

- (NSArray *) getUserDogs: (NSString *) idUser{
    NSMutableArray *dogArray = nil;
    
    NSMutableString *selectSQL = [[NSMutableString alloc]initWithFormat:@"SELECT * FROM dogs WHERE idUser = %@)", idUser];
    FMResultSet *rs = [db executeQuery:selectSQL];
    
    while([rs next]){
        Dog *dog = [[Dog alloc]init];
        
        dog.idDog = [rs stringForColumn:@"idDog"];
        dog.name = [rs stringForColumn:@"name"];
        dog.race = [rs stringForColumn:@"race"];
        dog.year = [rs intForColumn:@"year"];
        dog.name = [rs stringForColumn:@"name"];
        dog.image = [rs stringForColumn:@"image"];

        [dogArray addObject:dog];        
    }
    
    return dogArray;
}

- (void) editDog: (Dog *) dog{
    [db executeUpdate:@"UPDATE dogs SET name = ?, race = ?, year = ?, image = ? WHERE idUser = ?",dog.name, dog.race, dog.year, dog.image];
}

- (void) addDogWith: (Dog *) dog andUser:(NSString *) idUser{
    NSMutableString *insertSQL = [[NSMutableString alloc]initWithFormat:@"INSERT INTO dogs (idDog, idUser, name, race, year, image) VALUES(%@, %@,'%@', '%@', %d, ", dog.idDog, idUser, dog.name, dog.race, dog.year];
    
    if(dog.image != nil)
        [insertSQL appendFormat:@"'%@'",dog.image];
    else
        [insertSQL appendFormat:@"%@",nil];
    
    [insertSQL appendString:@")"];
    
    [db executeUpdate:insertSQL];
}

- (void) removeDog: (Dog *) dog{
    [db executeQuery:@"DELETE FROM dogs WHERE idDog=?", dog.idDog];
}

/*
 * CHECKINS
 */

-(void) insertCheckinWith:(NSString *) idArea andIdUser:(NSString *) idUser andIdDog:(NSString *) idDog andDate:(NSString *) date{
    NSMutableString *insertSQL = [[NSMutableString alloc]initWithFormat:@"INSERT INTO checkins (idArea, idUser, idDog, date) VALUES(%@, %@, %@, '%@')", idArea, idUser, idDog, date];
    
    [db executeUpdate:insertSQL];
}

-(int) getUserNCheckins:(NSString *) idUser{
    NSMutableString *selectSQL = [[NSMutableString alloc]initWithFormat:@"SELECT COUNT(DISTINCT(iduser || date || idarea)) AS count FROM checkins WHERE idUser = %@", idUser];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    [rs next];
    return [rs intForColumn:@"count"];
}
    

@end
