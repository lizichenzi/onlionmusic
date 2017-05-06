//
//  MusicListView.m
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import "MusicListView.h"
#import "MusicCell.h"
#import "MusicModel.h"
#import "Downloader.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kInvalid -1

@interface MusicListView()
@property (weak, nonatomic) IBOutlet UITableView *musicTableView;
@property (nonatomic, assign) NSInteger lastSelectedRow;    //初始化为 kInvalid -1

@end


@implementation MusicListView


//当xib加载完毕就会来调用这个方法
-(void)awakeFromNib {
    //设置代理本身
    _musicTableView.delegate = self;
    _musicTableView.dataSource = self;
    
    //初始化
    _lastSelectedRow = kInvalid;
}

//重写setter方法
-(void)setMusicModelsArray:(NSMutableArray *)musicModelsArray{
    if(_musicModelsArray != musicModelsArray) {
        _musicModelsArray = musicModelsArray;
    }
    //通知tableView刷新界面
    [self.musicTableView reloadData];
}

#pragma mark ----UITableViewDelegate && UITableViewDatasource
//有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicModelsArray.count;
}

//每行显示什么样子
-(MusicCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    //从队列里面查找是否有可以重复利用的cell
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil) {
        //没有，就自己创建
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:nil options:nil] lastObject];
    }
    
    //1.显示的序号 <10 01 02
    cell.numLabel.text = [NSString stringWithFormat:@"%@%ld",indexPath.row < 9 ? @"0" :@"",indexPath.row+1];
    
    //2.显示歌名
    //获取当前这一行对应的音乐的模型model
    MusicModel *model = [_musicModelsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.title;
   // [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"album"] options:SDW]
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"album"]];
    
    //通知viewcontroller model改变了
    if([_delegate respondsToSelector:@selector(musicModelDidChangedWithModelsArray:)]) {
        [_delegate musicModelDidChangedWithModelsArray:_musicModelsArray];
    }
    
    
    //判断是否应该显示或隐藏图片
    if (_lastSelectedRow == indexPath.row) {    //_lastSelectedRow初始化-1
        cell.iconImageView.hidden = NO; //显示图片
        cell.numLabel.hidden = YES; //隐藏序号

        
            }else {
        //隐藏图片，显示序号
        cell.iconImageView.hidden = YES;
        cell.numLabel.hidden = NO;
        
    }
    
    return  cell;
}

#pragma mark --UITableViewDelegate
//cell被选中了
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中,有个动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self changeCellStatusAtIndexPath:indexPath];
}

//实现cell选中的操作
-(void)changeCellStatusAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != _lastSelectedRow ) {
        //第一步获得indexPath对应的cell
        MusicCell *cell = (MusicCell *)[_musicTableView cellForRowAtIndexPath:indexPath];
        cell.iconImageView.hidden = NO; //图片显示
        cell.numLabel.hidden = YES;    //序号隐藏
        
        //如果此次选中的状态不是上次，选中将上一次选中的状态切换回来
        if (indexPath.row != _lastSelectedRow &&_lastSelectedRow != kInvalid) {
            NSIndexPath *oldPath = [NSIndexPath indexPathForRow:_lastSelectedRow inSection:0];
            MusicCell *cell = (MusicCell *)[_musicTableView cellForRowAtIndexPath:oldPath];
            cell.iconImageView.hidden = YES;  //图片隐藏
            cell.numLabel.hidden = NO;        //序号显示
        }
        
        //通知主界面 这个cell被点击了
        if([_delegate respondsToSelector:@selector(musicCellDidSelectedWithIndex:)]) {
            [_delegate musicCellDidSelectedWithIndex:indexPath.row];
        }
        
    }
    //记录上一次选中的值
    _lastSelectedRow = indexPath.row;
    
}

@end
