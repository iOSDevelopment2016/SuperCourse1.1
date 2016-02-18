//
//  HttpTool.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetWorking.h"
#import "APIClient.h"

@implementation HttpTool

//数据请求方法
+ (void)postWithparams:(NSDictionary *)params success:(Success)success failure:(Failure)failure{
    
    [[APIClient sharedClient] POST:@"/SuperCourseServer/index.php/Home/Index/index4ios/"
                  parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                       success(responseObject);
                               
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               
                       failure(error);
                               
      }];
    
}
@end
