//
//  SCReviseViewController.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/3/3.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCReviseViewDelegate <NSObject>

-(void)changeContent:(NSString *)text AndTag:(int)tag;

@end


@interface SCReviseViewController : UIViewController

@property (nonatomic, strong) NSString *infomation;
@property (nonatomic, strong) NSString *placeHoder;

@property (nonatomic) int tag;

@property (nonatomic ,weak) id<SCReviseViewDelegate> delegate;

@end
