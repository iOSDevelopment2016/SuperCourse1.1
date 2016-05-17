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
#import "SCDownloader.h"

@interface AppDelegate ()<WXApiDelegate,TencentApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1/MedicalKitServer/index.php/Home/"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"Accept"];
    NSDictionary *dict = @{@"user_phone":[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserPhoneKey"]};
    [manager POST:@"Prepare/returnPrepareForBasic/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"返回网络端准备信息失败--->%@",error);
    }];
    
    
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myDatabase.sqlite3"];
    [WXApi registerApp:@"wx81217d6c8f0d0fcd"];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    self.pram=0;
    self.download = [[SCDownloader alloc]init];
    
    self.program=@"";
    self.mark=@"";
   // self.download=[[SCDownloadConditionViewController alloc]init];
    
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
    //self.program= [[NSUserDefaults standardUserDefaults] objectForKey:ProgramKey];
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

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if (YES == [TencentApiInterface canOpenURL:url delegate:self])
    {
       return [TencentApiInterface handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if (YES == [TencentApiInterface canOpenURL:url delegate:self])
    {
       return [TencentApiInterface handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
//}
//
//-(void) onReq:(BaseReq *)req{
//    
//}
//

//-(void) onReq:(BaseReq*)req
//{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSString *strMsg   = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 1000;
//        [alert show];
//        //[alert release];
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        WXMediaMessage *msg = temp.message;
//        
//        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
//        
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//        NSString *strMsg   = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        //[alert release];
//    }
//    else if([req isKindOfClass:[LaunchFromWXReq class]])
//    {
//        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg   = @"这是从微信启动的消息";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        //[alert release];
//    }
//}
//
//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        //[alert release];
//    }
//}
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
