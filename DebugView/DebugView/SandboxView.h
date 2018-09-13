//
//  SandboxView.h
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/5.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SandboxView : UIView

+ (instancetype)viewInstance;
- (void)showInView:(UIView*)view;

@end


@interface QGSendboxViewerModel : NSObject

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileCreationDate;
@property (nonatomic, copy) NSString *fileModificationDate;
@property (nonatomic, strong) NSNumber *fileSize;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *filePath;

- (instancetype)initWithFileName:(NSString*)fileName filePath:(NSString*)filePath;

@end

@interface QGSendboxViewerCell : UITableViewCell

- (void)setupCellData:(QGSendboxViewerModel*)cellData;

@end
