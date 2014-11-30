//
//  FMSongListTableViewCell.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "StyledTableViewCell.h"

@class FMSongListModel;

@interface FMSongListTableViewCell : StyledTableViewCell
{
    UILabel * nameLabel;
    UILabel * titleLabel;
    UILabel * timeLabel;
}
@property (nonatomic,strong) FMSongListModel * model;
@end
