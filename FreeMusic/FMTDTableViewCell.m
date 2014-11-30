//
//  FMTDTableViewCell.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/10.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMTDTableViewCell.h"
#import "UIView+Additions.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Additions.h"

@implementation FMTDTableViewCell
-(NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60*1000);
    int h = totalm/60;
    int m = totalm%60;
    int s = seconds%(60*1000);
    if (h==0) {
        return  [[NSString stringWithFormat:@"%02d:%02d", m, s] substringToIndex:5];
    }
    return [[NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s] substringToIndex:8];
}

-(void)setModel:(FMTDMovieModel *)model_
{
    _model = model_;
    titleLabel.text = _model.title;
    timeLabel.text = [self TimeformatFromSeconds:_model.totalTime];
    timesLabel.text = [NSString stringWithFormat:@"播放:%d 评论:%@",_model.playTimes,_model.commentCount];
    [picView setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"headerImage"]];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        picView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 110, 70)];
        [self.contentView addSubview:picView];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(picView.origin.x+picView.size.width/2, picView.size.height+picView.origin.y-17, picView.size.width/2, 17)];
        timeLabel.font = [UIFont systemFontOfSize:12.0f];
        timeLabel.textAlignment =NSTextAlignmentRight;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.backgroundColor =[UIColor colorWithWhite:0.0f alpha:0.3];
        [self.contentView addSubview:timeLabel];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picView.origin.x+picView.size.width+5, picView.origin.y, self.contentView.size.width-picView.origin.x-picView.size.width-10, 40)];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
//        titleLabel.backgroundColor = [UIColor lightGrayColor];
        titleLabel.numberOfLines  = 2;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:titleLabel];
        
        timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.origin.x, titleLabel.origin.y+titleLabel.size.height, titleLabel.size.width, titleLabel.size.height)];
        timesLabel.font = [UIFont systemFontOfSize:12.0f];
        timesLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timesLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
