//
//  FMMainViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseViewController.h"

@interface FMMainViewController : FMBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView * _tableView;

}
@property (strong,nonatomic) UISearchBar *searchBar;

@end
