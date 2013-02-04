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
@synthesize areasArray, sortedAreasArray;

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
        
        [sharedDatabase.db setLogsErrors:TRUE];
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
    
    NSMutableString *query;
    
    //Controllo se l'utente esiste già, nel caso lo elimino
    query = [[NSMutableString alloc]initWithFormat:@"SELECT idUser FROM users WHERE idUser = %d", [user.idUser intValue]];
    
    FMResultSet *s = [db executeQuery:query];
    
    if(s != NULL){
        query = [[NSMutableString alloc]initWithFormat:@"DELETE FROM users WHERE idUser = %d", [user.idUser intValue]];
        [db executeUpdate:query];
    }
    
    //Inserisco nuovo utente
    query = [[NSMutableString alloc]initWithFormat:@"INSERT INTO users (idUser, email, name, surname, city, image) VALUES(%@,'%@','%@','%@',", user.idUser, user.email, user.name, user.surname];
    
    if(user.city != nil) [query appendFormat:@"'%@',",user.city];
    else [query appendFormat:@"%@,",nil];
    
    if(user.image != nil) [query appendFormat:@"'%@'",user.image];
    else [query appendFormat:@"%@",nil];
    
    [query appendString:@")"];
    
    [db executeUpdate:query];
    
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
    NSMutableString *query;
    
    //Se l'area è gia presente la elimino
    query = [[NSMutableString alloc]initWithFormat:@"SELECT idArea FROM areas WHERE idArea = %d", [area.myIdArea intValue]];
    
    FMResultSet *s = [db executeQuery:query];
    if(s != NULL){
        query = [[NSMutableString alloc]initWithFormat:@"DELETE FROM areas WHERE idArea = %d", [area.myIdArea intValue]];
        [db executeUpdate:query];
    }
    
    //Inserimento area
    query = [[NSMutableString alloc]initWithFormat:@"INSERT INTO areas (idArea, address, latitude, longitude, version, rating, nRating, image) VALUES(%@,'%@',%f,%f, %d, %f, %d,", area.myIdArea, area.myAddress, area.coordinate.latitude, area.coordinate.longitude, area.version, area.myRating, area.myNRating];
    
    if(area.myImages != nil && [area.myImages count] != 0) [query appendFormat:@"'%@'",[area.myImages objectAtIndex:0]];
    else [query appendFormat:@"%@",nil];
    
    [query appendString:@")"];
    
    if([area.myComments count] != 0){
        //Inserisco utente
        Comment *comment = area.myComments[0];
        [self insertUser:comment.user];
        [self insertComment:comment forArea:area.myIdArea];
    }
    
    [db executeUpdate:query];
}

- (NSMutableArray *) getAreas: (CLLocation *)location andRadius: (int) radius{
    
    FMResultSet *rs = [db executeQuery:@"SELECT * from areas"];
    areasArray = [[NSMutableArray alloc]init];
    while([rs next]){
        
        double lat = [rs doubleForColumn:@"latitude"];
        double lon = [rs doubleForColumn:@"longitude"];
        
        CLLocation *coord = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        
        CLLocationDistance distance = [location distanceFromLocation:coord];
        
        if(distance <= radius){
            
            Area *area = [[Area alloc]init];
            
            area.myIdArea = [rs stringForColumn:@"idArea"];
            area.myAddress = [rs stringForColumn:@"address"];
            area.version = [rs intForColumn:@"version"];
            area.myRating = [rs doubleForColumn:@"rating"];
            area.myNRating = [rs intForColumn:@"nRating"];
            
            area.coordinate = coord.coordinate;
            
            NSString *img = [rs stringForColumn:@"image"];
            area.myImages = [[NSArray alloc] initWithObjects:img, nil];
            
            area.myDistance = distance;
            
            //Ultimo commento
            Comment *comment = [self getComment:area.myIdArea];
            if(comment != nil){
                NSArray *commentArray = [[NSArray alloc]initWithObjects:comment, nil];
                area.myComments = commentArray;
            }
            
            [areasArray addObject:area];
        }
    }
    
    sortedAreasArray = [[NSArray alloc]init];
    sortedAreasArray = [areasArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:sortedAreasArray];
    
    return arr;
}

/*
 * IMAGES
 */
- (void) insertLastImage: (NSString *)image forArea: (int)idArea{
    if(image != NULL){
        NSMutableString *query = [[NSMutableString alloc]initWithFormat:@"UPDATE areas SET image = '%@' WHERE idArea = %d", image, idArea];
    
        [db executeUpdate:query];
    }
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
<<<<<<< HEAD
}

/*
 * COMMENTS
 */
-(void) insertComment:(Comment*)comment forArea: (NSString *)idArea{
    
    NSMutableString *query;
    
    //Controllo se il commento esiste già, nel caso lo elimino
    query = [[NSMutableString alloc]initWithFormat:@"SELECT idComment FROM comments WHERE idUser = %d AND idArea = %d AND comment = '%@' AND date = '%@'", [comment.user.idUser intValue], [idArea intValue], comment.text, comment.date];
    
    FMResultSet *s = [db executeQuery:query];
    
    if(s != NULL){
        int idComment = [s intForColumn:@"idComment"];
        query = [[NSMutableString alloc]initWithFormat:@"DELETE FROM comments WHERE idComment = %d", idComment];
        [db executeUpdate:query];
    }
    
    
    query = [[NSMutableString alloc]initWithFormat:@"INSERT INTO comments (idUser, idArea, comment, date) VALUES(%@, %@, '%@', '%@')", comment.user.idUser, idArea, comment.text, comment.date];
    [db executeUpdate:query];
=======
>>>>>>> niko
}

-(Comment *)getComment:(NSString *)idArea{
    
    NSMutableString *selectSQL = [[NSMutableString alloc]initWithFormat:@"SELECT idUser,comment,date FROM comments WHERE idArea = %@", idArea];
    FMResultSet *rs = [db executeQuery:selectSQL];
    
    Comment *comment = nil;
    while([rs next]){
        
        comment = [[Comment alloc]init];
        
        comment.user = [self getUserWithId:[rs stringForColumn:@"idUser"]];
        comment.text = [rs stringForColumn:@"comment"];
        comment.date = [rs stringForColumn:@"date"];
    }
    
    return comment;
}


@end
