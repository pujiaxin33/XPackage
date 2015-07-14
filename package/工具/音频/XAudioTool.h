//
//  XAudioTool.h
//  package
//
//  Created by wazrx on 15/7/14.
//  Copyright (c) 2015年 肖文. All rights reserved.
//  使用前请导入Lame框架

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface XAudioTool : NSObject

/**
 *  录音转mp3
 *
 *  @param str 录音文件的本地路径string
 *
 *  @return mp3的本地路径string
 */
+ (NSString *)recordToMp3WithRcordStr:(NSString *)str;
/**
 *  取得指定文件夹的所有音乐的所有信息（利用MetaInfo）
 *
 *  @param path 文件夹路径
 *
 *  @return 返回音乐信息字典数组，字典包括MP3的路径、图片、歌手、歌名、文件名（可自行添加）
 */
+ (NSArray *)GetAllLocalMusicInLocalPath:(NSString *)path;

@end
