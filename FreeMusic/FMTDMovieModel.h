//
//  FMTDMovieModel.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/9.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTDMovieModel : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * tags;
@property (nonatomic,copy) NSString * description;
@property (nonatomic,copy) NSString * picUrl;
@property (nonatomic,copy) NSString * picUrl__16__9;
@property (nonatomic,copy) NSString * pubDate;
@property (nonatomic,copy) NSString * itemUrl;
@property (nonatomic,copy) NSString * playUrl;
@property (nonatomic,copy) NSString * mediaType;
@property (nonatomic,copy) NSString * bigPicUrl;
@property (nonatomic,assign) int  totalTime;
@property (nonatomic,copy) NSString *  html5Url;
@property (nonatomic,assign) int playTimes;
@property (nonatomic,copy) NSString * commentCount;
@property (nonatomic,copy) NSString * outerGPlayerUrl;
@property (nonatomic,copy) NSString * ownerName;
@end
@interface FMTDMovieList : NSObject
//@property (nonatomic,copy) NSString * sort;
//@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,retain) NSMutableArray * movieLists;
@property (nonatomic,assign) int totalCount;
@end
