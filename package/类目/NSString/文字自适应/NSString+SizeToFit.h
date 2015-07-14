//
//  NSString+SizeToFit.h
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SizeToFit)
/**
 *  根据字符串返回自适应的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大限制尺寸
 *
 *  @return 自适应后的尺寸
 */
- (CGSize)sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
