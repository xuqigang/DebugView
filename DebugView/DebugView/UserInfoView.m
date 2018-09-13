//
//  UserInfoView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "UserInfoView.h"
#import "DebugManager.h"
@interface UserInfoView ()
{
    CGFloat _statusBarHeight;
}
@end
@implementation UserInfoView

+ (instancetype)viewInstance{
    CGRect frame = [UIScreen mainScreen].bounds;
    return [[UserInfoView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setTitle:@"返回" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    closeButton.frame = CGRectMake(16, _statusBarHeight, 44, 44);
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 62)/2.0, _statusBarHeight, 62, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"用户信息";
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(closeButton.frame), self.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    //从plist中获取token   key需要自己定义
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]];
    UIView *tokenView = [self getRowViewWithTitle:@"Token:" content:token];
    tokenView.frame = CGRectMake(tokenView.frame.origin.x, CGRectGetMaxY(closeButton.frame) + 10, tokenView.frame.size.width, tokenView.frame.size.height);
    [self addSubview:tokenView];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
    
    UIView *userIdView = [self getRowViewWithTitle:@"UserId:" content:userId];
    userIdView.frame = CGRectMake(tokenView.frame.origin.x, CGRectGetMaxY(tokenView.frame) + 10, userIdView.frame.size.width, userIdView.frame.size.height);
    [self addSubview:userIdView];
    
}

- (UIView*)getRowViewWithTitle:(NSString*)title content:(NSString*)text {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 0, self.frame.size.width - 16 * 2, 44)];
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCopy:)];
    [view addGestureRecognizer:longGes];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor lightTextColor];
    titleLabel.text = title;
    titleLabel.tag = 11;
    [view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, self.frame.size.width - 16 * 2 - CGRectGetWidth(titleLabel.frame), 44)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor lightTextColor];
    contentLabel.text = text;
    contentLabel.tag = 22;
    [view addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightTextColor];
    [view addSubview:lineView];
    return view;
}

- (void)closeButtonClicked:(UIButton*)button{
    [self dismissView];
}
- (void)longPressCopy:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *view = [gestureRecognizer view];
        UILabel *contentLabel = (UILabel*)[view viewWithTag:22];
        if (contentLabel.text && contentLabel.text.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = contentLabel.text;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已复制到粘贴板" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)showInView:(UIView*)view{
    self.frame = CGRectMake(view.frame.size.width, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismissView{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
