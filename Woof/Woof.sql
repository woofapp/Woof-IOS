DROP TABLE IF EXISTS "areas";
CREATE TABLE "areas" ("idArea" INTEGER PRIMARY KEY  NOT NULL ,"address" TEXT NOT NULL ,"latitude" REAL NOT NULL ,"longitude" REAL NOT NULL ,"image" TEXT,"version" INTEGER NOT NULL );
DROP TABLE IF EXISTS "checkins";
CREATE TABLE "checkins" ("idArea" INTEGER NOT NULL , "idUser" INTEGER NOT NULL , "idDog" INTEGER NOT NULL , "date" TEXT NOT NULL , PRIMARY KEY ("idArea", "idUser", "idDog"));
DROP TABLE IF EXISTS "dogs";
CREATE TABLE "dogs" ("idDog" INTEGER PRIMARY KEY  NOT NULL  UNIQUE , "idUser" INTEGER NOT NULL , "name" TEXT NOT NULL , "race" TEXT NOT NULL , "year" INTEGER NOT NULL , "image" TEXT);
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" ("idUser" INTEGER PRIMARY KEY  NOT NULL ,"email" TEXT NOT NULL ,"name" TEXT NOT NULL ,"surname" TEXT NOT NULL ,"city" TEXT NOT NULL , "image" TEXT);
