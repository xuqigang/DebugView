//
//  SandboxView.m
//  DebugView
//
//  Created by Hanxiaojie on 2018/9/5.
//  Copyright © 2018年 XuQiGang. All rights reserved.
//

#import "SandboxView.h"
#import "DebugManager.h"
@interface SandboxView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_sandboxPath;
    NSIndexPath *_handlingIndexPath;  //正在操作的文件索引
    CGFloat _statusBarHeight;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) UIAlertController * alertController;

+ (instancetype)viewInstanceWithDirectory:(NSString*)directory;

@end
@implementation SandboxView
+ (instancetype)viewInstance{
    CGRect frame = [UIScreen mainScreen].bounds;
    SandboxView *view = [[self alloc] initWithDirectory:NSHomeDirectory() frame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    
    return view;
}
+ (instancetype)viewInstanceWithDirectory:(NSString*)directory{
    CGRect frame = [UIScreen mainScreen].bounds;
    SandboxView *view = [[self alloc] initWithDirectory:directory frame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    
    return view;
}

- (instancetype)initWithDirectory:(NSString *)directory frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sandboxPath = directory;
        _statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
        [self setupData];
        [self setupUI];
        [self setupUI];
        [self.tableView reloadData];
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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 35)/2.0, _statusBarHeight, 35, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"沙盒";
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
        [_tableView registerClass:[QGSendboxViewerCell class] forCellReuseIdentifier:@"QGSendboxViewerCell"];
        _tableView.userInteractionEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)setupData{
    self.tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray<NSString *> *contents = [fileManager contentsOfDirectoryAtPath:_sandboxPath error:&error];
    if (error == nil) {
        
        [self.tableViewDataSource removeAllObjects];
        
        __weak typeof(_sandboxPath) weakSandboxPath = _sandboxPath;
        [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            QGSendboxViewerModel *model = [[QGSendboxViewerModel alloc] initWithFileName:[NSString stringWithFormat:@"%@",obj] filePath:weakSandboxPath];
            [self.tableViewDataSource addObject:model];
        }];
        
    }
    
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
- (UIAlertController*)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"文件操作" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        //        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //            [self lookFile];
        //
        //        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"转发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self sendFile];
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteFile];
            
        }];
        [_alertController addAction:alertAction];
        //        [_alertController addAction:alertAction0];
        [_alertController addAction:alertAction1];
        [_alertController addAction:alertAction2];
    }
    return _alertController;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGSendboxViewerCell * cell ;
    cell = (QGSendboxViewerCell*)[tableView dequeueReusableCellWithIdentifier:@"QGSendboxViewerCell"];
    if (self.tableViewDataSource.count > indexPath.row) {
        [cell setupCellData:self.tableViewDataSource[indexPath.row]];
    } else {
        [cell setupCellData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.tableViewDataSource.count) {
        
        QGSendboxViewerModel *model = self.tableViewDataSource[indexPath.row];
        if ([model.fileType isEqualToString:@"NSFileTypeDirectory"]) {
            SandboxView *sendbox = [SandboxView viewInstanceWithDirectory:[model.filePath stringByAppendingFormat:@"/%@",model.fileName]];
            [sendbox showInView:self];
            NSLog(@"这是一个文件夹");
        } else {
            _handlingIndexPath = indexPath;
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self.alertController animated:YES completion:nil];
            NSLog(@"这是一个文件");
        }
    }
}

