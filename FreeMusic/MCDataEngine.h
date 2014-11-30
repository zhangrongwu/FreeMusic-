//
//  MCDataEngine.h
//  MeiCheng
//
//  Created by zhaojianguo on 14-4-18.
//  Copyright (c) 2014年 zhaojianguo. All rights reserved.
//

#import "KHNetworkEngine.h"
@class FMSongListModel,FMSongList,FMSongModel,FMTDMovieList;

@interface MCDataEngine : KHNetworkEngine
typedef void (^SalesResponseBlock) (NSArray *array);
typedef void (^FMSongListModelResponseBlock) (FMSongList *songList);
typedef void (^FMSongModelResponseBlock) (FMSongModel *songModel);
typedef void (^FMSongLrcResponseBlock)(BOOL sucess,NSString * path);
typedef void (^FMSongLinkDownLoadResponseBlock)(BOOL sucess,NSString * path);
typedef void (^FMTDMovieListResponseBlock)(FMTDMovieList * movieList);

-(MKNetworkOperation *)getSingerInformationWith:(long long)tinguid
                                                WithCompletionHandler:(SalesResponseBlock)completion
                                             errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getSingerSongListWith:(long long)tinguid :(int) number
                WithCompletionHandler:(FMSongListModelResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getSongInformationWith:(long long)songID
                        WithCompletionHandler:(FMSongModelResponseBlock)completion
                                 errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getSongLrcWith:(long long)tingUid :(long long)songID :(NSString *)lrclink
                WithCompletionHandler:(FMSongLrcResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)downLoadSongWith:(long long)tingUid :(long long)songID :(NSString *)songLink
                WithCompletionHandler:(FMSongLinkDownLoadResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)getTDMovieListWith:(int)pageNo :(int)pageSize :(int)channelId :(NSString *)sort
                  WithCompletionHandler:(FMTDMovieListResponseBlock)completion
                           errorHandler:(MKNKErrorBlock)errorHandler;

-(MKNetworkOperation *)searchTDMovieWith:(int)pageNo :(int)pageSize :(NSString *)orderBy :(NSString *)keyWord
                   WithCompletionHandler:(FMTDMovieListResponseBlock)completion
                            errorHandler:(MKNKErrorBlock)errorHandler;
@end
