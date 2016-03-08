//
//  SCVideoSubTitleMode.m
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCVideoSubTitleMode.h"

@interface SCVideoSubTitleMode ()



@end

@implementation SCVideoSubTitleMode

- (instancetype)initWithTitle:(NSString *)title AndBeginTime:(float)beginTime
{
    self = [super init];
    if (self) {
        self.subtitle = title;
        self.bg_time = beginTime;
    }
    return self;
}

@end
