//
//  Downloader.h
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^DownloadBlock)(NSData *resultData);
@interface Downloader : NSObject

//创建单例
//获取类的一个对象
+(instancetype) sharedInstance ;

-(void)downloadWithURL:(NSURL *)url complete:(DownloadBlock)block;
@end
