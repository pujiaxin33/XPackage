//
//  UITextField+GetRange.h
//  UI-ECB
//
//  Created by wazrx on 15/6/19.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (GetRange)
- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;
@end
