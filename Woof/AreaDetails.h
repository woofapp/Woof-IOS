//
//  AreaDetails.h
//  Woof
//
//  Created by Mattia Campana on 29/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"

@interface AreaDetails : UIViewController <UITableViewDelegate, UITableViewDataSource>

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


- (IBAction)goToSearchArea:(id)sender;
- (IBAction)goToHome:(id)sender;
- (IBAction)openMap:(id)sender;

@end
