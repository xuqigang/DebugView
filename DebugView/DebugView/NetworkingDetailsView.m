//
//  NetworkingDetailsView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//
#import "NetworkingDetailsView.h"
#import "DebugManager.h"
#import <AFNetworking.h>
@interface NetworkingDetailsView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _statusBarHeight;
    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation NetworkingDetailsView

+ (instancetype)viewInstance{
    CGRect frame = [UIScreen mainScreen].bounds;
    return [[self alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 40)/2.0, _statusBarHeight, 40, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"详情";
    [self addSubview:titleLabel];
    
    
//    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareButton.backgroundColor = [UIColor clearColor];
//    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
//    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    shareButton.frame = CGRectMake(self.frame.size.width - 44 - 16, _statusBarHeight, 44, 44);
//    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shareButton];
    
    
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
- (void)setNetworkingData:(NSDictionary *)networkingData{
    _networkingData = networkingData;
    [self setupData];
}

- (void)setupData{
    
    _dataSource = [NSMutableArray arrayWithCapacity:2];
    
    NSURLSessionTask *sessionTask = [_networkingData objectForKey:@"SessionTask"];
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:10];
    NSURLRequest *request = (NSURLRequest*)sessionTask.currentRequest;
    if (request) {
        if (request.URL.absoluteString) {
            NSDictionary *value1 = @{@"URL":request.URL.absoluteString};
            [array1 addObject:value1];
        }
        if (request.HTTPMethod) {
            NSDictionary *value2 = @{@"HTTPMethod":request.HTTPMethod};
            [array1 addObject:value2];
        }
        if (request.HTTPBody) {
            NSDictionary *value3 = @{@"HTTPBody":[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]};
            [array1 addObject:value3];
        }
        
        
        NSArray *allHTTPHeaders = [request.allHTTPHeaderFields allKeys];
        [allHTTPHeaders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = @{obj:[request.allHTTPHeaderFields objectForKey:obj]};
            [array1 addObject:dic];
        }];
        [_dataSource addObject:array1];
    }
    
    
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:10];
    NSHTTPURLResponse *response = (NSHTTPURLResponse*)sessionTask.response;
    if (response) {
        NSDictionary *value1 = @{@"URL":response.URL.absoluteString};
        [array2 addObject:value1];
        NSDictionary *value2 = @{@"ResponseCode":@(response.statusCode)};
        [array2 addObject:value2];
        NSArray *allHTTPHeaders = [response.allHeaderFields allKeys];
        [allHTTPHeaders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = @{obj:[response.allHeaderFields objectForKey:obj]};
            [array2 addObject:dic];
        }];
        
    }
    
    
//    NSString * const AFNetworkingTaskDidCompleteSerializedResponseKey = @"com.alamofire.networking.task.complete.serializedresponse";
//    NSString * const AFNetworkingTaskDidCompleteResponseSerializerKey = @"com.alamofire.networking.task.complete.responseserializer";
//    NSString * const AFNetworkingTaskDidCompleteResponseDataKey = @"com.alamofire.networking.complete.finish.responsedata";
//    NSString * const AFNetworkingTaskDidCompleteErrorKey = @"com.alamofire.networking.task.complete.error";
//    NSString * const AFNetworkingTaskDidCompleteAssetPathKey = @"com.alamofire.networking.task.complete.assetpath";
    
    NSDictionary *userInfo = [_networkingData objectForKey:@"UserInfo"];
    
//    id data1 = [userInfo objectForKey:AFNetworkingTaskDidCompleteSerializedResponseKey];
//    if (data1) {
//        [array2 addObject:@{@"ResponseBody":[[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding]}];
//    }
    
    id data2 = [userInfo objectForKey:AFNetworkingTaskDidCompleteResponseSerializerKey];
    if (data2) {
        [array2 addObject:@{@"ResponseSerializer":NSStringFromClass([data2 class])}];
    }
    
    id data3 = [userInfo objectForKey:AFNetworkingTaskDidCompleteResponseDataKey];
    if (data3) {
        [array2 addObject:@{@"ResponseBody":[[NSString alloc] initWithData:data3 encoding:NSUTF8StringEncoding]}];
    }
    
    id data4 = [userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey];
    if (data4) {
        [array2 addObject:@{@"Error":[NSString stringWithFormat:@"%@",data4]}];
    }
    
    id data5 = [userInfo objectForKey:AFNetworkingTaskDidCompleteAssetPathKey];
    if (data5) {
        [array2 addObject:@{@"Body":data5}];
    }
    [_dataSource addObject:array2];
//    [[[_networkingData objectForKey:@"UserInfo"] allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        id data = [[self->_networkingData objectForKey:@"UserInfo"] objectForKey:obj];
//        if ([data isKindOfClass:[NSError class]]) {
//            NSString *string = [NSString stringWithFormat:@"%@",data];
//            [array2 addObject:@{@"Body ":string}];
//            NSLog(@"%@ data = %@",obj,data);
//        } else if ([data isKindOfClass:[NSData class]]){
//            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [array2 addObject:@{@"Body ":string}];
//        } else {
//
//        }
//
//    }];
//    NSLog(@"%@",[_networkingData objectForKey:@"UserInfo"]);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataSource[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [_dataSource objectAtIndex:indexPath.section];
    NSDictionary *model = array[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@",model.allKeys[0]];
    NSString *text = [NSString stringWithFormat:@"%@ :  %@",key,[model objectForKey:key]];
    if (text != nil && text.length > 0) {
        CGFloat height = [text boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + 30;
        return height;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor blackColor];
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCopy:)];
        [cell addGestureRecognizer:longGes];
    }
   
    NSArray *values = [_dataSource objectAtIndex:indexPath.section];
    NSDictionary *model = values[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@",model.allKeys[0]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ :  %@",key,[model objectForKey:key]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if ([key isEqualToString:@"Error"]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor lightTextColor];
    }
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, tableView.frame.size.width, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:17];
    if (section == 0) {
        label.text = @"请求预览";
    } else {
        label.text = @"响应预览";
    }
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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

