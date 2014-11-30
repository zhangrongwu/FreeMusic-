//
//  FMMySongModel.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/5.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMMySongModel.h"

@implementation FMMySongModel
//表名
+(NSString *)getTableName
{
    return @"FMMySong";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
+(NSString *)getPrimaryKey
{
    return @"song_id";
}
@end
