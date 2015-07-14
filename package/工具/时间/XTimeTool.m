//
//  XTimeTool.m
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "XTimeTool.h"

@implementation XTimeTool

+ (NSString *)getTimeStringWithTime:(NSTimeInterval)time{
    
    NSString *hour = [NSString stringWithFormat:@"%02d", ((int)time / 3600)];
    NSString *min = [NSString stringWithFormat:@"%02d", (((int)time % 3600) / 60)];
    NSString *second = [NSString stringWithFormat:@"%02d", ((int)time % 60)];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, min, second];
}

+ (NSString *)stringWithTimestamp:(NSNumber *)timestamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/1000];
    NSDate *date = [confromTimesp dateByAddingTimeInterval:480 * 60];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
