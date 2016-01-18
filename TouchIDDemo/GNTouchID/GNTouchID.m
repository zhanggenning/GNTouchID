//
//  GNTouchID.m
//  GNTouchID
//
//  Created by zhanggenning on 16/1/18.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "GNTouchID.h"

@implementation GNTouchID

- (instancetype)init
{
    if (self = [super init])
    {
        _message = @"";
        _fallbackTitle = @"";
    }
    return self;
}


- (void)processError:(NSError *)error
{
    if (!error)
    {
        return;
    }
    
    switch (error.code)
    {
        case LAErrorAuthenticationFailed:
        {
            NSLog(@"Touch Id 认证失败");
            break;
        }
        case LAErrorUserCancel:
        {
            NSLog(@"Touch Id 认证取消(用户点击了取消)");
            break;
        }
        case LAErrorUserFallback:
        {
            NSLog(@"在Touch Id 对话框中点击输入密码按钮");
            break;
        }
        case LAErrorSystemCancel:
        {
            NSLog(@"在验证Touch Id过程中被系统取消，例如突然来电话，按了Home键，锁屏..");
            break;
        }
        case LAErrorTouchIDNotEnrolled:
        {
            NSLog(@"设备没有录入TouchID，无法启用TouchID");
            break;
        }
        case LAErrorPasscodeNotSet:
        {
            NSLog(@"设备没有设置密码，无法启用TouchID");
            break;
        }
        case LAErrorTouchIDNotAvailable:
        {
            NSLog(@"该设备的TouchID无效");
            break;
        }
        case LAErrorTouchIDLockout:
        {
            NSLog(@"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁");
            break;
        }
        case LAErrorAppCancel:
        {
            NSLog(@"当前软件被挂起取消了授权（如突然来了电话）");
            break;
        }
        case LAErrorInvalidContext:
        {
            NSLog(@"当前软件被刮起取消了授权（授权过程中，LAContext对象被释放）");
            break;
        }
        default:
            break;
    }
}

- (void)startTouchIDWithMessage:(NSString *)message fallbackTitle:(NSString *)fallbackTitle delegate:(id<GNTouchIdProtocol>)delegate
{
    self.message = message;
    self.fallbackTitle = fallbackTitle;
    self.delegate = delegate;

    NSError *error = nil;
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = _fallbackTitle;
    

    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:_message
                          reply:^(BOOL success, NSError * _Nullable error) {
                              
                              if (success)
                              {
                                  NSLog(@"认证成功");
                                  
                                  if (_delegate && [_delegate respondsToSelector:@selector(touchIdAuthorizeSuccess)])
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate touchIdAuthorizeSuccess];
                                      });
                                  }
                              }
                              else
                              {
                                  [self processError:error];
                                  
                                  if (_delegate && [_delegate respondsToSelector:@selector(touchIdAuthorizeFail)])
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [_delegate touchIdAuthorizeFail];
                                      });
                                  }
                              }
                              
                          }];
    }
    else
    {
        NSLog(@"设备不支持touch id");
        
        if (_delegate && [_delegate respondsToSelector:@selector(touchIdNotSupported)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate touchIdNotSupported];
            });
        }
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message ?: @"";
}

@end
