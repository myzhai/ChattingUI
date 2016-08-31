//
//  MessageCell.m
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import "MessageFrame.h"

@interface MessageCell ()

@property(nonatomic,weak) UILabel *timeView;
@property(nonatomic,weak) UIImageView *iconView;
@property(nonatomic,weak) UIButton *textView;

@end

@implementation MessageCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"chattingCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *timeView = [[UILabel alloc]init];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        self.timeView.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UIButton *textView = [[UIButton alloc]init];
        [self.contentView addSubview:textView];
        self.textView = textView;
        self.textView.titleLabel.font = [UIFont systemFontOfSize:16];
        self.textView.titleLabel.numberOfLines = 0;
        [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.textView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setData{
    MessageModel *message = self.messageFrame.message;
    
    self.timeView.text = message.time;
    
    if (message.type == MessageModelTypeMe) {
        self.iconView.image = [UIImage imageNamed:@"0"];
    } else {
        self.iconView.image = [UIImage imageNamed:@"1"];
    }
    
    [self.textView setTitle:message.text forState:UIControlStateNormal];
    if (message.type == MessageModelTypeMe) {
        [self.textView setBackgroundImage:[self resizeImageWithImageName:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[self resizeImageWithImageName:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
    } else {
        [self.textView setBackgroundImage:[self resizeImageWithImageName:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[self resizeImageWithImageName:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
    }
}

- (void)setSubviewsFrame{
    self.timeView.frame = self.messageFrame.timeFrame;
    self.iconView.frame = self.messageFrame.iconFrame;
    self.textView.frame = self.messageFrame.textFrame;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    _messageFrame = messageFrame;
    
    [self setData];
    [self setSubviewsFrame];
}

- (UIImage *)resizeImageWithImageName:(NSString *)imageName{
    UIImage *originalImage = [UIImage imageNamed:imageName];
    CGFloat w = originalImage.size.width * 0.5;
    CGFloat h = originalImage.size.height * 0.5;
    return [originalImage resizableImageWithCapInsets:UIEdgeInsetsMake(w, h, w, h) resizingMode:UIImageResizingModeStretch];
}

@end
