//
//  ViewController.m
//  GNTouchID
//
//  Created by zhanggenning on 16/1/18.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "ViewController.h"
#import "GNTouchID.h"

@interface ViewController ()<GNTouchIdProtocol>
{
    GNTouchID *_touchId;
}

@property (weak, nonatomic) IBOutlet UILabel *notice;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _touchId = [[GNTouchID alloc] init];

}
- (IBAction)start:(id)sender
{
   [_touchId startTouchIDWithMessage:@"开始TouchId" fallbackTitle:@"取消TouchId" delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- <GNTouchIdProtocol>
- (void)touchIdAuthorizeSuccess
{
    _notice.text = @"认证成功";
}

- (void)touchIdAuthorizeFail
{
    _notice.text = @"认证失败";
}

- (void)touchIdNotSupported
{
    _notice.text = @"设备不支持TouchId";
}

@end
