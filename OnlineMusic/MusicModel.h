//
//  MusicModel.h
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/28.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface MusicModel : BaseModel

//属性变量名必须和下载的数据的字段名相同
@property (nonatomic, strong) NSString *title;  //歌名
@property (nonatomic, strong) NSString *artist; //歌手
@property (nonatomic, strong) NSString *picture; //图片
@property (nonatomic, strong) NSString *length;  //歌曲长度
@property (nonatomic, strong) NSString *url;     //歌曲下载地址



-(instancetype) initWithDataDic:(NSDictionary *) dic withDataDic:(NSDictionary *) dict;


@end
