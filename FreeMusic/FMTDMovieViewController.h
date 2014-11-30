//
//  FMTDMovieViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/9.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTDMovieModel.h"
#import "FMBaseViewController.h"
@interface FMTDMovieViewController : FMBaseViewController
@property (nonatomic,strong) FMTDMovieModel * model;
@property (nonatomic,strong) UIWebView * webView;
@end
