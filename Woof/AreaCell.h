//
//  AreaCell.h
//  Woof
//
//  Created by Mattia Campana on 04/09/12.
//  Copyright (c) 2012 Private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"

@interface AreaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *nRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userCommentImage;
@property (weak, nonatomic) IBOutlet UIView *commentContainer;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;
@property (retain, nonatomic) NSMutableDictionary *cache;
@property (retain, nonatomic) NSString *idArea;
@property (nonatomic) int nTryToDownload;


-(void)populateWith: (Area *)area andImageCache: (NSMutableDictionary *)imageCache;

@end
