//
//  MusicListView.h
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import <UIKit/UIKit.h>
//声明协议

@protocol MusicDelegate <NSObject>
//当model改变，通过这个方法可以获知 改变的内容
-(void)musicModelDidChangedWithModelsArray:(NSArray *) modelsArray;

//当cell被点击了 通过这个方法通知viewController
-(void) musicCellDidSelectedWithIndex:(NSInteger) index;

@end

 
 
@interface MusicListView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *musicModelsArray;  //保存音乐的models

@property (nonatomic, assign) id<MusicDelegate> delegate;

@end
