//
//  KHNetworkEngine.h
//  KHealth
//
//  Created by wang hongxi on 13-10-12.
//  Copyright (c) 2013年 Beijing Dayactive CO. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
#import "NSError+Additions.h"

#define KHServerBase @"tingapi.ting.baidu.com"
//#define KHServerBase @"ting.baidu.com"
//1,3,5,9,10,12,14,,15,18,19,21,,22,,23,24,25,26,27,,28,29,30,31,32,33,34,35,36,37,38,39,40,99,100,104,//269,277
//http://api.tudou.com/v3/gw?method=item.ranking&format=xml&appKey=2aaf400b13fc9bad&pageNo=1&pageSize=20&channelId=22&sort=d
//土豆视频排行

#define kHAppErrorDomain @"应用错误"
#define kHErrorParse @"解析数据出错"

@interface KHError : NSError
@property (nonatomic,copy) NSString *reason;
-(id)initWithMKNetworkOperation:(MKNetworkOperation *)op error:(NSError *)error;
@end

@interface KHNetworkEngine : MKNetworkEngine {
}

typedef void (^CommonResponseBlock)(BOOL changed);
typedef void (^ListResponseBlock)(NSMutableArray *array);
//typedef void (^ProList)

@property (nonatomic,assign) BOOL showError;
-(void)showPrompt:(NSString *)msg;
-(BOOL)checkError:(id)resp;
@end
