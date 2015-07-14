//
//  RuntimeTool.m
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "RuntimeTool.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation RuntimeTool

+ (NSArray *)getAllMethodNameInClass:(Class)className{
    NSMutableArray * temp = [NSMutableArray array];
    unsigned int count = 0;
    Method *methods = class_copyMethodList(className, &count);
    for (int i = 0; i < count; i ++) {
        SEL name = method_getName(methods[i]);
        [temp addObject:NSStringFromSelector(name)];
    }
    return [NSArray arrayWithArray:temp];
}

+ (NSArray *)getAllIvarNameInClass:(Class)className{
    NSMutableArray * temp = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(className, &count);
    for (int i = 0; i < count; i ++) {
        const char *name = ivar_getName(ivars[i]);
        [temp addObject:[NSString stringWithUTF8String:name]];
    }
    return [NSArray arrayWithArray:temp];
    
}

@end
