//
//  SCPlayerViewController.h
//  SuperCourse
//
//  Created by Develop on 16/1/24.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCBaseViewController.h"
@class SCVIdeoInfo;


@protocol SCPlayerViewControllerDelegate <NSObject>

-(void)changeToLearn;

@end



@interface SCPlayerViewController : SCBaseViewController


@property (nonatomic, strong) NSString *lessonId;

@property (nonatomic ,weak) id<SCPlayerViewControllerDelegate>delegate;

@end
