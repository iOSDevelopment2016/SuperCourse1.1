//
//  SCCourse.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCourse : NSObject

// 属性名必须和数据库中的字段名匹配
@property (nonatomic, strong) NSString *les_id;       //课程内码
@property (nonatomic, strong) NSString *les_name;    //课程名称
@property (nonatomic, strong) NSString *les_url;      //课程视频文件链接
//@property (nonatomic, strong) NSString *courseAbstract; //课程文字介绍
//@property (nonatomic, strong) NSArray *picArr;          //轮播图片Url列表


@property (nonatomic, strong) NSString *lessections_id;
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *les_alltime;
@property (nonatomic, strong) NSString *les_size;
@property (nonatomic, strong) NSString *operations;
@property (nonatomic, strong) NSString *permission;

//[{"les_id":"0002","lessections_id":"0001","order_num":"2","les_name":"\u9879\u76ee\u5185\u5bb9","les_url":"","les_alltime":"","les_size":"200M","operations":"\u89c6\u9891"}]}]


//+(instancetype)modelWithDict:(NSDictionary *)dict;


@end
