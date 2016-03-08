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

-(void)updateHistoryInfo;

@end



@interface SCPlayerViewController : SCBaseViewController

@property (nonatomic, strong) NSMutableArray *cutScreenImageArr;
@property (nonatomic, strong) NSString *lessonId;

@property (nonatomic ,weak) id<SCPlayerViewControllerDelegate>delegate;
@property(nonatomic) CGFloat brightness NS_AVAILABLE_IOS(5_0);        // 0 .. 1.0, where 1.0 is maximum brightness. Only supported by main screen.
@end