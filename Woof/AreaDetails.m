//
//  AreaDetails.m
//  Woof
//
//  Created by Mattia Campana on 29/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "AreaDetails.h"
#import "AreaManager.h"
#import "Base64.h"
#import "MiniGalleryCell.h"

@interface AreaDetails ()

@end

@implementation AreaDetails

@synthesize area, areaImagesIds, miniGalleryCache, galleryMessage;
@synthesize miniGallery, scrollImageMessageView, scrollImageMessage, areaAddressLabel, ratingImageView, nRatingLabel;

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
    
    [self performSelectorInBackground:@selector(downloadNumberOfImage:) withObject:[area myIdArea]];
    
    areaAddressLabel.text = [area myAddress];
    
    [self setImageRating:ceil([area myRating])];
    
    nRatingLabel.text = [NSString stringWithFormat:@"(%d)",[area myNRating]];
    
}

- (void)setImageRating: (int)rating{
    
    UIImage *noStars = [UIImage imageNamed: @"stars@2.png"];
    UIImage *stars1 = [UIImage imageNamed: @"stars1@2.png"];
    UIImage *stars2 = [UIImage imageNamed: @"stars2@2.png"];
    UIImage *stars3 = [UIImage imageNamed: @"stars3@2.png"];
    UIImage *stars4 = [UIImage imageNamed: @"stars4@2.png"];
    UIImage *stars5 = [UIImage imageNamed: @"stars5@2.png"];
    
    switch (rating) {
        case 0:
            [ratingImageView setImage:noStars];
            break;
            
        case 1:
            [ratingImageView setImage:stars1];
            break;
            
        case 2:
            [ratingImageView setImage:stars2];
            break;
            
        case 3:
            [ratingImageView setImage:stars3];
            break;
            
        case 4:
            [ratingImageView setImage:stars4];
            break;
            
        case 5:
            [ratingImageView setImage:stars5];
            break;
    }
}

- (void) viewDidAppear:(BOOL)animated{
}

-(void) viewDidDisappear:(BOOL)animated{
    miniGalleryCache = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) downloadNumberOfImage: (NSString *)idArea{
    NSMutableArray *imagesIds = [AreaManager getAreaImages:[idArea intValue]];
    [self performSelectorOnMainThread:@selector(downloadedIds:) withObject:imagesIds waitUntilDone:NO];
}

-(void) downloadedIds: (NSMutableArray *)imagesIds{
    areaImagesIds = imagesIds;
    if([areaImagesIds count] >= 1){
        scrollImageMessageView.alpha = 1;
        galleryMessage = [NSMutableString stringWithFormat:@"Foto 1/%d",[areaImagesIds count]];
        scrollImageMessage.text = galleryMessage;
        scrollImageMessageView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha:0.5];
    }
    [miniGallery reloadData];
}

/*
 * GESTIONE TABLE VIEW
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    miniGalleryCache = [[NSMutableDictionary alloc]init];
    return [areaImagesIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"miniGalleryCell";
    
    MiniGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"MiniGalleryCell" owner:nil options:nil];
        
        for (UIView *view in views)
            if([view isKindOfClass:[UITableViewCell class]]) cell = (MiniGalleryCell*)view;
    }
    
    
    //Recupero le informazioni dell'area
    int index = [indexPath indexAtPosition: [indexPath length] - 1];

    galleryMessage = [NSMutableString stringWithFormat:@"Foto %d/%d",(index+1), [areaImagesIds count]];
    scrollImageMessage.text = galleryMessage;
    
    [cell populateWith:[[areaImagesIds objectAtIndex:index] intValue] andImageCache:miniGalleryCache];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
    
    int itemIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    //Area *area = [areas objectAtIndex:itemIndex];
    
    //selectedIdArea = [area myIdArea];
    
    //[self performSegueWithIdentifier:@"areaDetailsSegue" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 170;
}

- (IBAction)goToSearchArea:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)openMap:(id)sender {
    
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:[area coordinate] addressDictionary:nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = @"Area cani";
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}
@end
