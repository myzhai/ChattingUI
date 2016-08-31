//
//  MessageFrame.h
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MessageModel;

@interface MessageFrame : NSObject

@property(nonatomic,assign,readonly) CGRect timeFrame;
@property(nonatomic,assign,readonly) CGRect textFrame;
@property(nonatomic,assign,readonly) CGRect iconFrame;

@property(nonatomic,assign,readonly) CGFloat cellHeight;

@property(nonatomic,strong) MessageModel *message;

@end
