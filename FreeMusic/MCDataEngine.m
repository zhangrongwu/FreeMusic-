//
//  MCDataEngine.m
//  MeiCheng
//
//  Created by zhaojianguo on 14-4-18.
//  Copyright (c) 2014年 zhaojianguo. All rights reserved.
//

#import "MCDataEngine.h"
#import "FMSongListModel.h"
#import "FMSongModel.h"
#import "FMTDMovieModel.h"

#define DocumentsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
NSString * error_code = @"error_code";

NSString * ting_uid = @"ting_uid";
NSString * name = @"name";
NSString * firstchar = @"firstchar";
NSString * gender = @"gender";
NSString * area = @"area";
NSString * country = @"country";
NSString * avatar_big = @"avatar_big";
NSString * avatar_middle = @"avatar_middle";
NSString * avatar_small = @"avatar_small";
NSString * avatar_mini = @"avatar_mini";
NSString * constellation = @"constellation";
NSString * stature = @"stature";
NSString * weight = @"weight";
NSString * bloodtype = @"bloodtype";
NSString * company = @"company";
NSString * intro = @"intro";
NSString * songs_total = @"songs_total";
NSString * albums_total = @"albums_total";
NSString * birth = @"birth";
NSString * url = @"url";
NSString * artist_id = @"artist_id";
NSString * avatar_s180 = @"avatar_s180";
NSString * avatar_s500 = @"avatar_s500";
NSString * avatar_s1000 = @"avatar_s1000";
NSString * piao_id = @"piao_id";

NSString * songlist= @"songlist";

#import "FMSingerModel.h"


