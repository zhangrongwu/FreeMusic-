//
//  Globle.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "Globle.h"

NSString * FMRFRadioViewStatusNotifiation = @"FMRFRadioViewStatusNotifiation";
NSString * FMRFRadioViewSetSongInformationNotification= @"FMRFRadioViewSetSongInformationNotification";
@implementation Globle
+(Globle*)shareGloble{
    static Globle *globle=nil;
    if (globle==nil) {
        globle=[[Globle alloc] init];
    }
    return globle;
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

-(void)copySqlitePath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [DocumentsPath stringByAppendingPathComponent:@"FreeMusic.db"];
    NSLog(@"%@",dbPath);
    
    if (![fileMgr fileExistsAtPath:dbPath]) {
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"FreeMusic" ofType:@"db"];
        [fileMgr copyItemAtPath:srcPath toPath:dbPath error:NULL];
    }
}
//-(NSMutableArray *)loadSinger
//{
//    NSMutableArray * arr  = [NSMutableArray new];
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"singer" ofType:@"txt"];
//    NSString * string =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//	NSArray *array = [string componentsSeparatedByString:@"\n"];
//    for (NSString * string in array) {
//		NSArray *temp = [string componentsSeparatedByString:@"###"];
//        [arr addObject:[temp objectAtIndex:0]];
//    }
//    NSLog(@"%d",[arr count]);
//    return arr;
//}

@end
