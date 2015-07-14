//
//  XNetTool.m
//  package
//
//  Created by wazrx on 15/7/13.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "XNetTool.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
@interface XNetTool ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
//当前下载大小
@property (assign,nonatomic, readonly)long long currentLength;
//文件总大小
@property (assign,nonatomic,readonly)long long totalLength;
//文件句柄
@property (strong,nonatomic)NSFileHandle *writeHandle;
//下载地址
@property (copy,nonatomic)NSString *downLoadUrl;
//下载连接
@property (strong,nonatomic)NSURLConnection *connection;
//下载中的回调block
@property (copy,nonatomic)downLoadingBlock dlingBlock;

@end

@implementation XNetTool

+ (XNetTool *)tool{
    
    return [[XNetTool alloc] init];
}
/**
 *  检测网络状态
 */
- (void)checkOutNetStatus{
    
    //1、判定网络
    AFHTTPRequestOperationManager *testManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [testManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI网络");
                break;
        }
        
    }];
    //2、开始检测网络
    [testManager.reachabilityManager startMonitoring];
    
}
/**
 *  普通Post请求
 */
- (void)RequestInfoWithURL:(NSString *)url params:(NSDictionary *)pramas success:(block)success fail:(block)fail{
    //1、检查网络
    [self checkOutNetStatus];
    //2、创建基字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //3、为基字典添加需要的报文数据
    if (pramas) {
        [dic setValuesForKeysWithDictionary:pramas];
    }
    
    //4、发送请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //增加对html格式数据的解析
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] intValue] == 104) {
            
            //处理104错误
            return;
        }
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //处理请求失败错误
        fail(error);
    }];
    
}
/**
 *  上传数据
 */
- (void)upInfoWithURL:(NSString *)url params:(NSDictionary *)pramas data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)type success:(block)success fail:(block)fail{
    //1、检查网络
    [self checkOutNetStatus];
    //2、创建基字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //3、为基字典添加需要的报文数据
    if (pramas) {
        [dic setValuesForKeysWithDictionary:pramas];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //增加对html格式数据的解析
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (data) {
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
    
}
/**
 *  下载数据
 */
- (void)downLoadWithStr:(NSString *)str fileName:(NSString *)fileName completionHandler:(void(^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionBlock{
    [self checkOutNetStatus];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *temp = [response.suggestedFilename componentsSeparatedByString:@"."].lastObject;
        //设置下载路径(cache文件夹)
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, temp]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        completionBlock(response,filePath,error);
        
    }];
    [downloadTask resume];}
/**
 *  创建断点下载任务
 *
 *  @param url 下载URL
 */
- (void)creatDownLoadTaskWithURL:(NSString *)url DownLoadingHandler:(downLoadingBlock)dlingBlock completionHandler:(block)completionBlock{
    self.downLoadUrl = url;
    self.dlingBlock = dlingBlock;
    [self resumeDownLoadTask];
}
/**
 *  恢复下载
 */
- (void)resumeDownLoadTask{
    [self checkOutNetStatus];
    NSURL *URL = [NSURL URLWithString:self.downLoadUrl];
    // 1.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 3.下载
     self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
/**
 *  暂停下载
 */
- (void)pauseDownLoadTask{
    
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - <NSURLConnectionDelegate>
/**
 *  接收到响应头，即将开始下载
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //若非第一次下载直接返回
    if (self.currentLength) return;
    
    // 文件路径
    if (!self.downLoadPath) {
        self.downLoadPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    self.downLoadPath = [self.downLoadPath stringByAppendingPathComponent:response.suggestedFilename];
    // 创建一个空的文件到沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:self.downLoadPath contents:nil attributes:nil];
    
    // 创建一个用来写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.downLoadPath];
    
    // 获得文件的总大小
    _totalLength = response.expectedContentLength;
}
/**
 *  正在下载
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //将句柄移动到文件最后
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计文件的长度
    _currentLength += data.length;
//    NSLog(@"%f", ((double)_currentLength) / _totalLength);
    self.dlingBlock(_currentLength, _totalLength);
    
}
/**
 *  下载完毕
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _currentLength = 0;
    _totalLength = 0;
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    
}


@end
