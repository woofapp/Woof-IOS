//
//  CustomCalloutViewController.m
//  Woof
//
//  Created by Mattia Campana on 09/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "CustomCalloutViewController.h"

@interface CustomCalloutViewController ()

@end

@implementation CustomCalloutViewController
@synthesize myAreaNameLabel;
@synthesize myDistanceLabel;
@synthesize ratingImage;
@synthesize nRatingLabel;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMyAreaNameLabel:nil];
    [self setMyDistanceLabel:nil];
    [self setRatingImage:nil];
    [self setNRatingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
