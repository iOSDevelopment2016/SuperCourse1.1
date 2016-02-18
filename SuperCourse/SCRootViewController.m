//
//  SCRootViewController.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCAllCourseView.h"
#import "SCVideoHistoryView.h"
#import "SCMyNotesView.h"
#import "SCSearchView.h"
#import "SCLoginView.h"
//#import "SCRegViewController.h" 不实现注册功能
#import "SCSettingViewController.h"
#import "SCPlayerViewController.h"
#import "SCCourseTableViewCell.h"
#import "SCVideoInfoModel.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "HttpTool.h"
#import "SCIntroduction.h"
#import "SCKnowledge.h"
#import "SCWillLearn.h"
#import "SCIntroductionDataSource.h"
#import "SCCoursePlayLog.h"
#import "SCExtendView.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger,SCShowViewType) {
    SCShowViewType_MyNotes = 0,
    SCShowViewType_VideoHistory,
    SCShowViewType_AllCourse
};


@interface SCRootViewController ()<SCLoginViewDelegate,SCAllCourseViewDelegate,UITextFieldDelegate,SCCourseTableViewDelegate,SCExtendViewDelegate,SCHistoryViewDelegate,SCSearchViewDelegate,SCSettingViewControllerDelegate,MBProgressHUDDelegate,UIPageViewControllerDelegate>


@property (nonatomic ,strong) UIButton                 *loginBtn;
@property (nonatomic ,strong) UIButton                 *loginBtnImage;
@property (nonatomic ,strong) UIView                   *leftView;
@property (nonatomic ,strong) UITextField              *searchTextField;
@property (nonatomic ,strong) UIButton                 *allCourseBtn;
@property (nonatomic ,strong) UIButton                 *allCourseBtnImage;
@property (nonatomic ,strong) UIButton                 *videoHistoryBtn;
@property (nonatomic ,strong) UIButton                 *videoHistoryBtnImage;
@property (nonatomic ,strong) UIButton                 *myNotesBtn;
@property (nonatomic ,strong) UIButton                 *myNotesBtnImage;
@property (nonatomic ,strong) UIButton                 *favouriteSettingBtn;
@property (nonatomic ,strong) UIButton                 *favouriteSettingBtnImage;
@property (nonatomic ,strong) UIView                   *scroll;
@property (nonatomic ,strong) UIView                   *hubView;
@property (nonatomic ,strong) SCLoginView              *loginView;
@property (nonatomic ,strong) SCAllCourseView          *allCourseView;
@property (nonatomic ,strong) SCVideoHistoryView       *videoHistoryView;
@property (nonatomic ,strong) SCMyNotesView            *myNotesView;
@property (nonatomic ,strong) SCSearchView             *searchView;
@property (nonatomic ,strong) UIButton                 *selectedBtn;
@property (nonatomic ,strong) UIView                   *mainView;
@property (nonatomic ,strong) UIWebView                *webView;
@property (nonatomic ,strong) SCExtendView             *extendView;
@property (nonatomic ,strong) SCSettingViewController  *setVC;
@property (nonatomic ,strong) SCIntroductionDataSource *datasource;
@property (nonatomic ,strong) MBProgressHUD            *hud;
@property (nonatomic ,strong) SCCoursePlayLog          *playLog;

@property CGFloat Variety;


@end

@implementation SCRootViewController{
    CGRect mainFrame;
    NSArray *allCourseArr;
    NSString *testStr;
    //这里是我的git测试
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allCourseBtn.selected=YES;
    self.allCourseBtnImage.selected=YES;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if([ApplicationDelegate.userSession isEqualToString:@"UnLoginUserSession"]){
        
        [self.view addSubview:self.loginBtn];
        [self.view addSubview:self.loginBtnImage];
    }else{
        [self getuser:ApplicationDelegate.userPhone];
    }
    [self.view addSubview:self.leftView];
    
    [self.leftView addSubview:self.allCourseBtn];
    [self.leftView addSubview:self.allCourseBtnImage];
    [self.leftView addSubview:self.videoHistoryBtn];
    [self.leftView addSubview:self.videoHistoryBtnImage];
    [self.leftView addSubview:self.myNotesBtn];
    [self.leftView addSubview:self.myNotesBtnImage];
    //    [self.leftView addSubview:self.favouriteSettingBtn];
    //    [self.leftView addSubview:self.favouriteSettingBtnImage];
    
    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.mainView];
    
    [self.mainView addSubview:self.myNotesView];//0
    [self.mainView addSubview:self.videoHistoryView];//1
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.delegate = self;
    self.hud.dimBackground = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webDataLoaddDone) name:@"WebDataHaveLoadDone" object:nil];
    [self.mainView addSubview:self.allCourseView];//2
    
    //    SCIntroduction *intro= self.datasource.har_des[0];
    //    NSString *str=intro.les_intrdoc;
    //    NSLog(@"%@",str);
    self.selectedBtn = self.allCourseBtn;
}

