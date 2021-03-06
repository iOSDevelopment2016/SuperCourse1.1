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
//#import "LocalDatabase.h"
#import "SZYNoteSolidater.h"
#import "SCDownlodaMode.h"
#import "SCSelfConditionMode.h"
#import "SCProtocolView.h"
typedef NS_ENUM(NSInteger,SCShowViewType) {
    SCShowViewType_MyNotes = 0,
    SCShowViewType_VideoHistory,
    SCShowViewType_AllCourse
};


@interface SCRootViewController ()<SCLoginViewDelegate,SCAllCourseViewDelegate,UITextFieldDelegate,SCCourseTableViewDelegate,SCExtendViewDelegate,SCHistoryViewDelegate,SCSearchViewDelegate,SCSettingViewControllerDelegate,MBProgressHUDDelegate,UIPageViewControllerDelegate,WXApiDelegate>


@property (nonatomic ,strong) UIButton                 *loginBtn;
@property (nonatomic ,strong) UIButton                 *loginBtnImage;
@property (nonatomic ,strong) UIView                   *leftView;
@property (nonatomic ,strong) UITextField              *searchTextField;
@property (nonatomic ,strong) UIView                   *backView;
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
@property (nonatomic, strong) SZYNoteSolidater          *db;
@property (nonatomic, strong)SCSelfConditionMode       *mode;
@property (nonatomic, strong)SCProtocolView            *protocolView;

@property CGFloat Variety;


@end

@implementation SCRootViewController{
    CGRect mainFrame;
    NSArray *allCourseArr;
    NSString *testStr;
    //这里是我的git测试
    int mark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self measureTheFrameOfScreen];
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
    self.db=[[SZYNoteSolidater alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(echo)
                                                 name: @"echo"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(clearProtocol)
                                                 name: @"clearProtocol"
                                               object: nil];
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
    [self.leftView addSubview:self.favouriteSettingBtn];
    [self.leftView addSubview:self.favouriteSettingBtnImage];
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.searchTextField];
    [self.view addSubview:self.mainView];
    
    [self.mainView addSubview:self.myNotesView];//0
    [self.mainView addSubview:self.videoHistoryView];//1
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.delegate = self;
    self.hud.dimBackground = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webDataLoaddDone) name:@"WebDataHaveLoadDone" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle) name:@"changeTitle" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getProtocol) name:@"getProtocol" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLogOut) name:@"didLogOut" object:nil];
    
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
    
    [self  measureTheFrameOfScreen];
}




- (void)Share {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = @"超课";
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    } else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        [alView show];
    }
}
-(void)getProtocol{
    //[self.view addSubview:self.hubView];
    [self.view addSubview:self.protocolView];
    mark=1;
}
-(void)clearProtocol{
    [self.protocolView removeFromSuperview];
    self.protocolView=nil;
    mark=0;

}

