//
//  ReportArea.h
//  Woof
//
//  Created by Mattia Campana on 02/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Area.h"
#import "DLStarRatingControl.h"

@interface ReportArea : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DLStarRatingDelegate>


@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;
@property (retain, nonatomic) CLLocation *userLocation;
@property (retain, nonatomic) CLLocation *searchedLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) Area *area;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@property (weak, nonatomic) IBOutlet UITextField *mapAddressSelectedTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressSelectedTextField;
@property (weak, nonatomic) IBOutlet UIView *selectImageMessageContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (nonatomic) int userRatingChoice;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


- (IBAction)sendArea:(id)sender;

- (IBAction)hideSendRating:(id)sender;


/*
 * GESTIONE SELEZIONE IMMAGINE DA GALLERY E CAMERA
 */
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (nonatomic, retain) UIImagePickerController *picker;

- (IBAction)takePhotoOrChooseFromLibrary;


- (IBAction)hideMap:(id)sender;
- (IBAction)getCurrentAddress:(id)sender;
- (IBAction)showMap:(id)sender;
- (IBAction)goToHome:(id)sender;

@end
