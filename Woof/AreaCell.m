//
//  AreaCell.m
//  Woof
//
//  Created by Mattia Campana on 04/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import "AreaCell.h"
#import "Comment.h"
#import "AreaManager.h"
#import "FormatText.h"
#import "ImageUtility.h"


@implementation AreaCell

@synthesize addressLabel, ratingImage, nRatingLabel, distanceLabel, commentContainer, commentLabel, userCommentImage, userCommentNameLabel, container, areaImageView, cache, idArea, nTryToDownload;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)populateWith: (Area *)area andImageCache: (NSMutableDictionary *)imageCache{
    
    self.nTryToDownload = 1;
    
    addressLabel.text = [area myAddress];
    self.cache = imageCache;
    self.idArea = [area myIdArea];
    
    
    if(![[cache allKeys] containsObject:idArea]){
        NSLog(@"Scarico immagine per area %@",idArea);
        areaImageView.image = [UIImage imageNamed: @"downloading_area_image.jpg"];
        [self performSelectorInBackground:@selector(downloadLastAreaImage:) withObject:idArea];
    }else if([[cache objectForKey:idArea] isEqualToString:@"defaultAreaImage@2.png"]){
        areaImageView.image = [UIImage imageNamed: @"defaultAreaImage@2.png"];
        
    }else{
        NSLog(@"Prelevo immagine da cache per area %@",idArea);
        areaImageView.image = [ImageUtility decodeBase64Image:[cache objectForKey:idArea]];
    }
    
    [self setRating:area.myRating];
    
    nRatingLabel.text = [NSString stringWithFormat:@"(%d)",[area myNRating]];
    
    if (area.myDistance > 1000) distanceLabel.text = [NSString stringWithFormat:@"%.2f Km",area.myDistance/1000];
    else distanceLabel.text = [NSString stringWithFormat:@"%.2f m",area.myDistance];
    
    if([[area myComments] count] == 0){
        [self hideCommentContainer];
    }else{
        [self showComment:[[area myComments] objectAtIndex:0]];
        
    }
}

-(void)setRating: (double)rat{
    int rating = ceil(rat);
    
    UIImage *noStars = [UIImage imageNamed: @"stars@2.png"];
    UIImage *stars1 = [UIImage imageNamed: @"stars1@2.png"];
    UIImage *stars2 = [UIImage imageNamed: @"stars2@2.png"];
    UIImage *stars3 = [UIImage imageNamed: @"stars3@2.png"];
    UIImage *stars4 = [UIImage imageNamed: @"stars4@2.png"];
    UIImage *stars5 = [UIImage imageNamed: @"stars5@2.png"];
    
    switch (rating) {
        case 0:
            [ratingImage setImage:noStars];
            break;
            
        case 1:
            [ratingImage setImage:stars1];
            break;
            
        case 2:
            [ratingImage setImage:stars2];
            break;
            
        case 3:
            [ratingImage setImage:stars3];
            break;
            
        case 4:
            [ratingImage setImage:stars4];
            break;
            
        case 5:
            [ratingImage setImage:stars5];
            break;
    }
}

-(void)hideCommentContainer{
    commentContainer.frame = CGRectMake(0,0,0,0);
    commentContainer.alpha = 0;
    self.frame = CGRectMake(0,0,320,130);
    container.frame = CGRectMake(10,5,300,130);
}

-(void)showComment: (Comment *)comment{
    commentContainer.frame = CGRectMake(1,130,298,74);
    commentContainer.alpha = 1;
    self.frame = CGRectMake(0,0,320,224);
    container.frame = CGRectMake(10,5,300,205);
    
    commentLabel.text = [FormatText formatComment:comment.text withQuotes:YES];
    userCommentNameLabel.text = [FormatText toUpperEveryFirstChar:[NSString stringWithFormat:@"%@ %@",[[comment user]name], [[comment user] surname]]];
    
    
    //immagine utente
    UIImage *userImg;
    
    if(comment.user.image != NULL) userImg = [ImageUtility decodeBase64Image:comment.user.image];
    else userImg = [UIImage imageNamed: @"no_personal_image.png"];
    
    userCommentImage.image = userImg;
}

- (void)downloadLastAreaImage: (NSString*) idA{

    int id_area = [idA intValue];
    
    NSString *image = [AreaManager getLastAreaImage:id_area];
    
    [self performSelectorOnMainThread:@selector(downloadImageCompletedWithData:) withObject:image waitUntilDone:NO];
}

- (void)downloadImageCompletedWithData: (NSString *)image{
    
    if([image length] > 0) {
        
        UIImage *img = [ImageUtility decodeBase64Image:image];

        if(img != NULL) {
            [self.cache setObject:image forKey:idArea];
            areaImageView.image = img;
        }else{
            if(nTryToDownload <=3){
                nTryToDownload++;
                [self performSelectorInBackground:@selector(downloadLastAreaImage:) withObject:idArea];
            }else{
                image = @"defaultAreaImage@2.png";
                [self.cache setObject:@"defaultAreaImage@2.png" forKey:idArea];
                areaImageView.image = [UIImage imageNamed: @"defaultAreaImage@2.png"];
            }
        }
    }else{
        image = @"defaultAreaImage@2.png";
        [self.cache setObject:@"defaultAreaImage@2.png" forKey:idArea];
        areaImageView.image = [UIImage imageNamed: @"defaultAreaImage@2.png"];
    }
    
    [AreaManager insertLastImage:image forArea:[idArea intValue]];
}

@end