-(void)webDataLoaddDone{
    
    [self.hud hide:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.allCourseView change];
    self.loginBtn.frame = CGRectMake(0, 0, 400*WidthScale, 200*HeightScale);
    self.loginBtnImage.frame=CGRectMake(51*WidthScale, 48*HeightScale, 94*WidthScale, 94*WidthScale);
    self.leftView.frame = CGRectMake(0, self.loginBtn.bottom, self.loginBtn.width, self.view.height-self.loginBtn.height);
    self.allCourseBtn.frame=CGRectMake(0, 50*HeightScale, 400*WidthScale, 150*HeightScale);
    self.allCourseBtnImage.frame=CGRectMake(51*WidthScale, 50*HeightScale+44*HeightScale, 64*WidthScale, 50*HeightScale);
    self.videoHistoryBtn.frame=CGRectMake(0, 200*HeightScale, 400*WidthScale, 150*HeightScale);
    self.videoHistoryBtnImage.frame=CGRectMake(51*WidthScale, 200*HeightScale+35*HeightScale, 64*WidthScale, 64*HeightScale);
    self.myNotesBtn.frame=CGRectMake(0, 350*HeightScale, 400*WidthScale, 150*HeightScale);
    self.myNotesBtnImage.frame=CGRectMake(51*WidthScale, 350*HeightScale+35*HeightScale, 64*WidthScale, 64*HeightScale);
    self.favouriteSettingBtn.frame = CGRectMake(0, self.leftView.height-150*HeightScale,400*WidthScale, 150*HeightScale);
    self.favouriteSettingBtnImage.frame = CGRectMake(51*WidthScale, self.leftView.height-150*HeightScale+35*HeightScale,64*WidthScale, 64*HeightScale);
    self.searchTextField.frame= CGRectMake(1234*WidthScale, 56*HeightScale, self.view.width/3, 100*HeightScale);
    
    //中央视图尺寸
    mainFrame = CGRectMake(self.leftView.right, self.leftView.top, self.view.width-self.leftView.width, self.leftView.height);
    self.mainView.frame = mainFrame;
    
    self.allCourseView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
    self.myNotesView.frame = self.allCourseView.frame;
    self.videoHistoryView.frame = self.allCourseView.frame;
    //    self.searchView.frame = self.allCourseView.frame;
}


-(void)loadData{
    //调用接口
    //获得数据
    allCourseArr = @[@"1",@"2",@"3"];
    
    
}
#pragma mark - SCExtendViewDelegate
-(void)returnToMainView{
    [self hideLoginView];
}
-(NSString *)getTitle{
    return self.title;
}

#pragma mark - SCLoginViewDelegate
//-(void)regBtnDidClick:(UIButton *)sender{
//
//    SCRegViewController *regVC = [[SCRegViewController alloc]init];
//    [self presentViewController:regVC animated:YES completion:nil];
//}
-(void)removeHub{
    [self.hubView removeFromSuperview];
    [self hideLoginView];
    [self.allCourseView change];
}
-(void)getuser:(NSString *)userphone{
    [self.loginBtnImage removeFromSuperview];
    [self.loginBtn removeFromSuperview];
    UIView *leftTopView=[[UIView alloc]initWithFrame: CGRectMake(0, 0, 400*WidthScale, 200*HeightScale)];
    leftTopView.backgroundColor=UIThemeColor;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 400*WidthScale, 200*HeightScale)];
    [btn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame: CGRectMake(25, 0, 400*WidthScale-50, 200*HeightScale)];
    userLabel.backgroundColor=UIThemeColor;
    userLabel.numberOfLines=0;
    userLabel.text=[NSString stringWithFormat:@"你好!\n%@",userphone];
    [userLabel setTextColor:[UIColor whiteColor]];
    userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
    [self.view addSubview:leftTopView];
    [leftTopView addSubview:userLabel];
    [leftTopView addSubview:btn];
    
}

#pragma mark - SCAllCourseViewDelegate
-(IBAction)contendClick:(NSInteger)secIndex AndRowIndex:(NSInteger)rouIndex AndUrl:(NSString *)url{
    [self.view addSubview:self.hubView];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(100, 100, 1000, 800)];
    
    
    [self.view addSubview:self.webView];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    
    
    [self.webView loadRequest:request];
    
}

