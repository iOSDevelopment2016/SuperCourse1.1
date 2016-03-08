//
//  SCDownlodaMode.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/18.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>
// @"CREATE TABLE IF NOT EXISTS DOWNLOADINFO (ID INTEGER PRIMARY KEY AUTOINCREASE, LESSON_NAME TEXT, LESSON_URL TEXT, LESSON_FILENAME TEXT, LESSON_SIZE TEXT, LESSON_DOWNLOADED TEXT, FINISHED TEXT)";

@interface SCDownlodaMode : NSObject

@property (nonatomic, strong) NSString *les_id;
@property (nonatomic, strong) NSString *les_name;
@property (nonatomic, strong) NSString *les_url;
//@property (nonatomic, strong) NSString *les_filename;
@property (nonatomic, strong) NSString *les_size;
@property (nonatomic, strong) NSString *les_downloading;
@property (nonatomic, strong) NSString *finished;

@end
