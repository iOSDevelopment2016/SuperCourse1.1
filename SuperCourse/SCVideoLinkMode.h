//
//  SCVideoLinkMode.h
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVideoLinkMode : NSObject

@property (nonatomic, strong)NSString *linkId;
@property (nonatomic, strong)NSString *hot_title;
@property (nonatomic, assign)float bg_time;
@property (nonatomic, strong)NSString *target_type; //跳转目标的类型（视频课程、网页）
@property (nonatomic, strong)NSString *link_les_id; //如果是视频课，这里是将要跳转的课程ID
@property (nonatomic, strong)NSString *web_url; //如果是网页，这里是将要跳转的网页地址

- (instancetype)initWithTitle:(NSString *)title AndBeginTime:(float)beginTime AndTargetType:(NSString *)targetType AndLessonId:(NSString *)lessonId AndWebUrl:(NSString *)webUrl;

@end
