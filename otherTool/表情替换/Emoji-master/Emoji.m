//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
    [array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}
+ (NSString *)emojiStringWithString:(NSString *)string{
    
    NSMutableString *emojiStr = [NSMutableString string];
    NSMutableArray *data = [NSMutableArray array];
    NSArray *emojiArr = [string componentsSeparatedByString:@">"];
    for (NSString *str in emojiArr) {
        NSArray *temp = [str componentsSeparatedByString:@"<"];
        NSString * tempStr = [temp lastObject];
        //str.length >3 排除>123>这种情况,这里的123不是表情
        if (str.length >3 && tempStr.length == 3 && [tempStr characterAtIndex:0] != '0' &&[tempStr intValue] < 679) {
            if ([tempStr characterAtIndex:0] == ' ') {
                if ([tempStr characterAtIndex:1] != '0') {
                   NSString *test = [[str substringToIndex:(str.length - 4)] stringByAppendingFormat:@"%@", [self allEmoji][[tempStr intValue]]];
                    [data addObject:test];
                    [emojiStr appendFormat:@"%@", test];
                    continue;
                }
            }else{
                NSString *test = [[str substringToIndex:(str.length - 4)] stringByAppendingFormat:@"%@", [self allEmoji][[tempStr intValue]]];
                [emojiStr appendFormat:@"%@", test];
                continue;
            }
        }
        [emojiStr appendFormat:@"%@>", str];
        }
    return [emojiStr substringToIndex:emojiStr.length - 1];//最后一个>字符是多余的
}
+ (NSString *)normalStringWithEmojiString:(NSString *)string{
    if (string.length < 2) return string;
    NSMutableString *normalStr = [NSMutableString string];
    NSInteger previous = 0;
    for (int i = 0; i < string.length - 1; i ++) {
        NSString *temp = [string substringWithRange:NSMakeRange(i, 2)];
        NSInteger tempCount = [[Emoji allEmoji] indexOfObject:temp];
        if (tempCount != NSNotFound) {
            NSString *newTemp = [NSString stringWithFormat:@"<%3ld>", tempCount];
            NSInteger temptemp = i - previous;
            [normalStr appendFormat:@"%@", [[string substringWithRange:NSMakeRange(previous, temptemp)] stringByAppendingFormat:@"%@", newTemp]];
            i = i + 1;//从表情后面的字符开始，因为i马上还要++ ，所以这里加1
            previous = i + 1;//从表情后面的字符开始
            continue;
        }
    }
    [normalStr appendFormat:@"%@", [string substringWithRange:NSMakeRange(previous, string.length - previous)]];//拼接最后的一段非表情字符串
    return normalStr;
}
@end
