//
//  MiniGalleryCell.h
//  Woof
//
//  Created by Mattia Campana on 30/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniGalleryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) NSMutableDictionary *galleryCache;

-(void) populateWith: (int)imageId andImageCache: (NSMutableDictionary *) miniGalleryCache;

@end