//-(void)videoPlayClickwithUrl:(NSString *)url{
//    SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
//    playVC.currentVideoInfo = allCourseArr[5];
//    [self.navigationController pushViewController:playVC animated:YES];
//}
-(void)changeToLearn{
    [self.allCourseView change];
}


-(void)videoPlayClickWithCourse:(SCCourse *)SCcourse{
    //        if([SCcourse.permission isEqualToString:@"是"])
    if(![ApplicationDelegate.userSession isEqualToString:@"UnLoginUserSession"]){
        NSString *state = [ApplicationDelegate getNetWorkStates];
        if ([state isEqualToString:@"无网络"]) {
            [UIAlertController showAlertAtViewController:self withMessage:@"请检查您的网络连接" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
            } confirmHandler:^(UIAlertAction *action) {
            }];
        }
        else if ([state isEqualToString:@"wifi"]){
            
            [self jumpToPlayerWithCourse:SCcourse];
            
        }else{
            
            [UIAlertController showAlertAtViewController:self withMessage:@"您当前正在使用3G/4G流量" cancelTitle:@"取消" confirmTitle:@"继续播放" cancelHandler:^(UIAlertAction *action) {
                
            } confirmHandler:^(UIAlertAction *action) {
                [self jumpToPlayerWithCourse:SCcourse];
            }];
        }
    }else{
        //        if([SCcourse.permission isEqualToString:@"是"]){
        //            [self jumpToPlayerWithCourse:SCcourse];
        //        }
        //        else{
        [UIAlertController showAlertAtViewController:self withMessage:@"未登陆下受限" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
        } confirmHandler:^(UIAlertAction *action) {
        }];
        //        }
        
    }
}

-(void)jumpToPlayerWithCourse:(SCCourse *)course
{
    SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
    playVC.delegate=self;
    NSString *courseId = course.les_id;
    playVC.lessonId = courseId;
    [self.navigationController pushViewController:playVC animated:YES];
}

-(IBAction)imageClickWithCoutse:(SCCourse *)Course{
    
    
    // 跳转到详情页面                 当前只有第一项有数据 暂且只读第一项    ！！！！！！！！后期修改
    
    NSString *Id=Course.les_id;
    NSDictionary *para = @{@"method":@"Getintroduction",
                           @"param":@{@"Data":@{@"les_id":Id}}};
    
    [HttpTool postWithparams:para success:^(id responseObject) {
        
        
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        
        [SCIntroductionDataSource setupObjectClassInArray:^NSDictionary *{
            return @{@"har_des":@"SCIntroduction"};
        }];
        [SCIntroductionDataSource setupObjectClassInArray:^NSDictionary *{
            return @{@"knowledge":@"SCKnowledge"};
        }];
        [SCIntroductionDataSource setupObjectClassInArray:^NSDictionary *{
            return @{@"willknow":@"SCWillLearn"};
        }];
        
        self.datasource=[SCIntroductionDataSource objectWithKeyValues:dic[@"data"]];
        //SCIntroduction *introduction=self.datasource.har_des[0];
        //if(introduction.les_intrdoc){
        if(!self.datasource.knowledge){
            [UIAlertController showAlertAtViewController:self withMessage:@"暂无详细介绍" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
            } confirmHandler:^(UIAlertAction *action) {
            }];
            
        }else{
            
            self.extendView = [[SCExtendView alloc]initWithString:Course.les_name AndDataSource:self.datasource AndWidth:0.68*self.view.width AndHeight:0.6*self.view.height];
            
            self.extendView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height);
            
            self.extendView.center = self.view.center;
            self.extendView.delegate = self;
            self.extendView.width = 0.68*self.view.width;
            self.extendView.height = 0.6*self.view.height;
            
            [self.view addSubview:self.hubView];
            [self.view addSubview:self.extendView];
        }
        //        }else{
        //            [UIAlertController showAlertAtViewController:self withMessage:@"暂无介绍信息" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
        //            } confirmHandler:^(UIAlertAction *action) {
        //            }];
        
        // }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    //Course.les_name
    //self.datasource.har_des
    //self.datasource.knowledge
    //self.datasource.willknow
    
    
    
    //SCExtendView *extendView=[[SCExtendView alloc]init];
    //extendView.backgroundColor=[UIColor whiteColor];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchTextField resignFirstResponder];
}


-(void)startBtnDidClick{
    // 检查学员是否登录，未登录的，转到登录界面；已登录的，开始学习
    
    NSLog(@"%@",ApplicationDelegate.userSession);
    
    if ([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession]) {
        [self loginBtnClick]; // 去登录
    }else{
        
        [self startCourse]; // 开始学习
    }
    
}

