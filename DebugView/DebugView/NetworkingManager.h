//
//  DataManager.h
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingManager : NSObject

@property (nonatomic, assign) NSUInteger maxCount;  //数据最大存储量
+ (instancetype)shareInstance;
- (void)addURLSessionTask:(NSURLSessionTask*)task;
- (NSArray*)getNetworkingTask;

@end
