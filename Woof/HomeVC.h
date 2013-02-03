//
//  HomeVC.h
//  Woof
//
//  Created by Mattia Campana on 26/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationController.h"

@interface HomeVC : UIViewController <LocationControllerDelegate>

@property (weak, nonatomic) LocationController *locationController;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *wellcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportAreaLabel;

@property (atomic) BOOL locationUpdateLock;

@end
