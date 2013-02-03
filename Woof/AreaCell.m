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
#import "Base64.h"

@implementation AreaCell

@synthesize addressLabel, ratingImage, nRatingLabel, distanceLabel, commentContainer, commentLabel, userCommentImage, userCommentNameLabel, container, areaImageView, cache, idArea;

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
    
    addressLabel.text = [area myAddress];
    self.cache = imageCache;
    self.idArea = [area myIdArea];
    
    if(![[cache allKeys] containsObject:idArea]){
        areaImageView.image = [UIImage imageNamed: @"downloading_area_image.jpg"];
        [self performSelectorInBackground:@selector(downloadLastAreaImage:) withObject:idArea];
    
    }else if([[cache objectForKey:idArea] isKindOfClass:[UIImage class]])
        areaImageView.image = [cache objectForKey:idArea];
    
    else if([[cache objectForKey:idArea] isKindOfClass:[NSString class]]){
        [Base64 initialize];
        NSData* data = [Base64 decode:[cache objectForKey:idArea]];
        if(data != nil)
            areaImageView.image = [UIImage imageWithData:data];
    }
    
    int rating = ceil([area myRating]);
    
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
    
    nRatingLabel.text = [NSString stringWithFormat:@"(%d)",[area myNRating]];
    
    if (area.myDistance > 1000) distanceLabel.text = [NSString stringWithFormat:@"%.2f Km",area.myDistance/1000];
    else distanceLabel.text = [NSString stringWithFormat:@"%.2f m",area.myDistance];
    
    if([[area myComments] count] == 0){
        commentContainer.frame = CGRectMake(0,0,0,0);
        commentContainer.alpha = 0;
        self.frame = CGRectMake(0,0,320,130);
        container.frame = CGRectMake(10,5,300,130);
    }else{
        Comment *comment = [[area myComments] objectAtIndex:0];
        commentLabel.text = comment.text;
        userCommentNameLabel.text = [NSString stringWithFormat:@"%@ %@",[[comment user]name], [[comment user] surname]];
        
        //immagine utente
        UIImage *userImg = [[comment user] getImageFromB64String];
        if(userImg != nil) [userCommentImage setImage:userImg];
    }
}

- (void)downloadLastAreaImage: (NSString*) idA{

    int id_area = [idA intValue];
    
    NSString *image = [AreaManager getLastAreaImage:id_area];
    
    [self performSelectorOnMainThread:@selector(downloadImageCompletedWithData:) withObject:image waitUntilDone:NO];
}

- (void)downloadImageCompletedWithData: (NSString *)image{
    
    if(image != nil){
        
        [Base64 initialize];
        NSData* data = [Base64 decode:image];
        if(data != nil)
            [self.cache setObject:image forKey:idArea]; //aggiungo immagine alla cache
        
        areaImageView.image = [UIImage imageWithData:data];
        
    }else{
        areaImageView.image = [UIImage imageNamed: @"defaultAreaImage@2.png"];
        [self.cache setObject:[UIImage imageNamed: @"defaultAreaImage@2.png"] forKey:idArea];
    }
}

@end
