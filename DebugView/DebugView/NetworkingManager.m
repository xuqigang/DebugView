//
//  DataManager.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "NetworkingManager.h"
#define AFNetworkingEnabled 1

#if AFNetworkingEnabled
#import "AFNetworking.h"
#endif

@interface NetworkingManager ()
{
    NSMutableArray *_taskArray;
}
@end

@implementation NetworkingManager
+ (instancetype)shareInstance{
    static NetworkingManager *instance = nil;
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
        self.maxCount = 20;
        _taskArray = [NSMutableArray arrayWithCapacity:self.maxCount];
        [self addObserver];
    }
    return self;
}
- (void)addObserver{
#if AFNetworkingEnabled
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingTaskDidCompleteNotification:) name:AFNetworkingTaskDidCompleteNotification object:nil];
#endif
}
- (void)addURLSessionTask:(NSURLSessionTask*)task userInfo:(NSDictionary*)userInfo{
    
    if (task && [task isKindOfClass:[NSURLSessionTask class]] && userInfo) {
        if (_taskArray.count >= self.maxCount) {
            [_taskArray removeLastObject];
        }
        [_taskArray insertObject:@{@"SessionTask":task,@"UserInfo":userInfo} atIndex:0];
    }
}
- (NSArray*)getNetworkingTask{
    return [_taskArray copy];
}

#pragma mark - networkingTaskDidCompleteNotification
- (void)networkingTaskDidCompleteNotification:(NSNotification*)notitication{
    [self addURLSessionTask:notitication.object userInfo:notitication.userInfo];
}

@end