// 开始学习
-(void)startCourse{
    // 开始学习：
    // 获得当前学员的最后一条播放记录
    NSString *stu_id = ApplicationDelegate.userSession;
    NSString *stu_pwd = ApplicationDelegate.userPsw;
    if([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession])
    {
        [self loginBtnClick];
    }else{
        
        if (!stu_pwd) {
            stu_pwd = @"";
        }
        stu_id = ApplicationDelegate.userSession;
        NSDictionary *para = @{@"method":@"GetStudentPlayLog",
                               @"param":@{@"Data":@{@"stu_id":stu_id,
                                                    @"stu_pwd":stu_pwd}}};
        
        [HttpTool postWithparams:para success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            //        [SCCourseCategory setupObjectClassInArray:^NSDictionary *{
            //            return @{@"willknow":@"SCWillLearn"};
            //        }];
            
            self.playLog = [SCCoursePlayLog objectWithKeyValues:dic[@"data"]];
            if (!self.playLog) {
                self.playLog = nil;
            }
            //        SCCoursePlayLog *playLog = [[SCCoursePlayLog alloc]init];
            //        playLog.lessonID = dic[@"data"][@""]
            NSString *lessonId = self.playLog.les_id;
            float startTime = self.playLog.oversty_time;
            if (lessonId) {
                if ([self.playLog.is_ready isEqualToString:@"是"]) {
                    lessonId = [self getNextCourse:lessonId];
                    startTime = 0;
                }
                
            }else{
                //lessonId = [self getFirstCourse];                未完成！！！！！！！！
                lessonId = @"0001";
                self.playLog.studyles_id=lessonId;
                startTime = 0;
                
            }
            // 启动播放器
            SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
            playVC.delegate=self;
            playVC.lessonId = lessonId;
            // 设置播放开始时间，未完成   playVC.
            [self.navigationController pushViewController:playVC animated:YES];
            
            //       self.datasource=[SCIntroductionDataSource objectWithKeyValues:dic[@"data"]];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

-(NSString *)getNextCourse:(NSString *)lessonId{
    NSString *nextLessonID = lessonId;
    if (self.allCourseView) {
        nextLessonID = [self.allCourseView getNextLessonID:lessonId];
    }
    return nextLessonID;
}

//-(IBAction)contendFieldDidClick{
//    SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
//    playVC.currentVideoInfo = allCourseArr[5];
//    [self.navigationController pushViewController:playVC animated:YES];
//
//}
//-(IBAction)imageBtnDidClick{
//    SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
//    playVC.currentVideoInfo = allCourseArr[5];
//    [self.navigationController pushViewController:playVC animated:YES];
//
//}


#pragma mark - SCHistoryViewDelegate
-(void)historyDidClick:(NSString *)les_id
{
    
    SCPlayerViewController *playerVC = [[SCPlayerViewController alloc]init];
    playerVC.delegate=self;
    playerVC.lessonId = les_id;
    [self.navigationController pushViewController:playerVC animated:YES];
    
}
-(void)searchDidClick:(NSString *)les_id {
    SCPlayerViewController *playerVC=[[SCPlayerViewController alloc]init];
    playerVC.delegate=self;
    playerVC.lessonId = les_id;
    //    playerVC.beginTime = b
    [self.navigationController pushViewController:playerVC animated:YES];
    //
}

#pragma mark - 私有方法
-(void)move{
    //CGFloat ScaleHeight=[self getScaleHeight];
    [UIView animateWithDuration:0.5 animations:^{
        self.scroll.transform=CGAffineTransformMakeTranslation(0,self.Variety);
    }];
}
-(void)viewmove:(CGFloat)variety andUIView:(UIView *)scrollView{
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.transform=CGAffineTransformMakeTranslation(variety,0);
    }];
}

#pragma mark - 响应事件
-(void)changeImage{
    
}


-(void)allCourseBtnClick:(UIButton *)sender{
    if(self.searchView){
        [self.searchView removeFromSuperview];
    }
    [self.searchTextField setHidden:NO];
    self.searchTextField.text=nil;
    self.allCourseBtn.selected=YES;
    self.allCourseBtnImage.selected=YES;
    self.videoHistoryBtn.selected=NO;
    self.videoHistoryBtnImage.selected=NO;
    self.myNotesBtn.selected=NO;
    self.myNotesBtnImage.selected=NO;
    self.favouriteSettingBtn.selected=NO;
    self.favouriteSettingBtnImage.selected=NO;
    
    [self.scroll setHidden:NO];
    if (!_scroll) {
        [self.leftView addSubview:self.scroll];
        [self scroll:self.allCourseBtn.frame.origin.y];
        
    }
    else{
        CGFloat a=self.allCourseBtn.frame.origin.y+self.Variety;
        CGFloat b=self.scroll.frame.origin.y;
        
        self.Variety=a-b;
        [self move];
    }
    
    [self changeViewFrom:self.selectedBtn.tag to:sender.tag];
    self.selectedBtn.selected=NO;
    sender.selected=YES;
    
    
    
    NSInteger tempTag = sender.tag;
    sender.tag = self.selectedBtn.tag;
    
    
    self.selectedBtn.tag = tempTag;
    
    self.selectedBtn = sender;
}


-(void)historyBtnClick:(UIButton *)sender{
    if(self.searchView){
        [self.searchView removeFromSuperview];
    }
    [self.searchTextField setHidden:YES];
    self.searchTextField.text=nil;
    self.allCourseBtn.selected=NO;
    self.allCourseBtnImage.selected=NO;
    self.videoHistoryBtn.selected=YES;
    self.videoHistoryBtnImage.selected=YES;
    self.myNotesBtn.selected=NO;
    self.myNotesBtnImage.selected=NO;
    self.favouriteSettingBtn.selected=NO;
    self.favouriteSettingBtnImage.selected=NO;
    
    [self.scroll setHidden:NO];
    if (!_scroll) {
        [self scroll:self.videoHistoryBtn.frame.origin.y];
        [self.leftView addSubview:self.scroll];
    }
    else{
        CGFloat a=self.videoHistoryBtn.frame.origin.y+self.Variety;
        CGFloat b=self.scroll.frame.origin.y;
        
        self.Variety=a-b;
        [self move];
    }
    
    
    [self changeViewFrom:self.selectedBtn.tag to:sender.tag];
    self.selectedBtn.selected=NO;
    sender.selected=YES;
    
    
    
    NSInteger tempTag = sender.tag;
    sender.tag = self.selectedBtn.tag;
    
    
    self.selectedBtn.tag = tempTag;
    
    self.selectedBtn = sender;
    
}
-(void)noteBtnClick:(UIButton *)sender{
    if(self.searchView){
        [self.searchView removeFromSuperview];
    }
    [self.searchTextField setHidden:YES];
    self.searchTextField.text=nil;
    self.allCourseBtn.selected=NO;
    self.allCourseBtnImage.selected=NO;
    self.videoHistoryBtn.selected=NO;
    self.videoHistoryBtnImage.selected=NO;
    self.myNotesBtn.selected=YES;
    self.myNotesBtnImage.selected=YES;
    self.favouriteSettingBtn.selected=NO;
    self.favouriteSettingBtnImage.selected=NO;
    
    [self.scroll setHidden:NO];
    if (!_scroll) {
        [self scroll:self.myNotesBtn.frame.origin.y];
        [self.leftView addSubview:self.scroll];
    }
    else{
        CGFloat a=self.myNotesBtn.frame.origin.y+self.Variety;
        CGFloat b=self.scroll.frame.origin.y;
        
        self.Variety=a-b;
        [self move];
    }
    
    
    [self changeViewFrom:self.selectedBtn.tag to:sender.tag];
    self.selectedBtn.selected=NO;
    sender.selected=YES;
    
    
    
    NSInteger tempTag = sender.tag;
    sender.tag = self.selectedBtn.tag;
    
    
    self.selectedBtn.tag = tempTag;
    
    self.selectedBtn = sender;
    
    
}


//-(void)favouriteBtnClick{
//    self.allCourseBtn.selected=NO;
//    self.allCourseBtnImage.selected=NO;
//    self.videoHistoryBtn.selected=NO;
//    self.videoHistoryBtnImage.selected=NO;
//    self.myNotesBtn.selected=NO;
//    self.myNotesBtnImage.selected=NO;
//    self.favouriteSettingBtn.selected=YES;
//    self.favouriteSettingBtnImage.selected=YES;
//    [self.scroll setHidden:NO];
//    if (!_scroll) {
//        [self scroll:self.favouriteSettingBtn.frame.origin.y];
//        [self.leftView addSubview:self.scroll];
//    }
//    else{
//        CGFloat a=self.favouriteSettingBtn.frame.origin.y+self.Variety;
//        CGFloat b=self.scroll.frame.origin.y;
//
//        self.Variety=a-b;
//        [self move];
//    }
//
//}
-(void)loginBtnClick{
    
    
    if ([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession]) {
        [self.view addSubview:self.hubView];
        [self.view addSubview:self.loginView];
    }else{
        
        
        [UIAlertController showAlertAtViewController:self withMessage:@"您确定退出登录吗？" cancelTitle:@"取消" confirmTitle:@"注销" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            //退出登录
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogout" object:nil];
            
            [self unlogin];
        }];
    }
    
    
    
    //    self.allCourseBtn.selected=NO;
    //    self.allCourseBtnImage.selected=NO;
    //    self.videoHistoryBtn.selected=NO;
    //    self.videoHistoryBtnImage.selected=NO;
    //    self.myNotesBtn.selected=NO;
    //    self.myNotesBtnImage.selected=NO;
    //    self.favouriteSettingBtn.selected=NO;
    //    self.favouriteSettingBtnImage.selected=NO;
    //    [self.scroll setHidden:YES];
}

