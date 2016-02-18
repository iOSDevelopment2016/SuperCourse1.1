//
//  AppDelegate.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "AppDelegate.h"
#import "SCCustomNavigationController.h"
#import "SCRootViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SCRootViewController *rootVC = [[SCRootViewController alloc]init];
    
    SCCustomNavigationController *nav = [[SCCustomNavigationController alloc]initWithRootViewController:rootVC];
    
    self.window.rootViewController = nav;
    
    //初始化用户标示
    [self initUserSession];
    
    //开启网络状态指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return YES;
}

-(void)initUserSession{
    NSString *userSession = [[NSUserDefaults standardUserDefaults] objectForKey:UserSessionKey];
    if (userSession) {
        self.userSession = userSession;
        self.userPsw = [[NSUserDefaults standardUserDefaults] objectForKey:UserPswKey];
        self.userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:UserPhoneKey];
        self.playLog =  [[NSUserDefaults standardUserDefaults] objectForKey:PlayLogKey];
    }else{
        self.userSession = UnLoginUserSession;
    }
}


//监测网络状态
-(NSString *)monitorWebState
{
    __block NSString *state;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                state = @"Wan";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                state = @"Wifi";
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
                state = @"NoWeb";
                break;
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return state;
}

- (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2g";
                    break;
                case 2:
                    state = @"3g";
                    break;
                case 3:
                    state = @"4g";
                    break;
                case 5:
                {
                    state = @"wifi";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
