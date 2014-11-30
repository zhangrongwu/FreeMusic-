//
//  FMTudouViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/9.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMBaseViewController.h"
#import "DropDownChooseProtocol.h"

@interface FMTudouViewController : FMBaseViewController<UITableViewDelegate,UITableViewDataSource,DropDownChooseDelegate,DropDownChooseDataSource>
{
    UITableView * _tableView;
}
@end