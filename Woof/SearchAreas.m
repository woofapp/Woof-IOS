//
//  SearchAreas.m
//  Woof
//
//  Created by Mattia Campana on 26/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "SearchAreas.h"
#import "AreaManager.h"
#import "SearchedLocationPoint.h"
#import "CustomMKAnnotationView.h"
#import "AreaCell.h"
#import "Comment.h"
#import "AreaDetails.h"

@interface SearchAreas ()

@end

@implementation SearchAreas

@synthesize mapView, mapViewContainer, tableViewContainer, picker, radiusButton, closePickerButton, titleLabel, sBar, tblView;
@synthesize userLocation, areas, pickerViewArray, selectedRadiusString, selectedRadius, searchedLocation, lastAreaImageCache, selectedArea;

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
    
    [self.tblView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //find the UITextField view within searchBar (outlet to UISearchBar)
    //and assign self as delegate
    for (UIView *view in sBar.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }

    
    [titleLabel setFont:[UIFont fontWithName:@"Opificio" size:20]];
    
    NSArray *arr= [[NSArray alloc] initWithObjects:@"100m", @"500m", @"1 Km", nil];
    pickerViewArray = arr;
    selectedRadius = 500;
}

- (void)viewDidAppear:(BOOL)animated{
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated{
    [mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if(self.searchedLocation == NULL && (self.userLocation == NULL || [userLocation distanceFromLocation:mapView.userLocation.location] >= 500)){
        userLocation = mapView.userLocation.location;
        [self performSelectorInBackground:@selector(downloadAreasFrom:) withObject:userLocation];
    }    
}

-(void) downloadAreasFrom: (CLLocation *) location{
    
    searchedLocation = location;
    
    //controllo aree salvate in locale
    NSArray *areasAr = [AreaManager getAreasFromDB:location.coordinate.latitude andLongitude:location.coordinate.longitude andRadius:selectedRadius];
    
    if(![AreaManager checkAreas:areasAr inLocation:location andRadius:selectedRadius]){
        areasAr = [AreaManager getAreasFrom:location.coordinate.latitude andLongitude:location.coordinate.longitude andRadius:selectedRadius];
        
        //for(Area *area in areasAr)[AreaManager insertAreaInDB:area];
    }
    
    //visualizzo le aree trovate
    [self performSelectorOnMainThread:@selector(showAreas:) withObject:areasAr waitUntilDone:NO];
}

-(void) showAreas:(NSMutableArray*) downloadedAreas{
    //[self showLoad];
    if(areas != NULL) [mapView removeAnnotations:mapView.annotations];

    self.areas = downloadedAreas;
    
    [self.tblView reloadData];
    [self mapZoomInLocation:searchedLocation];
    
    
    /*
     *  Se la posizione cercata è diversa da quella corrente dell'utente, aggiungo l'annotation
     *  per far si che visualizzi il pin blu sulla mappa
     */
    CLLocationCoordinate2D searchedCoordinates = searchedLocation.coordinate;
    CLLocationCoordinate2D userCoordinates = mapView.userLocation.location.coordinate;
    
    if(searchedCoordinates.latitude != userCoordinates.latitude || searchedCoordinates.longitude != userCoordinates.longitude){
        
        SearchedLocationPoint *point = [[SearchedLocationPoint alloc]init];
        [point setCoordinate:searchedCoordinates];
        
        if(areas == NULL) areas = [[NSMutableArray alloc] init];
        [areas addObject:point];
    }

    [mapView addAnnotations:areas];
}

- (void) mapZoomInLocation: (CLLocation *)location{
    MKCoordinateRegion region;
    //region.center = self.mapView.userLocation.coordinate;
    region.center = location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.015; // circa come 1Km di raggio sulla mappa
    span.longitudeDelta = 0.015;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)switchView:(id)sender {
    if(tableViewContainer.alpha == 0){
        [self fadeOut:mapViewContainer withDuration:1 andWait:0];
        [self fadeIn:tableViewContainer withDuration:1 andWait:0];
        
    }else if(mapViewContainer.alpha == 0){
        [self fadeOut:tableViewContainer withDuration:1 andWait:0];
        [self fadeIn:mapViewContainer withDuration:1 andWait:0];
        
        [self mapZoomInLocation:searchedLocation];
    }
}

//effetto transizione di uscita
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}

//effetto transizione di entrata
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}