@implementation MCDataEngine
-(MKNetworkOperation *)getSingerInformationWith:(long long)tinguid WithCompletionHandler:(SalesResponseBlock)completion errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    NSString *urlPath = [NSString stringWithFormat:@"/v1/restserver/ting?from=android&version=2.4.0&method=baidu.ting.artist.getinfo&format=json&tinguid=%lld",tinguid];
   
    MKNetworkOperation *op = [self operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id respJson = [completedOperation responseJSON];
        if ([self checkError:respJson]) {
            return ;
        }
//        NSLog(@"resp:%@",respJson);
        @try{
            NSMutableArray * array = [NSMutableArray new];
            NSDictionary * dictionary = respJson;
            if ([[dictionary allKeys] count]>1) {
                FMSingerModel * model = [FMSingerModel new];
                model.ting_uid = [[dictionary objectForKey:ting_uid] longLongValue];
                model.name = [dictionary objectForKey:name];
                model.firstchar = [dictionary objectForKey:firstchar];
                model.gender = [[dictionary objectForKey:gender] intValue];
                model.area = [[dictionary objectForKey:area] intValue];
                model.country = [dictionary objectForKey:country];
                model.avatar_big = [dictionary objectForKey:avatar_big];
                model.avatar_middle =[dictionary objectForKey:avatar_middle];
                model.avatar_small = [dictionary objectForKey:avatar_small];
                model.avatar_mini =[dictionary objectForKey:avatar_mini];
                model.constellation = [dictionary objectForKey:constellation];
                if ([dictionary objectForKey:stature]!=[NSNull null]) {
                    model.stature = [[dictionary objectForKey:stature] floatValue];
                }else{
                    model.stature = 0.00f;
                }
                if ([dictionary objectForKey:weight]!=[NSNull null]) {
                    model.weight = [[dictionary objectForKey:weight] floatValue];
                }else{
                    model.weight = 0.00f;
                }
                model.bloodtype = [dictionary objectForKey:bloodtype];
                model.company =[dictionary objectForKey:company];
                model.intro =[dictionary objectForKey:intro];
                model.albums_total = [[dictionary objectForKey:albums_total] intValue];
                model.songs_total = [[dictionary objectForKey:songs_total] intValue];
                model.birth = [dictionary objectForKey:birth];
                model.url = [dictionary objectForKey:url];
                model.artist_id = [[dictionary objectForKey:artist_id] intValue];
                model.avatar_s180 = [dictionary objectForKey:avatar_s180];
                model.avatar_s500 = [dictionary objectForKey:avatar_s500];
                model.avatar_s1000 = [dictionary objectForKey:avatar_s1000];
                model.piao_id = [[dictionary objectForKey:piao_id] intValue];
                
                BOOL  sucess = [FMSingerModel insertToDB:model];
                if (sucess) {
                    NSLog(@"%@ sucess %lld",model.name,model.ting_uid);
                }
                
            }else{
                int errorcode = [[dictionary objectForKey:error_code] intValue];
                NSLog(@"%d",errorcode);
            }
            completion(array);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation *)getSingerSongListWith:(long long)tinguid :(int)number
                       WithCompletionHandler:(FMSongListModelResponseBlock)completion
                                errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    NSString *urlPath = [NSString stringWithFormat:@"/v1/restserver/ting?from=android&version=2.4.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=%lld&offset=0&limits=%d",tinguid,number];
    MKNetworkOperation *op = [self operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id respJson = [completedOperation responseJSON];
        if ([self checkError:respJson]) {
            return ;
        }
//        NSLog(@"resp:%@",respJson);
        FMSongList * list = [FMSongList new];
        @try{
            NSDictionary * dictionary = respJson;
            if ([[dictionary allKeys] count]>1) {
                list.songnums = [[dictionary objectForKey:@"songnums"] intValue];
                list.havemore = [[dictionary objectForKey:@"havemore"] boolValue];
                list.error_code =[[dictionary objectForKey:@"error_code"] intValue];
                NSArray * temp = [dictionary objectForKey:songlist];
                for (NSDictionary * dict in temp) {
                    FMSongListModel * model = [FMSongListModel new];
                    model.artist_id = [[dict objectForKey:@"artist_id"] intValue];
                    model.all_artist_ting_uid = [[dict objectForKey:@"all_artist_ting_uid"] intValue];
                    model.all_artist_id = [[dict objectForKey:@"all_artist_id"] intValue];
                    model.language = [dict objectForKey:@"language"];
                    model.publishtime = [dict objectForKey:@"publishtime"];
                    model.album_no = [[dict objectForKey:@"album_no"] intValue];
                    model.pic_big = [dict objectForKey:@"pic_big"];
                    model.pic_small = [dict objectForKey:@"pic_small"];
                    model.country = [dict objectForKey:@"country"];
                    model.area = [[dict objectForKey:@"area"] intValue];
                    model.lrclink = [dict objectForKey:@"lrclink"];
                    model.hot = [[dict objectForKey:@"hot"] intValue];
                    model.file_duration = [[dict objectForKey:@"file_duration"] intValue];
                    model.del_status = [[dict objectForKey:@"del_status"] intValue];
                    model.resource_type = [[dict objectForKey:@"resource_type"] intValue];
                    model.copy_type = [[dict objectForKey:@"copy_type"] intValue];
                    model.relate_status = [[dict objectForKey:@"relate_status"] intValue];
                    model.all_rate = [[dict objectForKey:@"all_rate"] intValue];
                    model.has_mv_mobile = [[dict objectForKey:@"has_mv_mobile"] intValue];
                    model.toneid = [[dict objectForKey:@"toneid"] longLongValue];
                    model.song_id = [[dict objectForKey:@"song_id"] longLongValue];
                    model.title = [dict objectForKey:@"title"];
                    model.ting_uid = [[dict objectForKey:@"ting_uid"] longLongValue];
                    model.author = [dict objectForKey:@"author"];
                    model.album_id = [[dict objectForKey:@"album_id"] longLongValue];
                    model.album_title = [dict objectForKey:@"album_title"];
                    model.is_first_publish = [[dict objectForKey:@"is_first_publish"] intValue];
                    model.havehigh = [[dict objectForKey:@"havehigh"] intValue];
                    model.charge = [[dict objectForKey:@"charge"] intValue];
                    model.has_mv = [[dict objectForKey:@"has_mv"] intValue];
                    model.learn = [[dict objectForKey:@"learn"] intValue];
                    model.piao_id = [[dict objectForKey:@"piao_id"] intValue];
                        model.listen_total = [[dict objectForKey:@"listen_total"] longLongValue];
                    [list.songLists addObject:model];
                }
            }else{
                int errorcode = [[dictionary objectForKey:error_code] intValue];
                NSLog(@"%d",errorcode);
            }
            completion(list);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation *)getSongInformationWith:(long long)songID
                       WithCompletionHandler:(FMSongModelResponseBlock)completion
                                errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    NSString *urlPath = [NSString stringWithFormat:@"/data/music/links?songIds=%lld",songID];
    KHNetworkEngine * netwrok = [self initWithHostName:@"ting.baidu.com"];
    MKNetworkOperation *op = [netwrok operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id respJson = [completedOperation responseJSON];
        if ([self checkError:respJson]) {
            return ;
        }
//        NSLog(@"resp:%@",respJson);
        FMSongModel * song = [FMSongModel new];
        @try{
            NSDictionary * dictionary = respJson;
            if ([[dictionary allKeys] count]>1) {
                NSDictionary * data = [dictionary objectForKey:@"data"];
                NSArray * songList = [data objectForKey:@"songList"];
                for (NSDictionary * sub in songList) {
                    song.songLink = [sub objectForKey:@"songLink"];
                    NSRange range = [song.songLink rangeOfString:@"src"];
                    if (range.location != 2147483647 && range.length != 0) {
                        NSString * temp = [song.songLink substringToIndex:range.location-1];
                        song.songLink = temp;
                    }
                    song.songName = [sub objectForKey:@"songName"];
                    song.lrcLink = [sub objectForKey:@"lrcLink"];
                    song.songPicBig = [sub objectForKey:@"songPicBig"];
                    song.time = [[sub objectForKey:@"time"] intValue];
                }
            }else{
                int errorcode = [[dictionary objectForKey:error_code] intValue];
                NSLog(@"%d",errorcode);
            }
            completion(song);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation *)getSongLrcWith:(long long)tingUid :(long long)songID :(NSString *)lrclink
                WithCompletionHandler:(FMSongLrcResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    KHNetworkEngine * netwrok = [self initWithHostName:@"ting.baidu.com"];
    MKNetworkOperation *op = [netwrok operationWithPath:lrclink];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSData * respData = [completedOperation responseData];
            if ([self checkError:respData]) {
                return ;
            }
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",tingUid]];
            NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songID]];
            if (![fileMgr fileExistsAtPath:UIDPath]) {
                BOOL creatUID = [fileMgr createDirectoryAtPath:UIDPath withIntermediateDirectories:YES attributes:nil error:nil];
                if (creatUID) {
                    NSLog(@"建立歌手文件夹成功");
                }
            }
            if (![fileMgr fileExistsAtPath:SIDPath]) {
                BOOL creatSID = [fileMgr createDirectoryAtPath:SIDPath withIntermediateDirectories:YES attributes:nil error:nil];
                if (creatSID) {
                    NSLog(@"建立歌曲文件夹成功");
                }
            }
            BOOL sucess = NO;
            NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.lrc",songID]];
            if (![fileMgr fileExistsAtPath:filePath]) {
                BOOL creat =  [fileMgr createFileAtPath:filePath contents:respData attributes:nil];
                if (creat) {
                    NSLog(@"lrc文件保存成功");
                    sucess = YES;
                }
            }else{
                sucess = YES;
            }
            //        NSLog(@"resp:%@",respData);
            @try{
                completion(sucess,filePath);
            }
            @catch (NSException *exception) {
                KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
                appError.reason = kHErrorParse;
                errorHandler(appError);
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"ERROR:%@",error);
            KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
            errorHandler(appError);
            
        }];
    [self enqueueOperation:op];
    return op;
    
}

