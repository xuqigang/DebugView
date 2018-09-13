//
//  DebugView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/3.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "DebugView.h"
#import "UserInfoView.h"
#import "NetworkingView.h"
#import "VersionView.h"
#import "SandboxView.h"

@interface DebugView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _statusBarHeight;
    NSArray *_dataSource;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DebugView

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
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    closeButton.frame = CGRectMake(16, _statusBarHeight, 44, 44);
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 80)/2.0, _statusBarHeight, 80, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Config";
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.frame.size.width, 0.75)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame),self.frame.size.width,  CGRectGetHeight(self.frame) - CGRectGetMaxY(lineView.frame));
}

- (void)setupData{
    _dataSource = @[@"用户信息",@"网络接口",@"沙盒路径",@"版本信息"];
}



- (void)layoutSubviews{
    [super layoutSubviews];
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _statusBarHeight + 44,CGRectGetWidth(self.frame),  CGRectGetHeight(self.frame) - _statusBarHeight - 44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 500;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.userInteractionEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)closeButtonClicked:(UIButton*)button{
    self.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = _dataSource[indexPath.row];
    if ([title isEqualToString:@"用户信息"]){
        
        UserInfoView * info = [UserInfoView viewInstance];
        [info showInView:self];
        
    } else if([title isEqualToString:@"网络接口"]){
        NetworkingView *networking = [NetworkingView viewInstance];
        [networking showInView:self];
    } else if([title isEqualToString:@"沙盒路径"]){
        SandboxView *sanbox = [SandboxView viewInstance];
        [sanbox showInView:self];
    } else {
        VersionView *version = [VersionView viewInstance];
        [version showInView:self];
    }
}
- (void)dealloc{
    NSLog(@"%@已经释放",NSStringFromClass([self class]));
}
@end