- (void)sendFile{
    
    QGSendboxViewerModel *model = self.tableViewDataSource[_handlingIndexPath.row];
    //分享的url
    NSURL *urlToShare = [NSURL fileURLWithPath:[model.filePath stringByAppendingFormat:@"/%@",model.fileName]];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

- (void)deleteFile{
    QGSendboxViewerModel *model = self.tableViewDataSource[_handlingIndexPath.row];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[model.filePath stringByAppendingFormat:@"/%@",model.fileName] error:&error];
    if (!error) {
        [self.tableViewDataSource removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[_handlingIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        NSLog(@"error = %@",error);
    }
}

@end

@implementation QGSendboxViewerModel

- (instancetype)initWithFileName:(NSString*)fileName filePath:(NSString*)filePath{
    if (self = [super init]) {
        self.fileName = fileName;
        self.filePath = filePath;
        NSDictionary *atts = [[NSFileManager defaultManager] attributesOfItemAtPath:[filePath stringByAppendingFormat:@"/%@",fileName] error:nil];
        [self setModelWithDictionary:atts];
    }
    return self;
}

- (void)setModelWithDictionary:(NSDictionary*)dic{
    NSLog(@"%@",dic);
    self.fileCreationDate = [NSString stringWithFormat:@"%@",dic[@"NSFileCreationDate"]];
    self.fileModificationDate = [NSString stringWithFormat:@"%@",dic[@"NSFileModificationDate"]];
    self.fileSize = dic[@"NSFileSize"];
    self.fileType = [NSString stringWithFormat:@"%@",dic[@"NSFileType"]];
    //    NSFileTypeRegular /NSFileTypeDirectory
}

@end

@interface QGSendboxViewerCell ()
{
    NSIndexPath *_indexPath;
}
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *fileSizeLabel;
@property (strong, nonatomic) UILabel *modifyDateLabel;

@end

@implementation QGSendboxViewerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel];
       
        [self.contentView addSubview:self.fileSizeLabel];
        
        [self.contentView addSubview:self.modifyDateLabel];
        
        CGRect frame = [UIScreen mainScreen].bounds;
        
        self.contentLabel.frame = CGRectMake(16, 10, frame.size.width - 16 * 2, 17);
        self.fileSizeLabel.frame = CGRectMake(16, CGRectGetMaxY(self.contentLabel.frame) + 2, frame.size.width * 0.4, 14);
        self.modifyDateLabel.frame = CGRectMake(CGRectGetMaxX(self.fileSizeLabel.frame) + 5, CGRectGetMaxY(self.contentLabel.frame) + 2, frame.size.width - 16 - CGRectGetMaxX(self.fileSizeLabel.frame) - 5, 14);
        
    }
    return self;
}

- (UILabel*)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

- (UILabel*)fileSizeLabel{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
        _fileSizeLabel.text = @"";
        _fileSizeLabel.textAlignment = NSTextAlignmentLeft;
        _fileSizeLabel.font = [UIFont systemFontOfSize:12];
        _fileSizeLabel.textColor = [UIColor lightTextColor];
    }
    return _fileSizeLabel;
}

- (UILabel*)modifyDateLabel{
    if (!_modifyDateLabel) {
        _modifyDateLabel = [[UILabel alloc] init];
        _modifyDateLabel.text = @"";
        _modifyDateLabel.textAlignment = NSTextAlignmentRight;
        _modifyDateLabel.font = [UIFont systemFontOfSize:12];
        _modifyDateLabel.textColor = [UIColor lightTextColor];
    }
    return _modifyDateLabel;
}
- (void)setupCellData:(QGSendboxViewerModel*)cellData{
    
    
    
    self.fileSizeLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    if (cellData) {
        self.contentLabel.text = cellData.fileName;
        self.modifyDateLabel.text = cellData.fileModificationDate;
        
        if ([cellData.fileType isEqualToString:@"NSFileTypeDirectory"]) {
            
            [self setupNumbersOfobjectForDirectory:[cellData.filePath stringByAppendingFormat:@"/%@",cellData.fileName]];
            NSLog(@"这是一个文件夹");
        } else {
            self.fileSizeLabel.text = [self transformedValue:cellData.fileSize];
            NSLog(@"这是一个文件");
        }
    } else {
        self.contentLabel.text = @"--";
    }
    
}

- (void)setupNumbersOfobjectForDirectory:(NSString*)sandboxPath{
    NSError *error;
    NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sandboxPath error:&error];
    if (error) {
        NSLog(@"%@",error.userInfo);
        self.fileSizeLabel.text = @"无效或者无权限访问的文件夹";
        self.fileSizeLabel.textColor = [UIColor redColor];
    } else {
        if ([contents count] > 0) {
            self.fileSizeLabel.text = [NSString stringWithFormat:@"%ld 个对象",[contents count]];
        } else {
            self.fileSizeLabel.text = @"空文件夹";
        }
    }
}

- (NSString*)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}
- (void)dealloc{
    NSLog(@"%@已经释放",NSStringFromClass([self class]));
}

@end
