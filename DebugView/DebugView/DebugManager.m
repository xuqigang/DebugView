//
//  DebugManager.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/3.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "DebugManager.h"
#import "DebugView.h"
#import "NetworkingManager.h"

@interface DebugManager ()
@property (nonatomic, strong) DebugView *debugView;
@end

@implementation DebugManager

#if DEBUG
+ (void)load
{
    [super load];
    [self shareInstance];
}
#endif

+ (instancetype)shareInstance
{
    static DebugManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver];
        [NetworkingManager shareInstance];
    }
    return self;
}

- (void)setupUI{
    if (self.window) {
        return;
    }
    ///初始化一个Window， 做到对业务视图无干扰。
    UIView *window = [[UIView alloc] initWithFrame: CGRectMake(20, UIScreen.mainScreen.bounds.size.height - 150, 44, 44)];
//    window.rootViewController = [UIViewController new];
//    window.rootViewController.view.backgroundColor = [UIColor clearColor];
//    window.rootViewController.view.userInteractionEnabled = NO;
//    ///设置为最顶层，防止 AlertView 等弹窗的覆盖
//    window.windowLevel = UIWindowLevelStatusBar - 1;
    ///默认为YES，当你设置为NO时，这个Window就会显示了
    window.hidden = NO;
    window.alpha = 1;
//    window.layer.zPosition = 2;
    ///防止释放，显示完后  要手动设置为 nil
    self.window = window;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 10;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 22;
    button.tag = 10;
    button.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    button.frame = CGRectMake(0,0, 44, 44);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].delegate.window addSubview:self.window];
    });
    
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
        [self setupUI];
        [self checkAppUpdateDate];
    }];
}

- (void)checkAppUpdateDate{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *local_app_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    NSString *local_app_build = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    if (local_app_version == nil || local_app_build == nil || [local_app_version compare:app_Version] != NSOrderedSame || [local_app_build compare:app_build] != NSOrderedSame) {
        
        NSLog(@"%ld %ld %ld",[local_app_version compare:app_Version],[local_app_build compare:app_build],NSOrderedSame);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",app_Version] forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",app_build] forKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:[self getCurrentTimes] forKey:@"AppUpdateDate"];
    }
}

-(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

- (DebugView*)debugView{
    if (_debugView == nil) {
        _debugView = [[DebugView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _debugView;
}

- (void)buttonClicked:(UIButton*)button{
    
    if (button.selected == NO) {
        [[UIApplication sharedApplication].delegate.window insertSubview:self.debugView belowSubview:self.window];
    } else {
        [self.debugView removeFromSuperview];
        self.debugView = nil;
    }
    button.selected = !button.selected;
}

@end
