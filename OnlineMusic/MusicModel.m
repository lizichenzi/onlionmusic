//
//  MusicModel.m
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/28.
//  Copyright © 2017年 李雀. All rights reserved.
/*
 @property (nonatomic, strong) NSString *title;
 @property (nonatomic, strong) NSString *artist;
 @property (nonatomic, strong) NSString *picture;
 @property (nonatomic, strong) NSString *length;
 @property (nonatomic, strong) NSString *url;
 
 */

#import "MusicModel.h"

@implementation MusicModel
-(instancetype) initWithDataDic:(NSDictionary *)dic withDataDic:(NSDictionary *)dict{
    if(self = [super init]) {
        self.title = dic[@"title"];
        self.artist = dic[@"author"];
        self.picture = dic[@"pic_small"];
        self.length = dic[@"file_duration"];
        self.url=dict[@"file_link"];
        
        //  NSString *string1 = @"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.play&songid=";
        //    self.url = [string1 stringByAppendingString:dic[@"song_id"]];
        //    self.url = @"http://yinyueshiting.baidu.com/data2/music/78db4eebcde37d790c60453a3ea3fae1/539385715/539385715.mp3?xcode=ac60e11a35322cf5f5d44a3a1acfff98";
    }
    return self;
}

@end

