//
//  FMSongModel.h
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FMSongModel : NSObject
@property (nonatomic,assign) long long  queryId;
@property (nonatomic,assign) long long  songId;
@property (nonatomic,copy) NSString * songName;
@property (nonatomic,assign) long long  artistId;
@property (nonatomic,copy) NSString * artistName;
@property (nonatomic,assign) long long  albumId;
@property (nonatomic,copy) NSString * albumName;
@property (nonatomic,copy) NSString * songPicSmall;
@property (nonatomic,copy) NSString * songPicBig;
@property (nonatomic,copy) NSString * songPicRadio;
@property (nonatomic,copy) NSString * lrcLink;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,assign) int copyType;
@property (nonatomic,assign) int time;
@property (nonatomic,assign) int linkCode;
@property (nonatomic,copy) NSString * songLink;
@property (nonatomic,copy) NSString * showLink;
@property (nonatomic,copy) NSString * format;
@property (nonatomic,assign) int rate;
@property (nonatomic,assign) long long  size;



//@property (nonatomic,assign) int file_bitrate;
//@property (nonatomic,copy) NSString * file_link;
//@property (nonatomic,copy) NSString * file_extension;
//@property (nonatomic,assign) long file_size;
//@property (nonatomic,assign) int file_duration;
//@property (nonatomic,assign) long song_file_id;
//@property (nonatomic,copy) NSString * show_link;
//@property (nonatomic,copy) NSString * hash;
//@property (nonatomic,assign) int  can_load;
//@property (nonatomic,assign) int can_see;
//@property (nonatomic,assign) int  is_udition_url;
//@property (nonatomic,assign) int  original;
//@property (nonatomic,assign) int  preload;
//@property (nonatomic,assign) int  down_type;
//@property (nonatomic,assign) float replay_gain;
@end
