//
//  Downloader.m
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import "Downloader.h"

@interface Downloader()
@property (nonatomic,copy) DownloadBlock block;

@end

static Downloader *instance = nil; //static之创建一次
@implementation Downloader

+(instancetype) sharedInstance {
    if(instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}

//下载的方法
-(void)downloadWithURL:(NSURL *)url complete:(DownloadBlock)block{
    //先保存block
    self.block = block;
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        //执行下载任务
        //创建一个request
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
        
       
        //获取数据
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
      //  NSData *data = [NSURLSession dataTaskWithRequest:request completionHandler:nil];
     
        /// 'sendSynchronousRequest:returningResponse:error:' is deprecated: first deprecated in iOS 9.0 - Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
      //  NSLog(@"path = %@",path);
        
        //将数据返回给调用者
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.block(data);
            
            //获取数据，解析数据，显示在视图上上
        });
        
    });
    
    
}

@end
