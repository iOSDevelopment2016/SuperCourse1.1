//
//  AppDelegate.h
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDownloader.h"
#import "FMDatabase.h"
#include "FMDatabaseQueue.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *userSession;
@property (strong ,nonatomic) NSString *userPsw;
@property (strong ,nonatomic) NSString *userPhone;

@property (strong ,nonatomic) NSString *playLog;

@property (strong ,nonatomic)SCDownloader *download;

@property (nonatomic,strong) NSString *program;

@property (nonatomic,strong) NSString *mark;
-(NSString *)monitorWebState;

- (NSString *)getNetWorkStates;
@property (nonatomic)float pram;

@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

@end

