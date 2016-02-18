//
//  SCWebViewController.h
//  SuperCourse
//
//  Created by 孙锐 on 16/1/31.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCBaseViewController.h"

@interface SCWebViewController : SCBaseViewController
@property (nonatomic, assign) float stopTime;

-(void)getUrl:(NSString *)url;

@end
