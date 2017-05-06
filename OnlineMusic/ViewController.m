//
//  ViewController.m
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import "ViewController.h"
#import "MusicListView.h"
#import "Downloader.h"
#import "MusicModel.h"
#import <NZCircularImageView.h>
#import "Helper.h"
#import <AVFoundation/AVFoundation.h>


#define kInvalid -1

@interface ViewController () <CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet NZCircularImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (nonatomic,strong) NSTimer *rotatingTimer;
@property (nonatomic,strong) MusicListView *listView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressImageView;

@property (nonatomic, strong) NSMutableArray *musicModelsArray;
@property (nonatomic,assign) NSInteger currentMusicIndex;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) ViewController *timeObserver; //当前类作为播放音乐的监听者
@property (weak, nonatomic) IBOutlet UISlider *Slider;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songer;

//当前播放的音乐模型
@property(nonatomic,strong) MusicModel *currentModel;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _currentMusicIndex = kInvalid;
    
    
    //创建一个定时器，每隔一段时间去访问rotate方法
    self.rotatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rotatingTimer forMode:NSRunLoopCommonModes];
    //创建播放列表
    self.listView = [[[NSBundle mainBundle] loadNibNamed:@"MusicListView" owner:nil options:nil] objectAtIndex:0];
    _listView.frame = CGRectMake(320-200, 52, 206, 348);
    _listView.alpha = 0;
    _listView.delegate = self;
    [self.view addSubview:_listView];
    
    
    //下载数据
   NSURL *url = [NSURL URLWithString:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=1&size=10&offset=0"];
    Downloader *d1 = [[Downloader alloc] init];
    
    [d1 downloadWithURL:url complete:^(NSData *resultData) {
        
        if(resultData != nil) {
        //把JSON数据转换成可以识别的字典
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
        //得到song对应的数组
            NSArray *songsArray = [dic objectForKey:@"song_list"];
            self.musicModelsArray = [NSMutableArray array];
            //可以遍历数组,每个数组的元素都是一首歌
            for(NSDictionary *songDic in songsArray) {
                //创建musicModel对象 ?? 因为每一首歌的数据都是用musicModel封装的
                NSString *string1 = @"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.play&songid=";
                string1 = [string1 stringByAppendingString:songDic[@"song_id"]];
                NSURL *urlt = [NSURL URLWithString:string1];
                Downloader *d = [[Downloader alloc] init];

                [d downloadWithURL:urlt complete:^(NSData *resultDatat) {
                    if(resultDatat != nil){
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultDatat options:NSJSONReadingMutableContainers error:nil];
                        MusicModel *model = [[MusicModel alloc] initWithDataDic:songDic withDataDic:dict[@"bitrate"]];
                       
                        //将当前这个音乐模型保存到数组里面
                     //   NSLog(@"%@",model.title);
                        [self.musicModelsArray addObject:model];
                        //将解析的数据传递给 MusicListView
                        self.listView.musicModelsArray = _musicModelsArray;
                      //  NSLog(@"%@",_musicModelsArray);
                    }
                }];

            }
        }

    }];
    
    
}



//实现图片的旋转效果
//弧度 = 度数 ／ 180 * M_PI
-(void)rotate {
    _coverImageView.transform = CGAffineTransformRotate(_coverImageView.transform, 0.5/180 * M_PI );
    
}


//监听右上方按钮的点击事件
- (IBAction)listButtonDidClicked:(id)sender {
    //通过透明度来判断
    if(_listView.alpha == 0) {
        //显示
        [UIView animateWithDuration:0.3 animations: ^{
            _listView.alpha = 0.8;
        }];
        
    } else {
        //隐藏(放大和渐变）
        [self hideMusicListView];
    }
}

//放大和渐变的动画组
-(void)hideMusicListView {
    //放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)];
    
    //渐变 1  0
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.8;
    opacityAnimation.toValue = @0;
    
    //因为两个动画要同时进行，所以要创建动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[scaleAnimation,opacityAnimation];
    groupAnimation.duration = 0.3;
    groupAnimation.delegate = self;
    groupAnimation.removedOnCompletion = NO; //执行完后是否要移除，不移除
    groupAnimation.autoreverses = NO;  //不需要原路返回，也就是透明度从1到0，执行完后是否要从0到1
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];  //先快后慢
    
    
    //添加动画
    [_listView.layer addAnimation:groupAnimation forKey:nil];
}

