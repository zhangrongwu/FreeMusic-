//
//  FMMainTableViewCell.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledTableViewCell.h"
@class FMPAImageView;
@class FMSingerModel;

@interface FMMainTableViewCell : StyledTableViewCell
{
    
    FMPAImageView * headerImageView;
    UILabel * nameLabel;
    UILabel * titleLabel;
    
}
@property (nonatomic,strong) FMSingerModel * model;
@end
