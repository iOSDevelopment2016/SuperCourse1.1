//
//  SCSettingViewController.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCSettingViewController.h"
#import "SCDownloadConditionViewController.h"
#import "SCAboutView.h"
#import "SCSelfConditionViewController.h"

//#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>


#import <TencentOpenAPI/QQApiInterface.h>

//#import "TQDQuickDialogController.h"
@interface SCSettingViewController ()<WXApiDelegate,TencentSessionDelegate>


@property (nonatomic ,strong) UIView                   *hubView;
@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong)UIButton   *selfConditidonBtn;
@property (nonatomic, strong)UIButton   *downloadConditionBtn;
@property (nonatomic, strong)UIButton   *memoryClearBtn;
@property (nonatomic, strong)UIButton   *extendBtn;
@property (nonatomic, strong)UILabel    *sizeLabel;
@property (nonatomic, strong)UIButton   *exitBtn;

//@property (retain, nonatomic) TencentOAuth *tencentOAuth;

@property (nonatomic)float size;

@property (nonatomic, strong)SCAboutView *aboutView;
@end

@implementation SCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105153909" andDelegate:self];
    
//    NSArray *permissions = [NSArray arrayWithObjects:
//                            kOPEN_PERMISSION_GET_USER_INFO,
//                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                            kOPEN_PERMISSION_ADD_ALBUM,
//                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                            kOPEN_PERMISSION_ADD_SHARE,
//                            kOPEN_PERMISSION_ADD_TOPIC,
//                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                            kOPEN_PERMISSION_GET_INFO,
//                            kOPEN_PERMISSION_GET_OTHER_INFO,
//                            kOPEN_PERMISSION_LIST_ALBUM,
//                            kOPEN_PERMISSION_UPLOAD_PIC,
//                            kOPEN_PERMISSION_GET_VIP_INFO,
//                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                            nil];
//    [self.tencentOAuth authorize:permissions];
    
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = UIThemeColor;
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    self.size = [self folderSizeAtPath:cachePath];
//    NSLog(@"%f",self.size);
    
    [self.view addSubview:self.backImageBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.selfConditidonBtn];
    [self.view addSubview:self.downloadConditionBtn];
    [self.view addSubview:self.memoryClearBtn];
    [self.view addSubview:self.extendBtn];
    [self.view addSubview:self.exitBtn];
    [self.view addSubview:self.sizeLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtn) name:@"UserDidLogin" object:nil];

}
//- (BOOL)onTencentReq:(TencentApiReq *)req
//{
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backImageBtn.frame=CGRectMake(40, 42, 20, 35);
    self.backBtn.frame=CGRectMake(55, 40, 100, 40);
    self.selfConditidonBtn.frame=CGRectMake(0, 100, self.view.width, HeightScale*125);
    self.downloadConditionBtn.frame=CGRectMake(0, 150+HeightScale*125, self.view.width, HeightScale*125);
    self.memoryClearBtn.frame=CGRectMake(0, 153+HeightScale*250, self.view.width, HeightScale*125);
    self.extendBtn.frame=CGRectMake(0, 200+HeightScale*375, self.view.width, HeightScale*125);
    self.exitBtn.frame=CGRectMake(self.view.width/2-350*WidthScale, 225+HeightScale*500, 700*WidthScale, 100*HeightScale);
    self.sizeLabel.frame=CGRectMake(self.view.width-200*WidthScale, 153+HeightScale*250, 200*WidthScale, HeightScale*125);
}
-(void)changeBtn{
    if([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession])
    {
//        [self.exitBtn setTitle:@" 登     陆 " forState:UIControlStateNormal];
//        [self.exitBtn addTarget:self action:@selector(loginDidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [self.exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}


#pragma mark - click
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selfConditidonBtnClick{
    SCSelfConditionViewController *selfCondition=[[SCSelfConditionViewController alloc]init];
    [self.navigationController pushViewController:selfCondition animated:YES];
}
-(void)downloadConditionBtnClick{
//    SCSettingViewController *setVC = [[SCSettingViewController alloc]init];
//    [self.navigationController pushViewController:setVC animated:YES];
    SCDownloadConditionViewController *downloadCondition=[[SCDownloadConditionViewController alloc]init];
    [self.navigationController pushViewController:downloadCondition animated:YES];
}
-(void)memoryClearBtnClick{
    //[self poseDownloads];
    [self removeCache];
    //[self.sizeLabel removeFromSuperview];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.size = [self folderSizeAtPath:cachePath];
    if(self.size>1024.0){
        self.size=self.size/1024.0;
        NSString *msg=[NSString stringWithFormat:@"%.1fM",self.size];
        self.sizeLabel.text=msg;
    }else{
        NSString *msg=[NSString stringWithFormat:@"%.1fK",self.size];
        self.sizeLabel.text=msg;
    }

    //[self.view addSubview:self.sizeLabel];
    //[self removeCache];
    [self posetMesseges];
}
-(void)toExtendBtnClick{
    
    [self.view addSubview:self.hubView];
    [self.view addSubview:self.aboutView];
    
}
-(void)exitBtnClick{
    ApplicationDelegate.userSession=UnLoginUserSession;
    
    //ApplicationDelegate.userSession = ApplicationDelegat;
    ApplicationDelegate.userPsw = nil;
    ApplicationDelegate.userPhone =nil;
    ApplicationDelegate.playLog=@"";
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    [defaultes removeObjectForKey:UserSessionKey];
    [defaultes removeObjectForKey:UserPswKey];
    [defaultes removeObjectForKey:UserPhoneKey];
    [defaultes removeObjectForKey:PlayLogKey];
    [defaultes synchronize];
    if([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession])
    {
        [self.exitBtn setTitle:@" 登     陆 " forState:UIControlStateNormal];
        [self.exitBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [self.exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate unlogin];
    
    
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)loginBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate toLogin];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//
//
-(void)hideLoginView{
    [self.aboutView removeFromSuperview];
    self.aboutView=nil;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    
//    [self.webView removeFromSuperview];
//    self.webView=nil;
//    [self.extendView removeFromSuperview];
//    self.extendView=nil;
    
}

#pragma mark - getters
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_backBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //_backBtn.backgroundColor=[UIColor redColor];
    }
    return _backBtn;
}
-(UIButton *)backImageBtn{
    if(!_backImageBtn){
        _backImageBtn=[[UIButton alloc]init];
        [_backImageBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backImageBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backImageBtn;
}
-(UIButton *)selfConditidonBtn{
    if(!_selfConditidonBtn){
        _selfConditidonBtn=[[UIButton alloc]init];
        _selfConditidonBtn.backgroundColor=[UIColor whiteColor];
        [_selfConditidonBtn setTitle:@"       个人中心" forState:UIControlStateNormal];
        [_selfConditidonBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_selfConditidonBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _selfConditidonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selfConditidonBtn addTarget:self action:@selector(selfConditidonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _selfConditidonBtn;
}
-(UIButton *)downloadConditionBtn{
    if(!_downloadConditionBtn){
        _downloadConditionBtn=[[UIButton alloc]init];
        _downloadConditionBtn.backgroundColor=[UIColor whiteColor];
        [_downloadConditionBtn setTitle:@"       下载管理" forState:UIControlStateNormal];
        [_downloadConditionBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_downloadConditionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _downloadConditionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_downloadConditionBtn addTarget:self action:@selector(downloadConditionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _downloadConditionBtn;
}
-(UIButton *)memoryClearBtn{
    if(!_memoryClearBtn){
        _memoryClearBtn=[[UIButton alloc]init];
        _memoryClearBtn.backgroundColor=[UIColor whiteColor];
        [_memoryClearBtn setTitle:@"       清除缓存（不包含下载内容）" forState:UIControlStateNormal];
        [_memoryClearBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_memoryClearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _memoryClearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_memoryClearBtn addTarget:self action:@selector(memoryClearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }

    return _memoryClearBtn;
}
-(UIButton *)extendBtn{
    if(!_extendBtn){
        _extendBtn=[[UIButton alloc]init];
        _extendBtn.backgroundColor=[UIColor whiteColor];
        [_extendBtn setTitle:@"       关于超课" forState:UIControlStateNormal];
        [_extendBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_extendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _extendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_extendBtn addTarget:self action:@selector(toExtendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _extendBtn;
}
-(UIButton *)exitBtn{
    if(!_exitBtn){
        _exitBtn=[[UIButton alloc]init];
        _exitBtn.backgroundColor=[UIColor redColor];
//        NSString *stu_id = ApplicationDelegate.userSession;
//        NSString *stu_pwd = ApplicationDelegate.userPsw;
        if([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession])
        {
            [_exitBtn setTitle:@" 登     陆 " forState:UIControlStateNormal];
            [_exitBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
            //[_exitBtn addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
            //[_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }

        
        [_exitBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.layer.cornerRadius = 26;
        //_exitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    
    return _exitBtn;
}
-(void)poseDownloads{
    
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"功能尚未开放，敬请期待" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}
-(void)posetMesseges{
    [UIAlertController showAlertAtViewController:self withMessage:@"缓存清除成功" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
    } confirmHandler:^(UIAlertAction *action) {
    }];
}

-(UIView *)hubView{
    if (!_hubView){
        _hubView = [[UIView alloc]initWithFrame:self.view.bounds];
        _hubView.backgroundColor = [UIColor blackColor];
        _hubView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLoginView)];
        [_hubView addGestureRecognizer:tap];
    }
    return _hubView;
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1000.0;
}

-(void)removeCache
{
    //===============清除缓存==============
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float size = [self folderSizeAtPath:cachePath];
    NSLog(@"%f",size);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"%lu",(unsigned long)[files count]);
    //    NSLog(@"文件数 ：%d",[files count]);
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}
-(UILabel *)sizeLabel{
    if(!_sizeLabel){
        _sizeLabel=[[UILabel alloc]init];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.size = [self folderSizeAtPath:cachePath];
        if(self.size>1024.0){
            self.size=self.size/1024.0;
            NSString *msg=[NSString stringWithFormat:@"%.1fM",self.size];
            _sizeLabel.text=msg;
        }else{
            NSString *msg=[NSString stringWithFormat:@"%.1fK",self.size];
            _sizeLabel.text=msg;
        }
        _sizeLabel.font=[UIFont systemFontOfSize:45*WidthScale];
        [_sizeLabel setTextColor:[UIColor lightGrayColor]];
        
    }
    return _sizeLabel;
}

-(SCAboutView *)aboutView{

    if (!_aboutView) {
        _aboutView = [[SCAboutView alloc]initWithFrame:CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height)];
//        _aboutView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height);
        _aboutView.center = self.view.center;
    }
    return _aboutView;
}




@end
