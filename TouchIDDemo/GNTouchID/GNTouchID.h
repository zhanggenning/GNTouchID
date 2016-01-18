//
//  GNTouchID.h
//  GNTouchID
//
//  Created by zhanggenning on 16/1/18.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>

@protocol GNTouchIdProtocol;

@interface GNTouchID : LAContext

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *fallbackTitle;
@property (nonatomic, weak) id <GNTouchIdProtocol> delegate;

- (void)startTouchIDWithMessage:(NSString *)message fallbackTitle:(NSString *)fallbackTitle delegate:(id<GNTouchIdProtocol>)delegate;

@end


@protocol GNTouchIdProtocol <NSObject>

/**
 *  认证成功
 */
- (void)touchIdAuthorizeSuccess;

/**
 *  认证失败
 */
- (void)touchIdAuthorizeFail;

/**
 *  不支持TouchId
 */
- (void)touchIdNotSupported;

@end