-(void)hideLoginView{
    [self.loginView removeFromSuperview];
    self.loginView = nil;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [self.webView removeFromSuperview];
    self.webView=nil;
    [self.extendView removeFromSuperview];
    self.extendView=nil;
    
}

//-(void)leftBtnClick:(UIButton *)sender{
//
//    [self changeViewFrom:self.selectedBtn.tag to:sender.tag];
//    self.selectedBtn.selected=NO;
//    sender.selected=YES;
//
//
//
//    NSInteger tempTag = sender.tag;
//    sender.tag = self.selectedBtn.tag;
//
//
//    self.selectedBtn.tag = tempTag;
//
//    self.selectedBtn = sender;
//}

-(void)changeViewFrom:(SCShowViewType)fromTndex to:(SCShowViewType)toIndex{
    
    [self.mainView exchangeSubviewAtIndex:fromTndex withSubviewAtIndex:toIndex];
}

-(void)settingBtnClick{
    //    self.favouriteSettingBtn.selected=YES;
    //    self.favouriteSettingBtnImage.selected=YES;
    
    self.setVC = [[SCSettingViewController alloc]init];
    self.setVC.delegate=self;
    [self.navigationController pushViewController:self.setVC animated:YES];
}

-(void)searchBtnClick{
    self.allCourseBtn.selected=NO;
    self.allCourseBtnImage.selected=NO;
    self.videoHistoryBtn.selected=NO;
    self.videoHistoryBtnImage.selected=NO;
    self.myNotesBtn.selected=NO;
    self.myNotesBtnImage.selected=NO;
    self.favouriteSettingBtn.selected=NO;
    self.favouriteSettingBtnImage.selected=NO;
    [self.scroll setHidden:YES];
    self.searchView.keyWord = self.searchTextField.text;
    [self.searchTextField resignFirstResponder];
    
    if ([self.searchTextField.text isEqualToString:@""]) {
        [UIAlertController showAlertAtViewController:self withMessage:@"请输入关键词搜索" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            [self.searchTextField becomeFirstResponder];
        }];
    }
    else{
        
        BOOL notOn = YES;
        for (UIView *subView in self.mainView.subviews) {
            if (subView == self.searchView) {
                notOn = NO;
            }
        }
        if (!notOn) {
            [self.searchView loadCourseListFromNetwork];
        }
        else{
            [self.mainView addSubview:self.searchView];
        }
    }
}

