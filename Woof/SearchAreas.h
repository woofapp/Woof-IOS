//
//  SearchAreas.h
//  Woof
//
//  Created by Mattia Campana on 26/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Area.h"

@interface SearchAreas : UIViewController <MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (retain, nonatomic) NSArray *pickerViewArray;
@property (weak, nonatomic) IBOutlet UIButton *radiusButton;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *closePickerButton;
@property (weak, nonatomic) IBOutlet UISearchBar *sBar;
@property (weak, nonatomic) IBOutlet UITableView *tblView;


@property (retain, nonatomic) NSMutableArray *areas;
@property (retain, nonatomic) CLLocation *userLocation;
@property (retain, nonatomic) NSString *selectedRadiusString;
@property int selectedRadius;
@property (retain, nonatomic) CLLocation *searchedLocation;
@property (retain, nonatomic) NSMutableDictionary *lastAreaImageCache;
@property (retain, nonatomic) Area *selectedArea;


- (IBAction)goToHome:(id)sender;
- (IBAction)switchView:(id)sender;
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
- (IBAction)radiusButtonClicked:(id)sender;
- (IBAction)closePickerButtonClicked:(id)sender;


@end
