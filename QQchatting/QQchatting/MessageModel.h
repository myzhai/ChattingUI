//
//  MessageModel.h
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MessageModelTypeMe,
    MessageModelTypeOther
} MessageModelType;

@interface MessageModel : NSObject

@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,assign) MessageModelType type;
@property(nonatomic,assign,getter=isHiddenTime) BOOL hiddenTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)messageWithDictionary:(NSDictionary *)dict;

+ (NSArray *)messagesArray;

@end
