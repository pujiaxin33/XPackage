//
//  UtilityTool.m
//  Test
//
//  Created by wangzheng on 15/6/5.
//  Copyright (c) 2015年 wangzheng. All rights reserved.
//

#import "UtilityTool.h"
static NSString * base64hash=@"T62tz1XHCUjk8NBveQaInA3GMswumo7gc~9VZRdqhbKyiOFlJS-xPfWE04rLY5Dp";
@implementation UtilityTool
+ (NSString*)encodeString:(NSString*)strSrc
{
        NSMutableString * strResult=[[NSMutableString alloc] initWithCapacity:10];
        NSData * bytes=[strSrc dataUsingEncoding:NSUTF8StringEncoding];
        Byte   * theByte=(Byte*)[bytes bytes];
        int length=[bytes length];
        int mod=0;
        Byte prev=0;
        for (int i=0; i<length; i++) {
            mod=i%3;
            if (mod==0) {
                [strResult appendFormat:@"%c",[base64hash characterAtIndex:((theByte[i] >> 2) & 0x3F)]];
            }else if (mod==1){
                [strResult appendFormat:@"%c",[base64hash characterAtIndex:((prev << 4 | (theByte[i] >> 4  &0x0F) )& 0x3F)]];
            }else{
                [strResult appendFormat:@"%c",[base64hash characterAtIndex:(((theByte[i] >> 6 & 0x03) | prev << 2) & 0x3F)]];
                [strResult appendFormat:@"%c",[base64hash characterAtIndex:(theByte[i] & 0x3F)]];
            }
            prev=theByte[i];
        }
        if (mod==0) {
            [strResult appendFormat:@"%c",[base64hash characterAtIndex:(prev << 4 & 0x3C)]];
            [strResult appendString:@"=="];
        }else if (mod==1){
            [strResult appendFormat:@"%c",[base64hash characterAtIndex:(prev << 2 & 0x3F)]];
            [strResult appendString:@"="];
        }
        return strResult;
}

+ (NSString*)decodeString:(NSString*)strSrc{
        NSMutableString * result=[[NSMutableString alloc] initWithCapacity:10];
        for (int i=0; i<[strSrc length]; i++) {
            NSRange temp1=[base64hash rangeOfString:[NSString stringWithFormat:@"%c",[strSrc characterAtIndex:i]]];
            if (temp1.length==0) {
                [result appendString:@"000000"];
            }else{
                NSMutableString * strT=[[NSMutableString alloc] initWithString:[UtilityTool decimalTOBinary:temp1.location backLength:6]];
                [result appendString:strT];
            }
        }
        while ([[result substringFromIndex:result.length-8] isEqualToString:@"00000000"]) {
            result=[NSMutableString stringWithString:[result substringWithRange:NSMakeRange(0, result.length-8)]];
        }
        Byte * byte2=(Byte*)malloc(result.length/8);
        for (int i=0; i<(result.length/8); i++) {
            byte2[i]=(Byte)[[UtilityTool toDecimalSystemWithBinarySystem:[result substringWithRange:NSMakeRange(i*8,8)]] integerValue];
        }
        NSData * dTemp=[NSData dataWithBytes:byte2 length:result.length/8];
    NSString * strTemp = [[NSString alloc] initWithData:dTemp encoding:NSUTF8StringEncoding];
        free(byte2);
        return strTemp;
    
}

+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    return a;
}

+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}
@end