#pragma mark - SCSettingViewControllerDelegate

-(void)unlogin{
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.loginBtnImage];
    [self.setVC removeFromParentViewController];
    [self.allCourseView.startBtn setImage:[UIImage imageNamed:@"SC_start"] forState:UIControlStateNormal];
}



#pragma mark - getters

-(UIView *)scroll:(CGFloat)y{
    _scroll=[[UIView alloc]initWithFrame:CGRectMake(0, y, 9*HeightScale, 150*HeightScale)];
    [_scroll setBackgroundColor:UIColorFromRGB(0x6fccdb)];
    return _scroll;
}

-(UIButton *)loginBtn{
    if (!_loginBtn){
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.backgroundColor = UIThemeColor;
        [_loginBtn setTitle:@"        请登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:45*WidthScale];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}




-(UIButton *)loginBtnImage
{
    if(!_loginBtnImage)
    {
        _loginBtnImage=[UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtnImage.backgroundColor=UIColorFromRGB(0x6fccdb);
        UIImage *UserImage=[UIImage imageNamed:@"SC_user"];
        [_loginBtnImage setImage:UserImage forState:UIControlStateNormal];
        [_loginBtnImage addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtnImage;
}




-(UIView *)leftView{
    if (!_leftView){
        _leftView = [[UIView alloc]init];
        _leftView.backgroundColor = [UIColor whiteColor];
        
        
        //[_leftView.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        
        //[_leftView.layer setCornerRadius:10];
        
        [_leftView.layer setBorderWidth:1];//设置边界的宽度
        
        
        
        //设置按钮的边界颜色
        
        [_leftView.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
        
        
    }
    return _leftView;
}

//-(UIView *)searchView{
//    if (!_searchView){
//        _searchView = [[UIView alloc]init];
//        _searchView.backgroundColor = [UIColor whiteColor];
//        _searchView.layer.masksToBounds = YES;
//        _searchView.layer.cornerRadius = 35;
//        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SC_magnifier"]];
//        imageView.frame=CGRectMake(65*WidthScale, 20*HeightScale, 64*WidthScale, 64*HeightScale);
//        [_searchView addSubview:imageView];
//
//    }
//    return _searchView;
//}
//-(void)clickToSearch:(NSString *)text{
//    [self.view addSubview:self.searchView];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==self.searchTextField){
        self.allCourseBtn.selected=NO;
        self.allCourseBtnImage.selected=NO;
        self.videoHistoryBtn.selected=NO;
        self.videoHistoryBtnImage.selected=NO;
        self.myNotesBtn.selected=NO;
        self.myNotesBtnImage.selected=NO;
        self.favouriteSettingBtn.selected=NO;
        self.favouriteSettingBtnImage.selected=NO;
        [self.scroll setHidden:YES];
        [self.searchTextField resignFirstResponder];//放弃当前焦点
        [self searchBtnClick];
        
        
        if ([self.searchTextField.text isEqualToString:@""]) {
            [UIAlertController showAlertAtViewController:self withMessage:@"请输入关键词搜索" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
                
            } confirmHandler:^(UIAlertAction *action) {
                [self.searchTextField becomeFirstResponder];
            }];
        }
        else{
            self.searchView.keyWord = textField.text;
            [self.mainView addSubview:self.searchView];
        }
    }
    return YES;
}

-(UITextField *)searchTextField{
    if(!_searchTextField){
        _searchTextField=[[UITextField alloc]init];
        //_SearchTextField=[[UITextField alloc]init];
        [_searchTextField setBackgroundColor:[UIColor whiteColor]];
        _searchTextField.placeholder = @"请输入搜索内容";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _searchTextField.returnKeyType=UIReturnKeyDone;
        _searchTextField.font = [UIFont systemFontOfSize:45*WidthScale];
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.cornerRadius = 50*WidthScale;
        _searchTextField.textAlignment = UITextAlignmentCenter;
        _searchTextField.rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 170*WidthScale, 150*HeightScale)];
        _searchTextField.rightView.backgroundColor=UIColorFromRGB(0x6fccdb);
        _searchTextField.rightViewMode=UITextFieldViewModeAlways;
        UIButton *searchBtn=[[UIButton alloc]init];
        [searchBtn setImage:[UIImage imageNamed:@"搜索白色"] forState:UIControlStateNormal];
        searchBtn.frame=CGRectMake(45*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchTextField.rightView addSubview:searchBtn];
        _searchTextField.delegate=self;
        
    }
    return _searchTextField;
    
}

-(UIButton *)allCourseBtn{
    if (!_allCourseBtn){
        _allCourseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allCourseBtn.tag = SCShowViewType_AllCourse;
        [_allCourseBtn setTitle:@"      所有课程" forState:UIControlStateNormal];
        _allCourseBtn.titleLabel.font = [UIFont systemFontOfSize:45*WidthScale];
        [_allCourseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allCourseBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        [_allCourseBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        [self scroll:self.allCourseBtn.frame.origin.y+45*HeightScale];
        [self.leftView addSubview:self.scroll];
        [_allCourseBtn addTarget:self action:@selector(allCourseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allCourseBtn;
}

-(UIButton *)allCourseBtnImage{
    if(!_allCourseBtnImage)
    {
        _allCourseBtnImage=[UIButton buttonWithType:UIButtonTypeCustom];
        _allCourseBtnImage.tag = SCShowViewType_AllCourse;
        [_allCourseBtnImage setImage:[UIImage imageNamed:@"SC_video"] forState:UIControlStateNormal];
        [_allCourseBtnImage setImage:[UIImage imageNamed:@"SC_video2"] forState:UIControlStateSelected];
        [_allCourseBtnImage addTarget:self action:@selector(allCourseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allCourseBtnImage;
    
}

-(UIButton *)videoHistoryBtn{
    if (!_videoHistoryBtn){
        _videoHistoryBtn = [[UIButton alloc]init];
        _videoHistoryBtn.tag = SCShowViewType_VideoHistory;
        [_videoHistoryBtn setTitle:@"      观看历史" forState:UIControlStateNormal];
        [_videoHistoryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_videoHistoryBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        [_videoHistoryBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        _videoHistoryBtn.titleLabel.font = [UIFont systemFontOfSize:45*WidthScale];
        [_videoHistoryBtn addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoHistoryBtn;
}
-(UIButton *)videoHistoryBtnImage{
    if(!_videoHistoryBtnImage)
    {
        _videoHistoryBtnImage.tag = SCShowViewType_VideoHistory;
        _videoHistoryBtnImage=[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoHistoryBtnImage setImage:[UIImage imageNamed:@"SC_clock"] forState:UIControlStateNormal];
        [_videoHistoryBtnImage setImage:[UIImage imageNamed:@"SC_clock2"] forState:UIControlStateSelected];
        [_videoHistoryBtnImage addTarget:self action:@selector(historyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoHistoryBtnImage;
}

-(UIButton *)myNotesBtn{
    if (!_myNotesBtn){
        _myNotesBtn = [[UIButton alloc]init];
        _myNotesBtn.tag = SCShowViewType_MyNotes;
        [_myNotesBtn setTitle:@"      我的备注" forState:UIControlStateNormal];
        [_myNotesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myNotesBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        [_myNotesBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        _myNotesBtn.titleLabel.font=[UIFont systemFontOfSize:45*WidthScale];
        [_myNotesBtn addTarget:self action:@selector(noteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myNotesBtn;
}
-(UIButton *)myNotesBtnImage{
    if(!_myNotesBtnImage)
    {
        _myNotesBtnImage=[UIButton buttonWithType:UIButtonTypeCustom];
        _myNotesBtnImage.tag = SCShowViewType_MyNotes;
        [_myNotesBtnImage setImage:[UIImage imageNamed:@"SC_note"] forState:UIControlStateNormal];
        [_myNotesBtnImage setImage:[UIImage imageNamed:@"SC_note2"] forState:UIControlStateSelected];
        [_myNotesBtnImage addTarget:self action:@selector(noteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myNotesBtnImage;
}
-(UIButton *)favouriteSettingBtn{
    if (!_favouriteSettingBtn){
        _favouriteSettingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_favouriteSettingBtn setTitle:@"      " forState:UIControlStateNormal];
        [_favouriteSettingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_favouriteSettingBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        [_favouriteSettingBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        _favouriteSettingBtn.titleLabel.font=[UIFont systemFontOfSize:45*WidthScale];
        [_favouriteSettingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favouriteSettingBtn;
}

-(UIButton *)favouriteSettingBtnImage{
    if(!_favouriteSettingBtnImage)
    {
        
        _favouriteSettingBtnImage=[UIButton buttonWithType:UIButtonTypeCustom];
        [_favouriteSettingBtnImage setImage:[UIImage imageNamed:@"SC_settings"] forState:UIControlStateNormal];
        [_favouriteSettingBtnImage setImage:[UIImage imageNamed:@"SC_settings2"] forState:UIControlStateHighlighted];
        [_favouriteSettingBtnImage addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favouriteSettingBtnImage;
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

-(SCLoginView *)loginView{
    if (!_loginView){
        _loginView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SCLoginView class]) owner:nil options:nil].lastObject;
        _loginView.frame = CGRectMake(0, 0, 889*WidthScale, 647*HeightScale);
        _loginView.center = self.view.center;
        _loginView.delegate = self;
    }
    return _loginView;
}
//-(SCExtendView *)extendView{
//    if (!_extendView){
//        _extendView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SCExtendView class]) owner:nil options:nil].lastObject;
//        _extendView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height);
//        NSLog(@"%f",_extendView.frame.size.width);
//        NSLog(@"%f",_extendView.frame.size.height);
//        _extendView.center = self.view.center;
//        _extendView.delegate = self;
//    }
//    return _extendView;
//}
//


-(UIView *)mainView{
    if (!_mainView){
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor orangeColor];
    }
    return _mainView;
}

-(SCAllCourseView *)allCourseView{
    if (!_allCourseView){
        _allCourseView = [[SCAllCourseView alloc]init];
        _allCourseView.delegate = self;
    }
    return _allCourseView;
}

-(SCVideoHistoryView *)videoHistoryView{
    if (!_videoHistoryView){
        _videoHistoryView = [[SCVideoHistoryView alloc]init];
        _videoHistoryView.delegate = self;
        _videoHistoryView.viewController = self;
    }
    return _videoHistoryView;
}

-(SCMyNotesView *)myNotesView{
    if (!_myNotesView){
        _myNotesView = [[SCMyNotesView alloc]init];
        _myNotesView.viewContrller = self;
    }
    return _myNotesView;
}

-(SCSearchView *)searchView{
    if(!_searchView){
        _searchView=[[SCSearchView alloc]initWithFrame:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height)];
        _searchView.backgroundColor=[UIColor whiteColor];
        _searchView.delegate = self;
        _searchView.viewController =self;
    }
    return _searchView;
}

@end
