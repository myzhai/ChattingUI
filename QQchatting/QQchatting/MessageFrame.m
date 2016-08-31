//
//  MessageFrame.m
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import "MessageFrame.h"
#import "MessageModel.h"

@implementation MessageFrame

- (CGSize)textSizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (void)setMessage:(MessageModel *)message{
    _message = message;
    
    CGFloat padding = 10;
    
    if (message.hiddenTime == NO) {
        CGFloat timeW = 375;
        CGFloat timeH = 40;
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    CGFloat iconX = 0;
    if (message.type == MessageModelTypeMe) {
        iconX = 375 - padding - iconW;
    } else {
        iconX = padding;
    }
    CGFloat iconY = CGRectGetMaxY(_timeFrame);
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGSize textSize = [self textSizeWithText:message.text maxSize:CGSizeMake(200, MAXFLOAT) font:[UIFont systemFontOfSize:16]];
    CGSize textViewSize = CGSizeMake(textSize.width + 40, textSize.height + 40);
    CGFloat textX = 0;
    if (message.type == MessageModelTypeMe) {
        textX = iconX - padding - textViewSize.width;
    } else {
        textX = CGRectGetMaxX(_iconFrame) + padding;
    }
    CGFloat textY = iconY;
    _textFrame = CGRectMake(textX, textY, textViewSize.width, textViewSize.height);
    
    CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
    CGFloat textMaxY = CGRectGetMaxY(_textFrame);
    _cellHeight = (iconMaxY > textMaxY ? iconMaxY : textMaxY) + padding;
}

@end
