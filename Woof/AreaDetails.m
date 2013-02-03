//
//  AreaDetails.m
//  Woof
//
//  Created by Mattia Campana on 29/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "AreaDetails.h"
#import "AreaManager.h"
#import "MiniGalleryCell.h"
#import "Comment.h"
#import "FormatText.h"
#import "ImageUtility.h"
#import "UIEffects.h"

@interface AreaDetails ()

@end

@implementation AreaDetails

@synthesize area, areaImagesIds, miniGalleryCache, galleryMessage;
@synthesize titleLabel,miniGallery, scrollImageMessageView, scrollImageMessage, areaAddressLabel, ratingImageView, nRatingLabel, totalCheckinLabel, noImageMessageContainer, contentScrollView, commentContainer1, commentContainer2, noCommentsMessage, commentsControlMenu;
//Comments
@synthesize userNameSurname1,userImage1,userComment1,commentDate1,userNameSurname2,userComment2,commentDate2, userImage2;

//Rating
@synthesize ratingBackgroundView,starsContainer,userRatingChoice;

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
    
    [titleLabel setFont:[UIFont fontWithName:@"Opificio" size:20]];
    
    areaAddressLabel.text = [area myAddress];
    
    [self setImageRating:ceil([area myRating])];
    
    nRatingLabel.text = [NSString stringWithFormat:@"(%d)",[area myNRating]];
    
    totalCheckinLabel.text = [NSString stringWithFormat:@"%d",[[area myCheckins] count]];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [contentScrollView setScrollEnabled:YES];
    contentScrollView.frame = CGRectMake(0, 43, 320, [UIScreen mainScreen].bounds.size.height - 40);
    
    /*
     * Setting dei commenti
     */
    switch ([area.myComments count]) {
        case 1:
            [self showComment:1 with:area.myComments[0]];
            commentContainer1.alpha = 1;
            commentsControlMenu.frame = CGRectMake(0, 105, 320, 35);
            commentsControlMenu.alpha = 1;
            [self resizeScrollViewHeight: 560];
            break;
        case 2:
            [self showComment:1 with:area.myComments[0]];
            [self showComment:2 with:area.myComments[1]];
            commentContainer1.alpha = 1;
            commentContainer2.alpha = 1;
            commentsControlMenu.frame = CGRectMake(0, 180, 320, 35);
            commentsControlMenu.alpha = 1;
            [self resizeScrollViewHeight: 630];
            break;
            
        default:
            noCommentsMessage.alpha = 1;
            [self resizeScrollViewHeight: 520];
            break;
    }
    
    ratingBackgroundView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha:0.5];
}

-(void) resizeScrollViewHeight: (int) height{
    [contentScrollView setContentSize:CGSizeMake(320, height)];
}

-(void) showComment: (int)container with:(Comment*)comment{
    
    NSString *text = [FormatText formatComment:comment.text withQuotes:NO];
    NSString *nameSurname = [FormatText toUpperEveryFirstChar:[[comment.user.name stringByAppendingString:@" "] stringByAppendingString:comment.user.surname]];
    UIImage *image = [self convertStringToImage:comment.user.image];
    NSString *date = [FormatText formatDate:comment.date];
    
    if(container == 1){
        userNameSurname1.text = nameSurname;
        commentDate1.text = date;
        userComment1.text = text;
        [userComment1 sizeToFit];
        userImage1.image = image;
    }else if(container == 2){
        userNameSurname2.text = nameSurname;
        commentDate2.text = date;
        userComment2.text = text;
        [userComment2 sizeToFit];
        userImage2.image = image;
    }
    
}

-(UIImage*)convertStringToImage:(NSString *)string{
    
    UIImage *image = [ImageUtility decodeBase64Image:string];
    
    if(image == NULL) image = [UIImage imageNamed: @"no_personal_image.png"];
    
    return image;
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
    
    //Set touch event
    UITapGestureRecognizer *ratingImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSendRating)];
    [ratingImageViewTap setNumberOfTouchesRequired:1];
    [ratingImageViewTap setNumberOfTapsRequired:1];
    [ratingImageViewTap setDelegate:self];
    [ratingImageView addGestureRecognizer:ratingImageViewTap];
}

-(void)showSendRating{
    [UIEffects fadeIn:ratingBackgroundView withDuration:1 andWait:0];
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
        [miniGallery reloadData];
    }else{
        miniGallery.alpha = 0;
        noImageMessageContainer.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha:0.5];
        
    }
    
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

- (IBAction)sendRating:(id)sender {
    //Invio rating dell'utente
    
}

- (IBAction)hideSendRating:(id)sender {
    [UIEffects fadeOut:ratingBackgroundView withDuration:1 andWait:0];
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


/*
 * GESTIONE RATING POPUP
 */
-(void)newRating:(DLStarRatingControl *)control :(float)rating {
    userRatingChoice = rating;
}


@end
