//
//  UIAlertController+SZYKit.h
//  iNote
//
//  Created by sunxiaoyuan on 15/12/3.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^confirm)(UIAlertAction *action);
typedef void (^cancle)(UIAlertAction *action);

@interface UIAlertController (SZYKit)

/*
 默认标题，完整的回调
 */
+(void)showAlertAtViewController:(UIViewController *)viewController
       withMessage:(NSString *)message
       cancelTitle:(NSString *)cancelButtonTitle
       confirmTitle:(NSString *)confirmButtonTitle
       cancelHandler:(cancle)cancle
       confirmHandler:(confirm)confirm;

+(void)showAlertAtViewController:(UIViewController *)viewController
                           title:(NSString *)title
                     message:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm;
+(void)showAlertAtViewController:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                    confirmTitle:(NSString *)confirmButtonTitle
                  confirmHandler:(confirm)confirm;

@end
