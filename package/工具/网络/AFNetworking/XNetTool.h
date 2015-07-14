//
//  XNetTool.h
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//使用前请导入AFN框架

#import <Foundation/Foundation.h>
typedef void(^block)(id object);
typedef void(^downLoadingBlock)(long long currentLength, long long totalLength);

@interface XNetTool : NSObject
/**
 *  下载文件保存路径(默认cache)
 */
@property (copy,nonatomic)NSString *downLoadPath;

/**
 *  创建网络工具实例对象
 */
+ (XNetTool *)tool;
/**
 *  检测网络状态
 */
- (void)checkOutNetStatus;

/**
 *  网络请求
 *
 *  @param url     请求地址
 *  @param pramas  报文
 */
- (void)RequestInfoWithURL:(NSString *)url params:(NSDictionary *)pramas success:(block)success fail:(block)fail;

/**
 *  上传数据
 *
 *  @param url     请求地址
 *  @param pramas  报文
 *  @param data    需要上传的data数据
 *  @param dataStr 数据对应的服务器key值名
 *  @param name    数据的本地文件名
 *  @param type    数据类型
 */
- (void)upInfoWithURL:(NSString *)url params:(NSDictionary *)pramas data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type success:(block)success fail:(block)fail;

/**
 *  下载数据（建议使用下面的方法）
 *
 *  @param str             下载地址
 *  @param fileName        保存的文件名
 *  @param completionBlock 下载完成后的回调方法
 */
- (void)downLoadWithStr:(NSString *)str fileName:(NSString *)fileName completionHandler:(void(^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionBlock;
/**
 *  创建断点下载任务
 *
 *  @param url  下载地址
 *  @param dlingBlock  下载中的回调
 *  @param path 文件保存地址
 *  @param path 下载完成后的回调
 */
- (void)creatDownLoadTaskWithURL:(NSString *)url DownLoadingHandler:(downLoadingBlock)dlingBlock completionHandler:(block)completionBlock;
/**
 *  恢复断点任务
 */
- (void)resumeDownLoadTask;
/**
 *  暂停断点任务
 */
- (void)pauseDownLoadTask;

@end
