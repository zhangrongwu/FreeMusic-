//
//  FMTDTableViewCell.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/10.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTDMovieModel.h"
#import "StyledTableViewCell.h"

@interface FMTDTableViewCell : StyledTableViewCell
{
    UIImageView * picView;
    UILabel * titleLabel;
    UILabel * timeLabel;
    UILabel * timesLabel;
}
@property (nonatomic,strong) FMTDMovieModel *model;
@end
