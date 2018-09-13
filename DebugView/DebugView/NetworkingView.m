//
//  NetworkingView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "NetworkingView.h"
#import "NetworkingManager.h"
#import "NetworkingDetailsView.h"
#import "DebugManager.h"

@interface NetworkingView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _statusBarHeight;
    NSArray *_dataSource;
}
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation NetworkingView

+ (instancetype)viewInstance{
    CGRect frame = [UIScreen mainScreen].bounds;
    return [[NetworkingView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
        [self setupData];
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
    titleLabel.text = @"网络接口";
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame),self.frame.size.width,  CGRectGetHeight(self.frame) - CGRectGetMaxY(lineView.frame));
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _statusBarHeight + 44,CGRectGetWidth(self.frame),  CGRectGetHeight(self.frame) - _statusBarHeight - 44) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 500;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.userInteractionEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)setupData{
    _dataSource = [[NetworkingManager shareInstance] getNetworkingTask];
}
- (void)closeButtonClicked:(UIButton*)button{
    [self dismissView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *model = [_dataSource objectAtIndex:indexPath.row];
    NSURLSessionTask *task = [model objectForKey:@"SessionTask"];
    NSString *text = task.currentRequest.URL.absoluteString;
    if (text != nil && text.length > 0) {
        CGFloat height = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + 30;
        return height;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor lightTextColor];
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor blackColor];
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCopy:)];
        [cell addGestureRecognizer:longGes];
    }
    
   
    NSDictionary *model = [_dataSource objectAtIndex:indexPath.row];
    NSURLSessionTask *task = [model objectForKey:@"SessionTask"];
    
    NSDictionary *userInfo = [model objectForKey:@"UserInfo"];
    id error = [userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey];
    if (error) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor lightTextColor];
    }
    
    cell.textLabel.text = task.currentRequest.URL.absoluteString;
 
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NetworkingDetailsView *detailsView = [NetworkingDetailsView viewInstance];
    detailsView.networkingData = [_dataSource objectAtIndex:indexPath.row];;
    [detailsView showInView:self];
}

- (void)longPressCopy:(UIGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UITableViewCell *view = (UITableViewCell*)[gestureRecognizer view];
        UILabel *contentLabel = view.textLabel;
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

- (void)dealloc{
    NSLog(@"%@已经释放",NSStringFromClass([self class]));
}
@end
