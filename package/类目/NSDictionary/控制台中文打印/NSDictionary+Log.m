//
//  NSDictionary+Log.m
//  It's Warm
//
//  Created by rimi on 15/5/14.
//  Copyright (c) 2015年 CAP. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

//// 重写描述方法，打印输出转码之后的中文
//- (NSString *)descriptionWithLocale:(id)locale {
//    
//    // 遍历数组中的所有内容，将内容拼接成一个新的字符串返回
//    NSMutableString *strM = [NSMutableString string];
//    
//    [strM appendString:@"{\n"];
//    
//    // 遍历数组,self就是当前的数组
//    for (id key in self) {
//        // 在拼接字符串时，会调用obj的description方法
//        [strM appendFormat:@"\t%@ = %@,\n", key, self[key]];
//    }
//    
//    [strM appendString:@"}"];
//    
//    return strM;
//}

- (NSString *)descriptionWithLocale:(id)locale
{
    NSString *tempStr1 = [[self description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    return str;
}



@end
