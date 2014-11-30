//
//  FMMySongModel.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/5.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMMySongModel : NSObject
@property (nonatomic,assign) long long ting_uid;
@property (nonatomic,assign) long long song_id;
@property (nonatomic,copy) NSString * songName;
@property (nonatomic,copy) NSString * lrcLink;
@property (nonatomic,copy) NSString * songLink;
@property (nonatomic,copy) NSString * songPicBig;
@property (nonatomic,assign) long long albumid;
@end