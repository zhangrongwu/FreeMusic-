//
//  FMMusicViewController.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseViewController.h"

@class FMSongListModel,FMSongModel;

@interface FMMusicViewController : FMBaseViewController
{
    FMSongModel * _songModel;
}

@property (nonatomic,strong) FMSongListModel * songListModel;
@property (nonatomic,strong) NSMutableArray * array;
@property (nonatomic,assign) NSInteger index;

+(FMMusicViewController *)shareMusicViewController;
-(void)playMusicWithSongLink:(FMSongListModel*)model;

@end
