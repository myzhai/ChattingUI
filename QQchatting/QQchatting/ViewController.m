//
//  ViewController.m
//  QQchatting
//
//  Created by zhaimengyang on 15/6/28.
//  Copyright (c) 2015年 zhaimengyang. All rights reserved.
//

#import "ViewController.h"
#import "MessageModel.h"
#import "MessageFrame.h"
#import "MessageCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic,strong) NSMutableArray *messagesWithFrame;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;

@end

@implementation ViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (NSMutableArray *)messagesWithFrame{
    if (_messagesWithFrame == nil) {
        NSArray *messageArray = [MessageModel messagesArray];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (MessageModel *message in messageArray) {
            MessageFrame *messageWithFrame = [[MessageFrame alloc]init];
            
            MessageFrame *lastMessageWithFrame = [tempArray lastObject];
            MessageModel *lastMessage = lastMessageWithFrame.message;
            if ([message.time isEqualToString:lastMessage.time]) {
                message.hiddenTime = YES;
                
            }
            
            messageWithFrame.message = message;
            [tempArray addObject:messageWithFrame];
        }
        _messagesWithFrame = tempArray;
    }
    
    return _messagesWithFrame;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    self.inputView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyBoardDidChangeFrame:(NSNotification *)info{
    /*
     2015-06-29 15:29:08.330 QQchatting[2215:800684] {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 216}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 775}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 559}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
     }
     2015-06-29 15:29:08.339 QQchatting[2215:800684] {
     UIKeyboardAnimationCurveUserInfoKey = 0;
     UIKeyboardAnimationDurationUserInfoKey = 0;
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
     }
     2015-06-29 15:29:08.342 QQchatting[2215:800684] {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
     }
     */
    
    self.view.window.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    NSDictionary *userInfoDict = info.userInfo;
    CGRect keyBoardFrame = [userInfoDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat keyBoardTransformY = keyBoardFrame.origin.y - viewHeight;
    CGFloat duration = [userInfoDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyBoardTransformY);
    }];
}

- (void)addMessageWithText:(NSString *)text MessageModelType:(MessageModelType)type{
    NSDate *timeNow = [NSDate date];
    NSDateFormatter *timeformat = [[NSDateFormatter alloc]init];
    timeformat.dateFormat = @"HH:mm";
    NSString *timeStr = [timeformat stringFromDate:timeNow];
    
    MessageFrame *messageWithFrame = [[MessageFrame alloc]init];
    MessageModel *message = [[MessageModel alloc]init];
    
    message.time = timeStr;
    message.type = type;
    message.text = text;
    
    MessageFrame *lastMessageWithFrame = [self.messagesWithFrame lastObject];
    MessageModel *lastMessage = lastMessageWithFrame.message;
    if ([message.time isEqualToString:lastMessage.time]) {
        message.hiddenTime = YES;
    }
    
    messageWithFrame.message = message;
    [self.messagesWithFrame addObject:messageWithFrame];
    
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesWithFrame.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesWithFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [MessageCell messageCellWithTableView:tableView];
    cell.messageFrame = self.messagesWithFrame[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFrame *messageFrame = self.messagesWithFrame[indexPath.row];
    return messageFrame.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self addMessageWithText:textField.text MessageModelType:MessageModelTypeMe];
    
    textField.text = nil;
    return YES;
}

@end
