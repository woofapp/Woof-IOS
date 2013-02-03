//
//  Commands.h
//  Woof
//
//  Created by Mattia Campana on 03/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const COMMAND_REPORT_AREA = @"newArea";
static NSString* const COMMAND_CHECK_AREAS = @"checkAreas";
static NSString* const COMMAND_GET_AREAS = @"getAreas";
static NSString* const COMMAND_GET_AREA_DETAILS = @"getAreaDetails";
static NSString* const COMMAND_GET_COMMENTS = @"getComments";
static NSString* const COMMAND_GET_CHECKINS_DETAIL = @"getCheckinsDetail";
static NSString* const COMMAND_GET_OTHER_CHECKINS_DETAILS = @"getOthersCheckinsDetail";
static NSString* const COMMAND_GET_LAST_N_FRIENDS_CHECKINS = @"getLastNFriendsCheckins";
static NSString* const COMMAND_GET_FRIENDS_CHECKINS_DETAILS = @"getFriendsCheckinsDetail";
static NSString* const COMMAND_SEND_COMMENT = @"sendComment";
static NSString* const COMMAND_GET_FRIENDS = @"getFriends";
static NSString* const COMMAND_GET_LAST_FRIEND_CHECKIN = @"getLastFriendCheckin";
static NSString* const COMMAND_REGISTER_USER = @"registerUser";
static NSString* const COMMAND_USER_LOGIN = @"userLogin";
static NSString* const COMMAND_SEND_RATING = @"sendRating";
static NSString* const COMMAND_CHECK_USER_RATING = @"checkUserRating";
static NSString* const COMMAND_UPDATE_AREA = @"updateArea";
static NSString* const COMMAND_REMOVE_FRIEND = @"removeFriend";
static NSString* const COMMAND_REMOVE_DOG = @"removeDog";
static NSString* const COMMAND_SEARCH_USER = @"searchUser";
static NSString* const COMMAND_ADD_FRIEND = @"addFriend";
static NSString* const COMMAND_UPDATE_DOG = @"updateDog";
static NSString* const COMMAND_UPDATE_USER = @"updateUser";
static NSString* const COMMAND_ADD_DOG = @"addDog";
static NSString* const COMMAND_IS_USER_REGISTERED = @"isUserRegistered";
static NSString* const COMMAND_REGISTER_FB_USER = @"registerFBUser";
static NSString* const COMMAND_RESTORE_PASSWORD = @"restorePassword";
static NSString* const COMMAND_FB_USER_LOGIN = @"fbUserLogin";
static NSString* const COMMAND_GET_USER_INFO = @"getUserInfo";
static NSString* const COMMAND_GET_USER_N_CHECKINS = @"getUserCheckins";
static NSString* const COMMAND_GET_LAST_N_COMMENTS = @"getLastNComments";
static NSString* const COMMAND_GET_UPDATE_AREA_INFO = @"getUpdateAreaInfo";
static NSString* const COMMAND_GET_USER_RATING = @"getUserRating";
static NSString* const COMMAND_ADD_CHECKIN = @"addCheckin";
static NSString* const COMMAND_GET_LAST_AREA_IMAGE = @"getLastAreaImage";
static NSString* const COMMAND_GET_AREA_IMAGES = @"getAreaImages";
static NSString* const COMMAND_GET_IMAGE = @"getImage";
