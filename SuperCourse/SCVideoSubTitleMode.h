//
//  SCVideoSubTitleMode.h
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVideoSubTitleMode : NSObject

@property (nonatomic, strong)NSString *subtitle;
@property (nonatomic, strong)NSString *letter;
@property (nonatomic, assign)float bg_time;

-(instancetype)initWithTitle:(NSString *)title AndBeginTime:(float)beginTime;

@end