-(void)changeTitle{
    [self.loginBtnImage removeFromSuperview];
    [self.loginBtn removeFromSuperview];
    UIView *leftTopView=[[UIView alloc]initWithFrame: CGRectMake(0, 0, 400*WidthScale, 200*HeightScale)];
    leftTopView.backgroundColor=UIThemeColor;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 400*WidthScale, 200*HeightScale)];
    [btn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame: CGRectMake(25, 0, 400*WidthScale-50, 200*HeightScale)];
    userLabel.backgroundColor=UIThemeColor;
    userLabel.numberOfLines=0;
    userLabel.text=[NSString stringWithFormat:@"你好!\n%@",ApplicationDelegate.userPhone];
    [userLabel setTextColor:[UIColor whiteColor]];
    userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
    [self.view addSubview:leftTopView];
    [leftTopView addSubview:userLabel];
    [leftTopView addSubview:btn];
    //    [self.view addSubview:leftTopView];
    NSDictionary *para = @{@"method":@"SelectStudentBaseinfo",
                           @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.mode=[SCSelfConditionMode objectWithKeyValues:dic[@"data"]];
        //暂时未解决上传头像系列问题
        //[self.confirmBtn setTitle:@"修改信息" forState:UIControlStateNormal];
        
            userLabel.backgroundColor=UIThemeColor;
            userLabel.numberOfLines=0;
            NSString *aa=self.mode.stu_name;
        if(aa!=NULL&&![aa isEqual:@""]){
           
            
            userLabel.text=[NSString stringWithFormat:@"你好!\n%@",self.mode.stu_name];
            [userLabel setTextColor:[UIColor whiteColor]];
            userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
        }else{
                       
            userLabel.text=[NSString stringWithFormat:@"你好!\n%@",ApplicationDelegate.userPhone];
            [userLabel setTextColor:[UIColor whiteColor]];
            userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
        }
            
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

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
//    [self.view addSubview:leftTopView];
    NSDictionary *para = @{@"method":@"SelectStudentBaseinfo",
                           @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.mode=[SCSelfConditionMode objectWithKeyValues:dic[@"data"]];
        //暂时未解决上传头像系列问题
        //[self.confirmBtn setTitle:@"修改信息" forState:UIControlStateNormal];
        if(self.mode.stu_name==nil||[self.mode.stu_name isEqual:@""]){
            userLabel.backgroundColor=UIThemeColor;
            userLabel.numberOfLines=0;
            userLabel.text=[NSString stringWithFormat:@"你好!\n%@",userphone];
            [userLabel setTextColor:[UIColor whiteColor]];
            userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
            

        }else{
            userLabel.backgroundColor=UIThemeColor;
            userLabel.numberOfLines=0;
            userLabel.text=[NSString stringWithFormat:@"你好!\n%@",self.mode.stu_name];
            [userLabel setTextColor:[UIColor whiteColor]];
            userLabel.font=[UIFont systemFontOfSize:45*WidthScale];
            

        }
//        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.hud.delegate = self;
//        self.hud.dimBackground = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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

-(void)postDownloadName:(NSString *)name AndURL:(NSString *)url AndSize:(NSString *)size AndID:(NSString *)les_id{
    __block BOOL beExist;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByID:@"YES" successHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            if ([noteArr count] < 1) {
                beExist=NO;
            }else{
                beExist=YES;
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    if(beExist==YES){
        [self downloadingAlart];
    }else{
        [self downloadingMsg];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendDownloadCondition" object:self userInfo:@{@"name":name,@"size":size,@"url":url,@"id":les_id}];
        
    }
    
}



-(void)changeToLearn{
    [self.allCourseView.startBtn setImage:[UIImage imageNamed:@"SC_continue"] forState:UIControlStateNormal];
//    [self.allCourseView change];

}

-(void)poseDownloads{
//    [UIAlertController showAlertAtViewController:self withMessage:@"当前已存在该课下载进程" cancelTitle:@"" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//    } confirmHandler:^(UIAlertAction *action) {
//    }];
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"已成功加入下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}
-(void)echo{
//    [UIAlertController showAlertAtViewController:self withMessage:@"当前已存在该课下载进程" cancelTitle:@"" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//    } confirmHandler:^(UIAlertAction *action) {
//    }];
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"已成功加入下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}
-(void)downloadingAlart{
//    [UIAlertController showAlertAtViewController:self withMessage:@"该进程在下载列表中已存在" cancelTitle:@"" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//    } confirmHandler:^(UIAlertAction *action) {
//    }];
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"已成功加入下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];

}
-(void)downloadingMsg{
//    [UIAlertController showAlertAtViewController:self withMessage:@"已成功加入下载列表" cancelTitle:@"" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//    } confirmHandler:^(UIAlertAction *action) {
//    }];
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"已成功加入下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}


-(void)videoPlayClickWithCourse:(SCCourse *)SCcourse{
    //        if([SCcourse.permission isEqualToString:@"是"])
    __block BOOL isDodownloaded;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByID:SCcourse.les_id successHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            SCDownlodaMode  *mode=[noteArr firstObject];
            if([mode.finished isEqualToString:@"YES"]){
                isDodownloaded=YES;
            }else{
                isDodownloaded=NO;
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    if(![ApplicationDelegate.userSession isEqualToString:@"UnLoginUserSession"]){
        if(!isDodownloaded){
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
            [self jumpToPlayerWithCourse:SCcourse];
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
//            [UIAlertController showAlertAtViewController:self withMessage:@"暂无详细介绍" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//            } confirmHandler:^(UIAlertAction *action) {
//            }];
            [UIAlertController showAlertAtViewController:self title:@"提示" message:@"暂无详细介绍" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
            }];
            
        }else{
            if(self.extendView==nil){
            self.extendView = [[SCExtendView alloc]initWithString:Course.les_name AndDataSource:self.datasource AndWidth:0.68*self.view.width AndHeight:0.6*self.view.height];
                if (IS_IPHONE) {
                    self.extendView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.7*self.view.height);

                }else{
                    self.extendView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height);

                }
            
            self.extendView.center = self.view.center;
            self.extendView.delegate = self;
            self.extendView.width = 0.68*self.view.width;
            self.extendView.height = 0.6*self.view.height;
            
            [self.view addSubview:self.hubView];
            [self.view addSubview:self.extendView];
            }
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

-(void)toLogin{
    [self loginBtnClick];
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
//    playerVC.delegate=self;
    playerVC.lessonId = les_id;
    [self.navigationController pushViewController:playerVC animated:YES];
}
-(void)searchDidClick:(NSString *)les_id {
    SCPlayerViewController *playerVC=[[SCPlayerViewController alloc]init];
//    playerVC.delegate=self;
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

-(void)allCourseBtnClickImage:(UIButton *)sender{
    if(_allCourseBtn.selected==NO){
        sender=self.allCourseBtn;
        if(self.searchView){
            [self.searchView removeFromSuperview];
        }
        [self.backView setHidden:NO];
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
}




-(void)allCourseBtnClick:(UIButton *)sender{
    if(_allCourseBtn.selected==NO){
            if(self.searchView){
                [self.searchView removeFromSuperview];
            }
            [self.backView setHidden:NO];
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
}


-(void)historyBtnClick:(UIButton *)sender{
    if(_videoHistoryBtn.selected==NO)
        {
            if(self.searchView){
                [self.searchView removeFromSuperview];
            }
            [self.backView setHidden:YES];
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
//            [self.videoHistoryView loadCourseListFromNetwork];
            
    }
    
}
-(void)historyBtnClickImage:(UIButton *)sender{
    if(_videoHistoryBtn.selected==NO)
    {
        sender=self.videoHistoryBtn;
        if(self.searchView){
            [self.searchView removeFromSuperview];
        }
        [self.backView setHidden:YES];
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
//        [self.videoHistoryView loadCourseListFromNetwork];

    }
    
}

-(void)noteBtnClick:(UIButton *)sender{
    if(_myNotesBtn.selected==NO)
        {
        if(self.searchView){
            [self.searchView removeFromSuperview];
        }
        [self.backView setHidden:YES];
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
    
}
-(void)noteBtnClickImage:(UIButton *)sender{
    if(_myNotesBtn.selected==NO)
    {
        sender=self.myNotesBtn;
        if(self.searchView){
            [self.searchView removeFromSuperview];
        }
        [self.backView setHidden:YES];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clearHistoryInfo" object:nil];

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

-(void)didLogOut{
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clearHistoryInfo" object:nil];
    
    [self unlogin];
    [self loginBtnClick];
}

-(void)hideLoginView{
    if(mark==1){
        [self.protocolView removeFromSuperview];
        self.protocolView=nil;
        mark=0;
    }else{
    [self.loginView removeFromSuperview];
    self.loginView = nil;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [self.webView removeFromSuperview];
    self.webView=nil;
    [self.extendView removeFromSuperview];
    self.extendView=nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"releaseClick" object:self userInfo:@{}];
    }
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
-(UIView *)backView{
    if(!_backView){
        _backView=[[UIView alloc]init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 40*WidthScale;
        _backView.backgroundColor=[UIColor whiteColor];
    }
    return _backView;
}
-(UITextField *)searchTextField{
    if(!_searchTextField){
        _searchTextField=[[UITextField alloc]init];
        //_SearchTextField=[[UITextField alloc]init];
        [_searchTextField setBackgroundColor:[UIColor whiteColor]];
        _searchTextField.placeholder = @"      请输入搜索内容";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _searchTextField.returnKeyType=UIReturnKeyDone;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.font = [UIFont systemFontOfSize:45*WidthScale];

//        _searchTextField.layer.masksToBounds = YES;
//        _searchTextField.layer.cornerRadius = 50*WidthScale;
        _searchTextField.textAlignment = UITextAlignmentLeft;
        _searchTextField.rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150*WidthScale, 150*HeightScale)];
        _searchTextField.rightView.backgroundColor=UIColorFromRGB(0x6fccdb);
        _searchTextField.rightViewMode=UITextFieldViewModeAlways;
        UIButton *searchBtn=[[UIButton alloc]init];
        [searchBtn setImage:[UIImage imageNamed:@"搜索白色"] forState:UIControlStateNormal];
        searchBtn.frame=CGRectMake(35*WidthScale, 45*HeightScale, 64*HeightScale, 64*HeightScale);
        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchTextField.rightView addSubview:searchBtn];
        _searchTextField.delegate=self;
        
    }
    return _searchTextField;
    
}

-(UIButton *)allCourseBtn{
    if (!_allCourseBtn){
        _allCourseBtn = [[UIButton alloc]init];
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
        _allCourseBtnImage.tag = _allCourseBtn.tag;
        [_allCourseBtnImage setImage:[UIImage imageNamed:@"SC_video"] forState:UIControlStateNormal];
        [_allCourseBtnImage setImage:[UIImage imageNamed:@"SC_video2"] forState:UIControlStateSelected];
        [_allCourseBtnImage addTarget:self action:@selector(allCourseBtnClickImage:) forControlEvents:UIControlEventTouchUpInside];
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
        [_videoHistoryBtnImage addTarget:self action:@selector(historyBtnClickImage:) forControlEvents:UIControlEventTouchUpInside];
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
        [_myNotesBtnImage addTarget:self action:@selector(noteBtnClickImage:) forControlEvents:UIControlEventTouchUpInside];
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
-(SCProtocolView *)protocolView{
    if (!_protocolView) {
        _protocolView = [[SCProtocolView alloc]initWithFrame:CGRectMake(0, 0, 0.88*self.view.width, 0.8*self.view.height)];
        //        _aboutView.frame = CGRectMake(0, 0, 0.68*self.view.width, 0.6*self.view.height);
        _protocolView.center = self.view.center;
    }
    return _protocolView;
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
-(SCSettingViewController *)setVC{
    if(!_setVC){
        _setVC = [[SCSettingViewController alloc]init];
        _setVC.delegate=self;
    }
    return _setVC;
}




#pragma mark -----getPhoneFrame-----
-(void)measureTheFrameOfScreen{

    if (IS_IPHONE) {
        //getIphoneFrame
        NSLog(@"iphone");
        [self getIphoneFrame];
    }else{
        //getIpadFrame
        NSLog(@"ipad");
        [self getIpadFrame];
    }
}


-(void)getIphoneFrame{

    self.loginBtn.frame = CGRectMake(0, 0, 400*WidthScale, 200*HeightScale);
    self.loginBtnImage.frame=CGRectMake(51*WidthScale, 48*HeightScale, 94*WidthScale, 94*WidthScale);
    self.leftView.frame = CGRectMake(0, self.loginBtn.bottom, self.loginBtn.width, self.view.height-self.loginBtn.height);
    self.allCourseBtn.frame=CGRectMake(0, 50*HeightScale, 400*WidthScale, 150*HeightScale);
    self.allCourseBtnImage.frame=CGRectMake(51*WidthScale, 50*HeightScale+49*HeightScale, 56*WidthScale, 50*HeightScale);
    self.videoHistoryBtn.frame=CGRectMake(0, 200*HeightScale, 400*WidthScale, 150*HeightScale);
    self.videoHistoryBtnImage.frame=CGRectMake(51*WidthScale, 200*HeightScale+40*HeightScale, 64*HeightScale, 64*HeightScale);
    self.myNotesBtn.frame=CGRectMake(0, 350*HeightScale, 400*WidthScale, 150*HeightScale);
    self.myNotesBtnImage.frame=CGRectMake(51*WidthScale, 350*HeightScale+40*HeightScale, 64*HeightScale, 64*HeightScale);
    self.favouriteSettingBtn.frame = CGRectMake(0, self.leftView.height-150*HeightScale,400*WidthScale, 150*HeightScale);
    self.favouriteSettingBtnImage.frame = CGRectMake(51*WidthScale, self.leftView.height-150*HeightScale+35*HeightScale,64*WidthScale, 64*WidthScale);
    self.searchTextField.frame= CGRectMake(25, 0, self.view.width/3-15, 100*HeightScale);
    self.backView.frame= CGRectMake(1234*WidthScale, 56*HeightScale, self.view.width/3, 100*HeightScale);
    mainFrame = CGRectMake(self.leftView.right, self.leftView.top, self.view.width-self.leftView.width, self.leftView.height);
    self.mainView.frame = mainFrame;
    self.allCourseView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
    self.myNotesView.frame = self.allCourseView.frame;
    self.videoHistoryView.frame = self.allCourseView.frame;
    self.loginView.frame = CGRectMake(0, 0, 889*WidthScale, 780*HeightScale);
    self.loginView.center = self.view.center;

//    self.searchView.frame = CGRectMake(0, 0, 0, 0);

}

-(void)getIpadFrame{
    
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
    self.searchTextField.frame= CGRectMake(25, 0, self.view.width/3-15, 100*HeightScale);
    self.backView.frame= CGRectMake(1234*WidthScale, 56*HeightScale, self.view.width/3, 100*HeightScale);
    //中央视图尺寸
    mainFrame = CGRectMake(self.leftView.right, self.leftView.top, self.view.width-self.leftView.width, self.leftView.height);
    self.mainView.frame = mainFrame;
    
    self.allCourseView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
    self.myNotesView.frame = self.allCourseView.frame;
    self.videoHistoryView.frame = self.allCourseView.frame;
//        self.searchView.frame = self.allCourseView.frame;

}









@end
