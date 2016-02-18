//
//  SCSettingViewController.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCSettingViewController.h"
#import "SCDownloadConditionViewController.h"

@interface SCSettingViewController ()



@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong)UIButton   *selfConditidonBtn;
@property (nonatomic, strong)UIButton   *downloadConditionBtn;
@property (nonatomic, strong)UIButton   *memoryClearBtn;
@property (nonatomic, strong)UIButton   *extendBtn;

@property (nonatomic, strong)UIButton   *exitBtn;

@end

@implementation SCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = UIThemeColor;
    
    
    [self.view addSubview:self.backImageBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.selfConditidonBtn];
    [self.view addSubview:self.downloadConditionBtn];
    [self.view addSubview:self.memoryClearBtn];
    [self.view addSubview:self.extendBtn];
    [self.view addSubview:self.exitBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backImageBtn.frame=CGRectMake(40, 22, 20, 35);
    self.backBtn.frame=CGRectMake(55, 20, 100, 40);
    self.selfConditidonBtn.frame=CGRectMake(0, 100, self.view.width, HeightScale*125);
    self.downloadConditionBtn.frame=CGRectMake(0, 150+HeightScale*125, self.view.width, HeightScale*125);
    self.memoryClearBtn.frame=CGRectMake(0, 152+HeightScale*250, self.view.width, HeightScale*125);
    self.extendBtn.frame=CGRectMake(0, 210+HeightScale*375, self.view.width, HeightScale*125);
    self.exitBtn.frame=CGRectMake(self.view.width/2-350*WidthScale, 225+HeightScale*500, 700*WidthScale, 100*HeightScale);
    
}
#pragma mark - click
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selfConditidonBtnClick{
    
}
-(void)downloadConditionBtnClick{
//    SCSettingViewController *setVC = [[SCSettingViewController alloc]init];
//    [self.navigationController pushViewController:setVC animated:YES];
    SCDownloadConditionViewController *downloadCondition=[[SCDownloadConditionViewController alloc]init];
    [self.navigationController pushViewController:downloadCondition animated:YES];
}
-(void)memoryClearBtnClick{
    
}
-(void)extendBtnClick{

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

    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate unlogin];
    //[self.navigationController popViewControllerAnimated:YES];
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
        [_extendBtn addTarget:self action:@selector(extendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _extendBtn;
}
-(UIButton *)exitBtn{
    if(!_exitBtn){
        _exitBtn=[[UIButton alloc]init];
        _exitBtn.backgroundColor=[UIColor redColor];
        [_exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_exitBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.layer.cornerRadius = 35;
        //_exitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exitBtn;
}


@end
