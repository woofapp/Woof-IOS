//
//  CustomMKAnnotationView.m
//  Woof
//
//  Created by Mattia Campana on 08/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "CustomMKAnnotationView.h"
#import <math.h>

@implementation CustomMKAnnotationView

@synthesize myAnnotationView;
@synthesize myMap;
@synthesize myAVC;
@synthesize myArea;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        //caricamento della view per il callout
        myAVC = [[CustomCalloutViewController alloc]init];
        
        //setting dello sfondo della view di colore nero con trasparenza
        [myAVC view].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        //setto il nome dell'area
        [[myAVC myAreaNameLabel]setText:[myArea title]];
        
        //setto la distanza
        if (myArea.myDistance > 1000) {
            [[myAVC myDistanceLabel]setText:[NSString stringWithFormat:@"%.2f Km",myArea.myDistance/1000]];
        }else{
            [[myAVC myDistanceLabel]setText:[NSString stringWithFormat:@"%.2f m",myArea.myDistance]];
        }
        
        //setto l'immagine del rating
        int rating = ceil([myArea myRating]);
        
        UIImage *noStars = [UIImage imageNamed: @"stars@2.png"];
        UIImage *stars1 = [UIImage imageNamed: @"stars1@2.png"];
        UIImage *stars2 = [UIImage imageNamed: @"stars2@2.png"];
        UIImage *stars3 = [UIImage imageNamed: @"stars3@2.png"];
        UIImage *stars4 = [UIImage imageNamed: @"stars4@2.png"];
        UIImage *stars5 = [UIImage imageNamed: @"stars5@2.png"];
        
        switch (rating) {
            case 0:
                [[myAVC ratingImage] setImage:noStars];
                break;
                
            case 1:
                [[myAVC ratingImage] setImage:stars1];
                break;
                
            case 2:
                [[myAVC ratingImage] setImage:stars2];
                break;
                
            case 3:
                [[myAVC ratingImage] setImage:stars3];
                break;
                
            case 4:
                [[myAVC ratingImage] setImage:stars4];
                break;
                
            case 5:
                [[myAVC ratingImage] setImage:stars5];
                break;
        }
        
        //setto il numero di voti
        [[myAVC nRatingLabel]setText:[NSString stringWithFormat:@"(%d)",myArea.myNRating]];
        
        myAnnotationView = [myAVC view];
        
        //aggiungo la view del callout nella view contenitore
        [myMap addSubview:myAnnotationView];

        //imposto la posizione del callout nell'angolo in alto a sinistra della view contenitore
        CGRect myFrame =[myAnnotationView frame];
        myFrame.origin.x = 0.0;
        myFrame.origin.y = 0.0;
        
        [myAnnotationView setFrame:myFrame];
        
        //abilito l'interazione dell'utente sulla View che contiene il callout
        //e gli associo il riconoscitore di gesture per catturare il "push" sul callout
        //Quando viene clickato il callout viene richiamato il metodo 
        myAnnotationView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callOutClicked:)];
        [myAnnotationView addGestureRecognizer:tap];
}
    else
    {
        [myAnnotationView removeFromSuperview];
    }
}

-(void) callOutClicked:(UITapGestureRecognizer *) tap {
    NSLog(@"Clickato");
}

@end
