//
//  CustomMKAnnotationView.h
//  Woof
//
//  Created by Mattia Campana on 08/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Area.h"
#import "CustomCalloutViewController.h"

@interface CustomMKAnnotationView : MKAnnotationView

@property (retain, nonatomic) UIView *myMap;
@property (retain, nonatomic) CustomCalloutViewController *myAVC;
@property (retain, nonatomic) UIView *myAnnotationView;
@property (retain, nonatomic) Area *myArea;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
