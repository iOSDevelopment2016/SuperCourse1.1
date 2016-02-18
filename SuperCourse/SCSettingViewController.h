//
//  SCSettingViewController.h
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCBaseViewController.h"


@protocol SCSettingViewControllerDelegate <NSObject>

-(void)unlogin;

@end





@interface SCSettingViewController : SCBaseViewController

@property (nonatomic, strong) id<SCSettingViewControllerDelegate> delegate;

@end
