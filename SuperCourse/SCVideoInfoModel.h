//
//  SCVideoInfoModel.h
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCVideoInfoModel : NSObject

@property (nonatomic, strong) NSString *les_url;
@property (nonatomic, strong) NSString *les_name;
@property (nonatomic, strong) NSString *les_size;
@property (nonatomic, assign) float les_alltime;
@property (nonatomic, strong) NSMutableArray *videoSubTitles;
@property (nonatomic, strong) NSMutableArray *studentSubTitle;
@property (nonatomic, strong) NSMutableArray *videoLinks;
@property (nonatomic, assign) NSTimeInterval oversty_time;

- (instancetype)initWithVideoUrl:(NSString *)url AndTitle:(NSString *)title AndFileSize:(NSString *)fileSize AndSubTitles:(NSMutableArray *)subTitles AndLinks:(NSMutableArray *)links;

@end
