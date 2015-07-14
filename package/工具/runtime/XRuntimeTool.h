//
//  RuntimeTool.h
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeTool : NSObject
/**
 *  获取类的所有成员变量名称
 *
 *  @param className 类名
 *
 *  @return 成员变量名数组
 */
+ (NSArray *)getAllIvarNameInClass:(Class)className;
/**
 *  获取类的所有实例方法名称（禁用，暂时有问题）
 *
 *  @param className 类名
 *
 *  @return 实例方法名数组
 */
//+ (NSArray *)getAllMethodNameInClass:(Class)className;


@end
