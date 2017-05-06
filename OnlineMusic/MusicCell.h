//
//  MusicCell.h
//  OnlineMusic
//
//  Created by 李雀 on 2017/2/27.
//  Copyright © 2017年 李雀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
