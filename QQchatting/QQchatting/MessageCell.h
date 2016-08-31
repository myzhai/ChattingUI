//
//  MessageCell.h
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrame;

@interface MessageCell : UITableViewCell

@property(nonatomic,strong) MessageFrame *messageFrame;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
