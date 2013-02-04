//
//  ReportArea.m
//  Woof
//
//  Created by Mattia Campana on 02/02/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "ReportArea.h"
#import "SearchedLocationPoint.h"
#import "ImageUtility.h"
#import "UIEffects.h"

@interface ReportArea ()

@end

@implementation ReportArea

@synthesize userLocation,searchedLocation, area, geoCoder;
@synthesize mapViewContainer, mapView, mapAddressSelectedTextField, addressSelectedTextField, selectImageMessageContainer, ratingImageView, userRatingChoice, ratingView, commentTextView;

//Selezione immagine
@synthesize picker, selectedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectImageMessageContainer.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha:0.5];
	
    area = [[Area alloc]init];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [recognizer setNumberOfTapsRequired:1];
    [mapView addGestureRecognizer:recognizer];
    geoCoder = [[CLGeocoder alloc] init];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    //Set touch event
    UITapGestureRecognizer *ratingImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendRating)];
    [ratingImageViewTap setNumberOfTouchesRequired:1];
    [ratingImageViewTap setNumberOfTapsRequired:1];
    [ratingImageViewTap setDelegate:self];
    [ratingImageView addGestureRecognizer:ratingImageViewTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated{
    [mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if(self.userLocation == NULL || [userLocation distanceFromLocation:mapView.userLocation.location] >= 500){
        userLocation = mapView.userLocation.location;
        [self mapZoomInLocation:userLocation];
    }
}

- (void) mapZoomInLocation: (CLLocation *)location{
    MKCoordinateRegion region;
    region.center = location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.001;
    span.longitudeDelta = 0.001;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
}

- (void)addPin:(UITapGestureRecognizer*)recognizer
{
    CGPoint tappedPoint = [recognizer locationInView:mapView];
    CLLocationCoordinate2D coord= [mapView convertPoint:tappedPoint toCoordinateFromView:mapView];
    
    SearchedLocationPoint *slp = [[SearchedLocationPoint alloc]init];
    slp.coordinate = coord;
    
    NSArray *annotations = [mapView annotations];
    for(int i=0; i<[annotations count]; i++){
        if([annotations[i] isKindOfClass:[SearchedLocationPoint class]]){
            SearchedLocationPoint *slp2 = annotations[i];
            [mapView removeAnnotation:slp2];
        }
    }
    
    searchedLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    [mapView addAnnotation:slp];
    
    [self getAddressFromLocation:searchedLocation];
    area.coordinate = coord;
}

/*
 * REVERSE GEOCODING
 */

-(void) getAddressFromLocation: (CLLocation *)location{
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //ottieni l'indirizzo più vicino
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        //String to hold address
        NSString *address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        mapAddressSelectedTextField.text = address;
        addressSelectedTextField.text = address;
        area.myAddress = address;
    }];
}

- (IBAction)goToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [ImageUtility resizeImage:image];
    
    selectedImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectImageFromGallery{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)selectImageFromCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     switch (buttonIndex) {
         case 0: [self selectImageFromGallery];
             break;
         case 1: [self selectImageFromCamera];
             break;
     }

}

/*
 * GESTIONE RATING POPUP
 */

-(void)showSendRating{
    [UIEffects fadeIn:ratingView withDuration:1 andWait:0];
}

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
    userRatingChoice = rating;
}

- (IBAction)takePhotoOrChooseFromLibrary{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancella" destructiveButtonTitle:nil otherButtonTitles:@"Preleva da galleria", @"Scatta una foto", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];

}

- (IBAction)hideMap:(id)sender {
    [UIEffects fadeOut:mapViewContainer withDuration:1 andWait:0];
}

- (IBAction)getCurrentAddress:(id)sender {
    [self getAddressFromLocation:userLocation];
}

- (IBAction)showMap:(id)sender {
    [UIEffects fadeIn:mapViewContainer withDuration:1 andWait:0];
}

- (IBAction)hideSendRating:(id)sender {
    [UIEffects fadeOut:ratingView withDuration:1 andWait:0];
}

- (IBAction)sendArea:(id)sender {
    if([addressSelectedTextField.text length] == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"La posizione dell'area è obbligatoria!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    
    NSString *address = addressSelectedTextField.text;
    CLLocationCoordinate2D coordinates = searchedLocation.coordinate;
    int rating = userRatingChoice;
    NSString *comment = commentTextView.text;
    NSString *image = [ImageUtility compressAndEncodeImage:selectedImage.image];
}


@end
