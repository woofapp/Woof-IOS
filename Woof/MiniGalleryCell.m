//
//  MiniGalleryCell.m
//  Woof
//
//  Created by Mattia Campana on 30/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import "MiniGalleryCell.h"
#import "AreaManager.h"
#import "ImageUtility.h"

@implementation MiniGalleryCell

@synthesize imageView;
@synthesize galleryCache;

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

-(void) populateWith: (int)imageId andImageCache: (NSMutableDictionary *) miniGalleryCache{
    
    galleryCache = miniGalleryCache;
    
    UIImage *image = [galleryCache objectForKey:[[NSNumber alloc] initWithInt:imageId]];
    
    if(image == NULL){
        self.imageView.image = [UIImage imageNamed: @"downloading_area_image.jpg"];
        [self performSelectorInBackground:@selector(downloadImage:) withObject:[[NSNumber alloc]initWithInt:imageId]];
    }else
        self.imageView.image = image;
}

-(void) downloadImage: (NSNumber *) imageId{
    NSString *b64Image = [AreaManager getImage:[imageId intValue]];
    
    UIImage *image = [ImageUtility decodeBase64Image:b64Image];
    
    if(image != NULL) [galleryCache setObject:image forKey:imageId];
    
    [self performSelectorOnMainThread:@selector(downloadedImage:) withObject:image waitUntilDone:NO];
}

-(void) downloadedImage: (UIImage *)img{
    self.imageView.image = img;
}

@end
