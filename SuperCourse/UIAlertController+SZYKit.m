//
//  UIAlertController+SZYKit.m
//  iNote
//
//  Created by sunxiaoyuan on 15/12/3.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import "UIAlertController+SZYKit.h"

@implementation UIAlertController (SZYKit)


+(void)showAlertAtViewController:(UIViewController *)viewController
                     withMessage:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm{
    
    [self showAlertAtViewController:viewController title:@"提示" message:message cancelTitle:cancelButtonTitle confirmTitle:confirmButtonTitle cancelHandler:cancle confirmHandler:confirm];
}

+(void)showAlertAtViewController:(UIViewController *)viewController
                           title:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelButtonTitle
                    confirmTitle:(NSString *)confirmButtonTitle
                   cancelHandler:(cancle)cancle
                  confirmHandler:(confirm)confirm{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle(action);
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm(action);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
