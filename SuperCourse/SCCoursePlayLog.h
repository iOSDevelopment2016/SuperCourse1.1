//
//  SCCoursePlayLog.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/2.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCoursePlayLog : NSObject


@property (nonatomic, strong) NSString *studyles_id; // 课程内码
@property (nonatomic, strong) NSString *is_ready; // 上次是否播放完毕
@property (nonatomic, assign) CGFloat bgsty_time;
@property (nonatomic, assign) CGFloat lastplay_time;
@property (nonatomic, strong) NSString *les_id;
@property (nonatomic, assign) CGFloat oversty_time;
@property (nonatomic ,strong) NSString *num;
@property (nonatomic, strong) NSString *stu_id;

@end
