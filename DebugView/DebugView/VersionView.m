//
//  VersionView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/5.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "VersionView.h"
@interface VersionView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _statusBarHeight;
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation VersionView
+ (instancetype)viewInstance{
    CGRect frame = [UIScreen mainScreen].bounds;
    return [[self alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
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
    titleLabel.text = @"版本信息";
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.userInteractionEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)setupData{
    
    _dataSource = [NSMutableArray arrayWithCapacity:20];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSLog(@"%@",infoDictionary);
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    NSDictionary *model1 = @{@"应用名称":app_Name};
    [_dataSource addObject:model1];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *model2 = @{@"version":app_Version};
    [_dataSource addObject:model2];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSDictionary *model3 = @{@"Build":app_build};
    [_dataSource addObject:model3];
    
    NSString *app_update = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUpdateDate"];
    NSDictionary *model33 = @{@"最近更新":[NSString stringWithFormat:@"%@",app_update]};
    [_dataSource addObject:model33];
    
    
    
    //手机序列号
//    NSString* identifierNumber = [[UIDevice currentDevice].sy];
//    NSDictionary *model4 = @{};
//    [_dataSource addObject:model4];
//    NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSDictionary *model4 = @{@"设备用户名":userPhoneName};
    [_dataSource addObject:model4];
    NSString* systemName = [[UIDevice currentDevice] systemName];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSDictionary *model6 = @{@"操作系统":[NSString stringWithFormat:@"%@ %@",systemName,phoneVersion]};
    [_dataSource addObject:model6];
//    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSDictionary *model7 = @{@"手机型号":phoneModel};
    [_dataSource addObject:model7];
//    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSDictionary *model8 = @{@"国际化区域名称":localPhoneModel};
    [_dataSource addObject:model8];
    
    NSString* idfvModel = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSDictionary *model9 = @{@"IdentifierForVendor":idfvModel};
    [_dataSource addObject:model9];

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
    NSString *key = model.allKeys[0];
    id value = [model objectForKey:model.allKeys[0]];
    NSString *text = [NSString stringWithFormat:@"%@ : %@",key,value];
    if (text != nil && text.length > 0) {
        CGFloat height = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + 30;
        return height;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *model = [_dataSource objectAtIndex:indexPath.row];
    NSString *key = model.allKeys[0];
    id value = [model objectForKey:model.allKeys[0]];
    NSString *text = [NSString stringWithFormat:@"%@ : %@",key,value];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
