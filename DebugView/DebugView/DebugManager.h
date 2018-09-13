//
//  DebugManager.h
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/3.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugManager : NSObject
@property (nonatomic, strong) UIView* window;
+ (instancetype)shareInstance;
@end
