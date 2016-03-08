//
//  SCVideoInfoModel.m
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCVideoInfoModel.h"

@interface SCVideoInfoModel ()




@end


@implementation SCVideoInfoModel

- (instancetype)initWithVideoUrl:(NSString *)url AndTitle:(NSString *)title AndFileSize:(NSString *)fileSize AndSubTitles:(NSMutableArray *)subTitles AndLinks:(NSMutableArray *)links
{
    self = [super init];
    if (self) {
        self.les_size = fileSize;
        self.videoLinks = links;
        self.videoSubTitles = subTitles;
        self.les_name = title;
        self.les_url = url;
    }
    return self;
}
@end
