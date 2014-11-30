//
//  FMSongListTableViewCell.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMSongListTableViewCell.h"
#import "UIView+Additions.h"
#import "FMSongListModel.h"

@implementation FMSongListTableViewCell
-(NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h==0) {
        return  [[NSString stringWithFormat:@"%02d:%02d", m, s] substringToIndex:5];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}

-(void)setModel:(FMSongListModel *)model_
{
    _model = model_;
    nameLabel.text = _model.title;
    timeLabel.text =[self TimeformatFromSeconds:_model.file_duration];
    titleLabel.text = [NSString stringWithFormat:@"%@•%@",_model.author,_model.album_title];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

        // Initialization code
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, self.contentView.size.width-16-60, 25)];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
//        nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:nameLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.size.width+nameLabel.origin.x, nameLabel.size.height/2+nameLabel.origin.y, 40, 25)];
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
//        timeLabel.backgroundColor = [UIColor blueColor];
        timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timeLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.origin.x, nameLabel.size.height+nameLabel.origin.y, nameLabel.size.width, 25)];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        titleLabel.backgroundColor = [UIColor greenColor];
        titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:titleLabel];
    }
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

@end
