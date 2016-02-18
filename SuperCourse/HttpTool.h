//
//  HttpTool.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id responseObject);
typedef void (^Failure)(NSError *error);

@interface HttpTool : NSObject

//数据请求方法
+ (void)postWithparams:(NSDictionary *)params success:(Success)success failure:(Failure)failure;


@end
