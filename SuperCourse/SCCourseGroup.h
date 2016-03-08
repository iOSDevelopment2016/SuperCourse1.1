//
//  SCCourseGroup.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCourseGroup : NSObject

@property (nonatomic, strong) NSString *lesgrouping_id;      //课程分组内码
@property (nonatomic, strong) NSString *lessections_name;   //课程分组标题


@property (nonatomic, strong) NSString *order_num;


@property (nonatomic, strong) NSMutableArray *lesarr;           //课程列表

//[{"lessections_id":"0000","order_num":"0","lessections_name":"Xcode\u4ecb\u7ecd","lesarr":

//+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
