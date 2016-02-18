//
//  APIClient.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/30.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface APIClient : AFHTTPRequestOperationManager

+(instancetype)sharedClient;

@end
