//
//  UIImage+tool.m
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "UIImage+tool.h"

@implementation UIImage (tool)

+ (UIImage *)screenShotWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (instancetype)imageWithOriginalImageName:(NSString *)imageName waterImageName:(NSString *)waterImageName{
    
    //1、创建位图上下文[若创建view的上下文，则直接取出即可，系统已经为我们创建好了]
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:imageName]];
    
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0);

    //2、绘制image
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //3、绘制水印
    
    UIImage *waterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:waterImageName]];
    
    CGFloat x = image.size.width - waterImage.size.width - 5;
    
    CGFloat y = image.size.height - waterImage.size.height -5;
    
    CGFloat scale = 0.5;
    
    [waterImage drawInRect:CGRectMake(x, y, waterImage.size.width * scale, waterImage.size.height * scale)];
    
    //4、取出上下文中的图片，生成新的image
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5、关闭上下文//必须关闭上下文
    
    UIGraphicsEndImageContext();
    
    return newImage;
    

}
@end
