//
//  AreaDetails.h
//  Woof
//
//  Created by Mattia Campana on 29/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"
#import "DLStarRatingControl.h"

@interface AreaDetails : UIViewController <UITableViewDelegate, UITableViewDataSource, DLStarRatingDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (retain, nonatomic) Area *area;
@property (retain, nonatomic) NSMutableArray *areaImagesIds;
@property (retain, nonatomic) IBOutlet UITableView *miniGallery;
@property (retain, nonatomic) NSMutableDictionary *miniGalleryCache;
@property (weak, nonatomic) IBOutlet UIView *scrollImageMessageView;
@property (weak, nonatomic) IBOutlet UILabel *scrollImageMessage;
@property (weak, nonatomic) NSMutableString *galleryMessage;
@property (weak, nonatomic) IBOutlet UILabel *areaAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCheckinLabel;
@property (weak, nonatomic) IBOutlet UIView *noImageMessageContainer;
@property (weak, nonatomic) IBOutlet UIView *commentContainer1;
@property (weak, nonatomic) IBOutlet UIView *commentContainer2;
@property (weak, nonatomic) IBOutlet UIView *commentsControlMenu;
@property (weak, nonatomic) IBOutlet UILabel *noCommentsMessage;

//Comments
@property (weak, nonatomic) IBOutlet UILabel *userNameSurname1;
@property (weak, nonatomic) IBOutlet UIImageView *userImage1;
@property (weak, nonatomic) IBOutlet UILabel *commentDate1;
@property (weak, nonatomic) IBOutlet UILabel *userComment1;
@property (weak, nonatomic) IBOutlet UILabel *userNameSurname2;
@property (weak, nonatomic) IBOutlet UIImageView *userImage2;
@property (weak, nonatomic) IBOutlet UILabel *commentDate2;
@property (weak, nonatomic) IBOutlet UILabel *userComment2;


//Rating
@property (weak, nonatomic) IBOutlet UIView *ratingBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *starsContainer;
@property (nonatomic) int userRatingChoice;


- (IBAction)sendRating:(id)sender;
- (IBAction)hideSendRating:(id)sender;
- (IBAction)goToSearchArea:(id)sender;
- (IBAction)goToHome:(id)sender;
- (IBAction)openMap:(id)sender;

@end
