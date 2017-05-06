//
//  Helper.m
//  OnlineMusic
//
//  Created by 李雀 on 2017/4/1.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSString *)timeStringWithLength:(int)totalLength {
    int minute = totalLength /60;
    int second = totalLength % 60;
    NSString *timeString = [NSString stringWithFormat:@"%@%d:%@%d",minute < 9 ? @"0":@"",minute,second < 9?@"0":@"",second];
    return timeString;
    
}


@end