/*
 * Creazione annotazioni (pin sulla mappa)
 * NOTA: ricordarsi di settare il delegate della mappa a SearchAreas (tramite storyboard)
 */
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[Area class]]) {
        
        CustomMKAnnotationView *annotationView = (CustomMKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[CustomMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        [annotationView setMyArea:annotation];
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        annotationView.image=[UIImage imageNamed:@"area_overlay@2.png"];
        
        [annotationView setMyMap:_mapView];
        
        return annotationView;
        
    }else if([annotation isKindOfClass:[SearchedLocationPoint class]]){
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"searchedPoint"];
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        annotationView.image=[UIImage imageNamed:@"mypos_overlay@2.png"];
        
        return annotationView;
        
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mv annotationView:(MKAnnotationView *)pin calloutAccessoryControlTapped:(UIControl *)control {}

//animazione per le annotation
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.5
                         animations:^{ annView.frame = endFrame; }];
    }
}

/*
 * Gestione Picker
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerViewArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedRadiusString = [pickerViewArray objectAtIndex:row];
}

- (IBAction)radiusButtonClicked:(id)sender {
    [self fadeIn:closePickerButton withDuration:1 andWait:0];
    [self fadeIn:picker withDuration:1 andWait:0];
}

//Chiusura del picker e aggiornamento della scelta
- (IBAction)closePickerButtonClicked:(id)sender {
    [self fadeOut:closePickerButton withDuration:1 andWait:0];
    [self fadeOut:picker withDuration:1 andWait:0];
    
    if(selectedRadiusString == NULL) selectedRadiusString = @"100m";
    [radiusButton setTitle:selectedRadiusString forState:UIControlStateNormal];
    
    [self upgradeRadius];
}

//Aggiornamento raggio selezionato e download aree
- (void)upgradeRadius{
    //Conversione stringa in intero
    if([selectedRadiusString isEqualToString:@"100m"]) selectedRadius = 100;
    else if ([selectedRadiusString isEqualToString:@"500m"]) selectedRadius = 500;
    else if ([selectedRadiusString isEqualToString:@"1 Km"]) selectedRadius = 1000;
    
    //Download aree col nuovo raggio
    CLLocation *loc;
    if(searchedLocation != NULL) loc = searchedLocation;
    else loc = userLocation;
    [self performSelectorInBackground:@selector(downloadAreasFrom:) withObject:loc];
}

/*
 * GESTIONE TABLE VIEW
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    lastAreaImageCache = [[NSMutableDictionary alloc]init];
    return [areas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:nil options:nil];
        
        for (UIView *view in views)
            if([view isKindOfClass:[UITableViewCell class]]) cell = (AreaCell*)view;
    }
    
    //Recupero le informazioni dell'area
    int itemIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    Area *area = [areas objectAtIndex:itemIndex];
    
    [cell populateWith:area andImageCache:lastAreaImageCache];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
    
    int itemIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    selectedArea = [areas objectAtIndex:itemIndex];;
    
    [self performSegueWithIdentifier:@"areaDetailsSegue" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[areas objectAtIndex:[indexPath indexAtPosition:[indexPath length] -1]] myComments] count] == 0 ) return 140;
    return 224;
}

-(void) editDone{
    [self.tblView reloadData];
}

/*
 * GESTIONE SEARCHBAR
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    [self getPositionFrom:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    searchedLocation = NULL;
    [self performSelectorInBackground:@selector(downloadAreasFrom:) withObject:userLocation];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.sBar afterDelay:0.001];
    return YES;
}

/*
 * REVERSE GEOCODING
 */
- (void)getPositionFrom: (NSString *)address{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if([placemarks count] > 0){
                         CLPlacemark *placemark = [placemarks objectAtIndex:0];
                         [self performSelectorInBackground:@selector(downloadAreasFrom:) withObject:placemark.location];
                     }
                 }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"areaDetailsSegue"]) {
        
        // Get destination view
        AreaDetails *vc = [segue destinationViewController];
        
        // Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        [vc setArea:selectedArea];
    }
}

@end
