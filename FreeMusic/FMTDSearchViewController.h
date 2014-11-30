//
//  FMTDSearchViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/11.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseViewController.h"
@interface FMTDSearchViewController : FMBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView * _tableView;
    NSMutableArray * array ;
}
@property (strong,nonatomic) UISearchBar *searchBar;
@end
