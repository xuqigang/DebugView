//
//  NetworkingDetailsView.h
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/4.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkingDetailsView : UIView
@property (nonatomic, strong) NSDictionary *networkingData;
+ (instancetype)viewInstance;
- (void)showInView:(UIView*)view;
@end
