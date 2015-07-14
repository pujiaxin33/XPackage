//
//  XTimeTool.h
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTimeTool : NSObject
/**
 *  通过时间获取字符串：00:00:00
 */
+ (NSString *)getTimeStringWithTime:(NSTimeInterval)time;
/**
 *  时间戳转时间字符串
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString *)stringWithTimestamp:(NSNumber *)timestamp;

@end
