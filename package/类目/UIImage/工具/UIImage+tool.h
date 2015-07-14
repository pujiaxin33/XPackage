//
//  UIImage+tool.h
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tool)
/**
 *  截屏
 *
 *  @param view 需要截屏的视图
 *
 *  @return 相应图片
 */
+ (instancetype)screenShotWithView:(UIView *)view;
/**
 *  打水印
 *
 *  @param imageName      原始图
 *  @param waterImageName 水印
 *
 *  @return 水印图
 */
+ (instancetype)imageWithOriginalImageName:(NSString *)imageName waterImageName:(NSString *)waterImageName;

@end
