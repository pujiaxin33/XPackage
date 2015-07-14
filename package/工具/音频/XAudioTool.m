//
//  XAudioTool.m
//  package
//
//  Created by wazrx on 15/7/14.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "XAudioTool.h"
#import "lame.h"

@implementation XAudioTool

+ (NSString *)recordToMp3WithRcordStr:(NSString *)str{
    
    NSString *mp3Str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    mp3Str = [mp3Str stringByAppendingPathComponent:@"recode.mp3"];
    @try {
        int  write;
        size_t read;
        FILE *pcm = fopen([str cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Str cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",mp3Str);
    }
    return mp3Str;
    
}

+ (NSArray *)GetAllLocalMusicInLocalPath:(NSString *)path{
    
    //获取指定目录中所有mp3路径
    NSBundle *bd = [NSBundle bundleWithPath:path];
    NSArray *musciArray = [bd pathsForResourcesOfType:@"mp3" inDirectory:@"mp3"];
    NSMutableArray * datas = [NSMutableArray array];
    for (NSString *filePath in musciArray) {
        //创建音乐模型对象
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        //取得文件名
        NSString *str = [filePath lastPathComponent];
        //去掉后缀名
        str = [str stringByDeletingPathExtension];
        [data setObject:str forKey:@"fileName"];
        //路径转成URL
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [data setObject:fileURL forKey:@"url"];
        //通过URL创建AVURLAsset对象
        AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
        //获取元数据格式
        for (NSString *fomart in [avURLAsset availableMetadataFormats]) {
            //按个数取出元数据项（元数据项是键值对格式）
            for (AVMetadataItem *item in [avURLAsset metadataForFormat:fomart]) {
                //判断元数据键名
                if ([[item commonKey] isEqualToString:@"title"]) {
                    //取出标题名
                    NSString *title = (NSString *)item.value;
                    [data setObject:title forKey:@"title"];
                    continue;
                }
                if ([[item commonKey] isEqualToString:@"artwork"]) {
                    //取出图片数据
                    NSData *ImageData = (NSData *)item.value;
                    //转成UIImage
                    UIImage *img = [UIImage imageWithData:ImageData];
                    [data setObject:img forKey:@"image"];
                    continue;
                }
                if ([[item commonKey] isEqualToString:@"artist"]) {
                    //取出歌手名称
                    NSString *name = (NSString *)item.value;
                    [data setObject:name forKey:@"artist"];
                    continue;
                }
            }
            [datas addObject:data];
        }
    }
    return datas;

}


@end
