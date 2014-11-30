//
//  NSDate+Additions.h
//  KHealth
//
//  Created by wang hongxi on 13-10-14.
//  Copyright (c) 2013年 Beijing Dayactive CO. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)
-(NSString *)dateString;
-(NSString *)dateString2;
-(NSString *)dateTimeString;
-(NSString *)dateTimeString2;
-(NSString *)shortDateString;
-(NSString *)shortTimeString;
-(NSString *)longTimeString;
-(NSString *)shortDateTimeString;
-(long long)milseconds;
+(NSDate *)dateFromYYYYMMDD:(NSString *)dateString;
+(NSDate *)dateWithYear:(int)year;

+ (NSString *) getTimeDiffString:(NSDate *) temp;
@end
