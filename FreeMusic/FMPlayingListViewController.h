//
//  FMPlayingListViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseViewController.h"

@class FMSongListModel;

@interface FMPlayingListViewController : UIViewController
{
    UITableView * _tableView;
}
@property (nonatomic,strong) NSMutableArray * array;
@end