-(MKNetworkOperation *)downLoadSongWith:(long long)tingUid :(long long)songID :(NSString *)songLink
                WithCompletionHandler:(FMSongLinkDownLoadResponseBlock)completion
                         errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    MKNetworkOperation *op = [self operationWithURLString:songLink];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData * respData = [completedOperation responseData];
        if ([self checkError:respData]) {
            return ;
        }
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *UIDPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",tingUid]];
        NSString * SIDPath = [UIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",songID]];
        if (![fileMgr fileExistsAtPath:UIDPath]) {
            BOOL creatUID = [fileMgr createDirectoryAtPath:UIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatUID) {
                NSLog(@"建立歌手文件夹成功");
            }
        }
        if (![fileMgr fileExistsAtPath:SIDPath]) {
            BOOL creatSID = [fileMgr createDirectoryAtPath:SIDPath withIntermediateDirectories:YES attributes:nil error:nil];
            if (creatSID) {
                NSLog(@"建立歌曲文件夹成功");
            }
        }
        BOOL sucess = NO;
        NSString * filePath  = [SIDPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.mp3",songID]];
        if (![fileMgr fileExistsAtPath:filePath]) {
            BOOL creat =  [fileMgr createFileAtPath:filePath contents:respData attributes:nil];
            if (creat) {
                NSLog(@"mp3文件保存成功");
                sucess = YES;
            }
        }else{
            sucess = YES;
        }
        //        NSLog(@"resp:%@",respData);
        @try{
            completion(sucess,filePath);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    
    [op onDownloadProgressChanged:^(double progress) {
        NSLog(@"%.2f",progress*100.0);
    }];

    [self enqueueOperation:op];
    return op;

}

-(MKNetworkOperation *)getTDMovieListWith:(int)pageNo :(int)pageSize :(int)channelId :(NSString *)sort
                    WithCompletionHandler:(FMTDMovieListResponseBlock)completion
                             errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    KHNetworkEngine * netwrok = [self initWithHostName:@"api.tudou.com"];
    NSString * urlPath = [NSString stringWithFormat:@"/v3/gw?method=item.ranking&format=json&appKey=2aaf400b13fc9bad&pageNo=%d&pageSize=%d&channelId=%d&sort=%@",pageNo,pageSize,channelId,sort];
    
    MKNetworkOperation *op = [netwrok operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary * respData = [completedOperation responseJSON];
//        NSLog(@"resp:%@",respData);
        NSDictionary * multiPageResult = [respData objectForKey:@"multiPageResult"];
        NSDictionary * page  =[multiPageResult objectForKey:@"page"];
        NSArray * results = [multiPageResult objectForKey:@"results"];
        
        FMTDMovieList * movieList = [FMTDMovieList new];
        movieList.totalCount = [[page objectForKey:@"totalCount"] intValue];
//        if (movieList.totalCount != 0) {
//            NSLog(@"%@",op.url);
//        }
        for (NSDictionary * sub in results) {
//            NSLog(@"%@",sub);
            FMTDMovieModel * model = [FMTDMovieModel new];
            model.title = [sub objectForKey:@"title"];
            model.tags = [sub objectForKey:@"tags"];
            model.description = [sub objectForKey:@"description"];
            model.picUrl = [sub objectForKey:@"picUrl"];
            model.picUrl__16__9 = [sub objectForKey:@"picUrl__16__9"];
            model.pubDate = [sub objectForKey:@"pubDate"];
            model.itemUrl = [sub objectForKey:@"itemUrl"];
            model.mediaType = [sub objectForKey:@"mediaType"];
            model.bigPicUrl = [sub objectForKey:@"bigPicUrl"];
            model.totalTime = [[sub objectForKey:@"totalTime"] intValue];
            model.playTimes = [[sub objectForKey:@"playTimes"] intValue];
            model.commentCount = [sub objectForKey:@"commentCount"];
            model.html5Url = [sub objectForKey:@"html5Url"];
            [movieList.movieLists addObject:model];
        }
        @try{
            completion(movieList);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    
    [self enqueueOperation:op];
    return op;
}


-(MKNetworkOperation *)searchTDMovieWith:(int)pageNo :(int)pageSize :(NSString *)orderBy :(NSString *)keyWord
                   WithCompletionHandler:(FMTDMovieListResponseBlock)completion
                            errorHandler:(MKNKErrorBlock)errorHandler
{
    self.showError = YES;
    KHNetworkEngine * netwrok = [self initWithHostName:@"api.tudou.com"];
    NSString * urlPath = [NSString stringWithFormat:@"v6/video/search?app_key=b30323ace96d8762&format=json&kw=%@&pageNo=%d&pageSize=%d&orderBy=%@",keyWord,pageNo,pageSize,orderBy];
    MKNetworkOperation *op = [netwrok operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary * respData = [completedOperation responseJSON];
        //        NSLog(@"resp:%@",respData);
        NSDictionary * page  =[respData objectForKey:@"page"];
        NSArray * results = [respData objectForKey:@"results"];
        
        FMTDMovieList * movieList = [FMTDMovieList new];
        movieList.totalCount = [[page objectForKey:@"totalCount"] intValue];
        for (NSDictionary * sub in results) {
            FMTDMovieModel * model = [FMTDMovieModel new];
            model.title = [sub objectForKey:@"title"];
            model.tags = [sub objectForKey:@"tags"];
            model.description = [sub objectForKey:@"description"];
            model.picUrl = [sub objectForKey:@"picUrl"];
            model.picUrl__16__9 = [sub objectForKey:@"picUrl__16__9"];
            model.pubDate = [sub objectForKey:@"pubDate"];
            model.itemUrl = [sub objectForKey:@"itemUrl"];
            model.playUrl = [sub objectForKey:@"playUrl"];
            model.mediaType = [sub objectForKey:@"mediaType"];
            model.bigPicUrl = [sub objectForKey:@"bigPicUrl"];
            model.totalTime = [[sub objectForKey:@"totalTime"] intValue];
            model.playTimes = [[sub objectForKey:@"playTimes"] intValue];
            model.commentCount = [sub objectForKey:@"commentCount"];
            model.html5Url = [sub objectForKey:@"html5Url"];
            model.outerGPlayerUrl = [sub objectForKey:@"outerGPlayerUrl"];
            model.ownerName = [sub objectForKey:@"ownerName"];
            [movieList.movieLists addObject:model];
        }
        @try{
            completion(movieList);
        }
        @catch (NSException *exception) {
            KHError *appError = [[KHError alloc] initWithDomain:kHAppErrorDomain code:100 userInfo:nil];
            appError.reason = kHErrorParse;
            errorHandler(appError);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ERROR:%@",error);
        KHError *appError = [[KHError alloc] initWithMKNetworkOperation:completedOperation error:error];
        errorHandler(appError);
        
    }];
    
    [self enqueueOperation:op];
    return op;
}

@end