-(void)animationDidStart:(CAAnimation *)anim {
    //真正改变视图的透明度
    [UIView animateWithDuration:0.3 animations:^{
        _listView.alpha = 0;
    }];
}


#pragma mark ---Touch事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //获取触摸点
    CGPoint clickedPoint = [touch locationInView:self.view];
    
    //判断是否需要隐藏
    if(_listView.alpha == 0.8) {
    //判断触摸点的范围，只有在播放进度条的上方，点击才能隐藏列表视图
    if(clickedPoint.y < _progressImageView.frame.origin.y) {
        //可以响应触摸事件，进行隐藏
        [self hideMusicListView];
       }
    }
    [self changeProgressWidthWithPoint:clickedPoint];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //获取触摸点
    CGPoint clickedPoint = [touch locationInView:self.view];
    [self changeProgressWidthWithPoint:clickedPoint];
}

-(void)changeProgressWidthWithPoint:(CGPoint)clickedPoint {
    //手动调整进度
    if(clickedPoint.y >= _progressImageView.frame.origin.y && clickedPoint.y <= _progressImageView.frame.size.height + _progressImageView.frame.origin.y) {
        //重新设置progress的宽度
        _progressImageView.frame = CGRectMake(0, _progressImageView.frame.origin.y, clickedPoint.x, _progressImageView.frame.size.height);
    }
}

#pragma mark-- MusicDelegate
-(void)musicModelDidChangedWithModelsArray:(NSArray *)modelsArray {
    if(_currentMusicIndex != kInvalid ) {
        //取出index对应的model
        MusicModel *model = [modelsArray objectAtIndex:_currentMusicIndex];
        if (model.picture != nil) {
            //从网络路径加载图片
            NSURL *url = [NSURL URLWithString:model.picture];
            _coverImageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
        }
        else {
            _coverImageView.image = [UIImage imageNamed:@"album"];
        }
    }
    
    //同步一下，重新赋值
    self.musicModelsArray = [NSMutableArray arrayWithArray:modelsArray];
}

-(void)musicCellDidSelectedWithIndex:(NSInteger)index {
    //播放音乐
    [self playMusicAtIndex:index];
    
}

#pragma mark --点击音乐列表播放音乐
-(void)playMusicAtIndex:(NSInteger )index {
    _currentMusicIndex = index;
    //显示这首音乐的背景图片
    MusicModel *model = [_musicModelsArray objectAtIndex:index];
    if (model.picture != nil) {
        //从网络加载图片
        NSURL *url = [NSURL URLWithString:model.picture];
        _coverImageView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
        
    }
    else {
        _coverImageView.image = [UIImage imageNamed:@"album"];
    }
    
    //获取音乐的总长度
    int totalLength = [model.length intValue];
    _totalTimeLabel.text = [Helper timeStringWithLength:totalLength];
    
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:model.url]];
    
    //开始播放
    [_player play];
    //创建时间的间隔
  //  CMTime interval = CMTimeMake(1, 1);
    
    __weak ViewController *wSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)  queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(wSelf) sSelf = wSelf;
        
        //获取当前的播放时间
        CGFloat currentTime = CMTimeGetSeconds(sSelf.player.currentTime);
        
        //获取音频总时间
        CGFloat duration = CMTimeGetSeconds(sSelf.player.currentItem.duration);
        
        //显示当前的播放时间
        sSelf.currentTimeLabel.text = [Helper timeStringWithLength:currentTime];
        
        if(currentTime) {
            CGFloat progress = currentTime / duration;
            sSelf.Slider.value = progress;
        }
    }];
    
    //判断是否在播放音乐
    if(_timeObserver != nil) {
        //移除上一首音乐的监听
        [_player removeTimeObserver:_timeObserver];
        
    }

    
}


@end
