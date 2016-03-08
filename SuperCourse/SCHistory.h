//
//  SCHistory.h
//  SuperCourse
//
//  Created by 李昶辰 on 16/2/2.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHistory : NSObject

@property (nonatomic, assign)CGFloat  bgsty_time;
@property (nonatomic, strong)NSString* is_ready;
@property (nonatomic, assign)CGFloat lastplay_time;
@property (nonatomic, assign)CGFloat oversty_time;
@property (nonatomic ,strong)NSString* les_id;
@property (nonatomic ,strong)NSString* stu_id;
@property (nonatomic ,strong)NSString* num;
@property (nonatomic ,strong)NSString* les_name;
@end

