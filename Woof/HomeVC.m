//
//  HomeVC.m
//  Woof
//
//  Created by Mattia Campana on 26/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "HomeVC.h"
#import "WeatherManager.h"

@interface HomeVC ()

@end

@implementation HomeVC

@synthesize positionLabel, wellcomeLabel, titleLabel, weatherIconImageView, searchAreaLabel, profileLabel, friendsLabel, reportAreaLabel;
@synthesize locationController, locationUpdateLock;

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
    locationUpdateLock = NO;
	[self setFonts];
}

- (void) viewDidAppear:(BOOL)animated{
    self.locationController = [LocationController sharedLocationController];
    [locationController startLookingForLocation];
    locationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFonts{
    
    [searchAreaLabel setFont:[UIFont fontWithName:@"Opificio" size:15]];
    [profileLabel setFont:[UIFont fontWithName:@"Opificio" size:15]];
    [friendsLabel setFont:[UIFont fontWithName:@"Opificio" size:15]];
    [reportAreaLabel setFont:[UIFont fontWithName:@"Opificio" size:15]];
    [titleLabel setFont:[UIFont fontWithName:@"Opificio" size:30]];
    [wellcomeLabel setFont:[UIFont fontWithName:@"Opificio" size:15]];
    [positionLabel setFont:[UIFont fontWithName:@"Opificio" size:13]];
    
    
}

/**
 * Implementazione metodo per rimanere in ascolto del cambio di posizione
 **/
-(void) locationControllerDidUpdateLocation:(CLLocation *)location{
    if(location != NULL && !locationUpdateLock){
        locationUpdateLock = YES;
        [self performSelectorInBackground:@selector(downloadWeatherWith:) withObject:location];
    }
}

//Metodo per scaricare le informazioni meteo
- (void) downloadWeatherWith: (CLLocation*) location{
    NSDictionary *data = [WeatherManager getCurrentWeatherFrom:location];
    [self performSelectorOnMainThread:@selector(downloadWeatherCompletedWithData:) withObject:data waitUntilDone:NO];
    
}

-(void) downloadWeatherCompletedWithData: (NSDictionary*) data{
    locationUpdateLock = NO;
    UIImage *weatherIcon = [UIImage imageNamed: [data objectForKey:@"weatherIcon"]];
    
    [self.weatherIconImageView setImage:weatherIcon];
    
    NSMutableString *weatherInfo = [[NSMutableString alloc]initWithString:[data objectForKey:@"weatherLocation"]];
    
    [weatherInfo appendString:@", "];
    [weatherInfo appendString:[data objectForKey:@"weatherTemp"]];
    [weatherInfo appendString:@"°C"];
    
    [self.positionLabel setText:weatherInfo];
}

@end
