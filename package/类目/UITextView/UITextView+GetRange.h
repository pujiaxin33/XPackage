//
//  UITextView+GetRange.h
//  UI-ECB
//
//  Created by wazrx on 15/6/20.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (GetRange)
@property (copy,nonatomic)NSString *text;
- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;
@end
