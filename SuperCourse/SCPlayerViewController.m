//
//  SCPlayerViewController.m
//  SuperCourse
//
//  Created by Develop on 16/1/24.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCPlayerViewController.h"
#import "SCRightView.h"
#import "SCVIdeoInfo.h"
#import "SZYVideoManager.h"
#import "SCPointView.h"
#import "SCVideoInfoModel.h"
#import "SCVideoLinkMode.h"
#import "SCVideoSubTitleMode.h"
#import "SCWebViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"


@interface SCPlayerViewController ()<SCPointViewDelegate, SCRightViewDelegate>{
    BOOL isAnimating; // 正在动画
    BOOL isFirstView;
    BOOL shouldPlaying;
}

//@property (nonatomic ,strong) SCVIdeoInfo *currentVideoInfo;
@property (nonatomic ,assign) NSTimeInterval lastPlayTime;


@property (nonatomic, strong) SCRightView *rightView;
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIButton *returnBtn;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UIButton *pauseBtn;
@property (nonatomic, strong) IBOutlet UIButton *resumeBtn;
@property (nonatomic, strong) IBOutlet UIButton *speedBtn;
@property (nonatomic, strong) IBOutlet UIButton *rightViewBtn;
@property (nonatomic, strong) IBOutlet UIButton *lockBtn;
@property (nonatomic, strong) IBOutlet UILabel *nowCourse;
@property (nonatomic, strong) IBOutlet UIButton *nowPoint;
@property (nonatomic, strong) IBOutlet UILabel *timeLable;
@property (nonatomic, strong) UITextField *insertNote;
@property (nonatomic, strong) IBOutlet UIView *startBtnView;
@property (nonatomic, strong) IBOutlet UIButton *startBtn;
@property (nonatomic, strong) IBOutlet UIButton *addPointBtn;
@property (nonatomic, strong) IBOutlet UIButton *writeNoteBtn;
@property (nonatomic, strong) IBOutlet UIButton *writeCodeBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) SZYVideoManager *videoManager;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) IBOutlet UIView *lockView;
@property (nonatomic, strong) IBOutlet UIView *writeNoteView;
@property (nonatomic, strong) IBOutlet UILabel *isDownloadLabel;
@property (nonatomic, strong) SCPointView *pointView;
@property (nonatomic, assign) CGFloat currentTime;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) IBOutlet UIButton *nextPlayerPlayBtn;
@property (nonatomic, strong) SCVideoInfoModel *videoInfo; // 播放视频的数据源
@property (nonatomic, strong) NSString *nowPointString;
@property (nonatomic, assign) CGFloat oversty_time;
@property (nonatomic, strong) IBOutlet UIAlertView *alert;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, assign) BOOL isNeedBack;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) IBOutlet UIView *indicatorShowView;
@property (nonatomic, strong) NSArray *letterArr;
@property (nonatomic, assign) NSTimeInterval beginTime;


@end

@implementation SCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isAnimating = NO; //防止重复的动画
//    [self loadDataStub]; //加载数据桩
//    self.lessonId = @"0001";
    [self addAllControl]; //加载界面上的所有控件
    isFirstView = YES;
//    [self.view addSubview:self.indicatorShowView];
    [self loadVideoInfo]; //从网络上下载视频文件的所有信息
    self.isNeedBack = NO;
}

// 从网络下载视频文件的所有信息
-(void)loadVideoInfo{
    NSString *userID = ApplicationDelegate.userSession; // 学员内码
    NSString *userPassword = ApplicationDelegate.userPsw; // 登录密码
    
    
    NSString *lesson_id = self.lessonId;

    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:userID forKey:@"stu_id"];
    [firstDic setValue:userPassword forKey:@"stu_pwd"];
    [firstDic setValue:lesson_id forKey:@"lesson_id"];
    
    NSMutableDictionary *secondDic = [[NSMutableDictionary alloc]init];
    [secondDic setValue:firstDic forKey:@"Data"];
    
    NSMutableDictionary *thirdDic = [[NSMutableDictionary alloc]init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"LoadVideoInfo" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        
//        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _videoInfo = [self getVideoInfo:dic];
        // 开始播放
        shouldPlaying = YES;
        self.videoManager = [[SZYVideoManager alloc]init];
        [self initVideoManager];
        [self.view addSubview:self.rightView];
        [self.rightView deleteDate:userID And:userPassword And:self.lessonId];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    

}

-(SCVideoInfoModel *)getVideoInfo:(NSDictionary *)dict{
   
    SCVideoInfoModel *m = [[SCVideoInfoModel alloc]init];
    NSMutableDictionary *dataDict = dict[@"data"];
    NSArray *videoInfoDict = dataDict[@"videoInfo"];
    m.les_name = videoInfoDict[0][@"les_name"];
    m.les_alltime = [videoInfoDict[0][@"les_alltime"] floatValue];
//    m.oversty_time = [videoInfoDict[0][@"oversty_time"] floatValue];
//    self.beginTime = m.oversty_time;
    m.les_url = videoInfoDict[0][@"les_url"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *url=[docDir stringByAppendingPathComponent:@"load2.mp4"];
//    m.les_url = url;
    m.les_size = videoInfoDict[0][@"les_size"];
    NSMutableArray *videoLinks = [[NSMutableArray alloc]init];
    NSArray *videoLinkArr = videoInfoDict[0][@"videoLinks"];
    for (int i=0; i<videoLinkArr.count; i++) {
        NSDictionary *linkDict = videoLinkArr[i];
        SCVideoLinkMode *link = [[SCVideoLinkMode alloc]init];
        link.link_les_id = linkDict[@"link_les_id"];
        link.hot_title = linkDict[@"hot_title"];
        link.bg_time = [linkDict[@"bg_time"] floatValue];
        link.target_type = linkDict[@"target_type"];
        link.web_url = linkDict[@"web_url"];
        [videoLinks addObject:link];
    }
    m.videoLinks = videoLinks;
    
    NSArray *oversty_time = videoInfoDict[0][@"oversty_time"];
    if (!oversty_time || oversty_time.count == 0) {
        self.beginTime = 0;
    }
    else{
        NSDictionary *timeDict = oversty_time[0];
        self.beginTime = [timeDict[@"oversty_time"] floatValue];
    }

    
    NSMutableArray *videoSubTitle = [[NSMutableArray alloc]init];
    NSArray *videoSubTitleArr = videoInfoDict[0][@"videoSubTitles"];
    for (int i=0; i<videoSubTitleArr.count; i++) {
        NSDictionary *subTitleDict = videoSubTitleArr[i];
        SCVideoSubTitleMode *subTitle = [[SCVideoSubTitleMode alloc]init];
        subTitle.subtitle = subTitleDict[@"subtitle"];
        subTitle.bg_time = [subTitleDict[@"bg_time"] floatValue];
        [videoSubTitle addObject:subTitle];
    }
    m.videoSubTitles = videoSubTitle;
    NSMutableArray *studentSubtitle = [[NSMutableArray alloc]init];
    NSArray *studentSubTitleArr = videoInfoDict[0][@"studentSubTitle"];
    for (int i=0; i<studentSubTitleArr.count; i++) {
        NSDictionary *stuSubTitleData = studentSubTitleArr[i];
        SCVideoSubTitleMode *stuSubTitle = [[SCVideoSubTitleMode alloc]init];
        stuSubTitle.subtitle = stuSubTitleData[@"subtitle"];
        stuSubTitle.bg_time = [stuSubTitleData[@"bg_time"] floatValue];
        [studentSubtitle addObject:stuSubTitle];
    }
    m.studentSubTitle = studentSubtitle;

    
    return m;
}

-(void)viewWillAppear:(BOOL)animated{

    self.isNeedBack = NO;
    [self.videoManager moveToSecond:self.oversty_time];
    self.slider.value = self.oversty_time;
    [self.videoManager pause];

}

-(void)viewWillDisappear:(BOOL)animated{
    self.oversty_time = self.currentTime;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VideoLoadDoneNotification object:nil];
    [self.videoManager moveToSecond:self.oversty_time];
    self.slider.value = self.oversty_time;
    [self.videoManager pause];
    self.isNeedBack = YES;
}

-(void)initVideoManager{

//    NSURL *murl=[NSURL fileURLWithPath:self.videoInfo.les_url];
    
    NSURL *murl = [NSURL URLWithString:self.videoInfo.les_url];
    [self.videoManager setUpRemoteVideoPlayerWithContentURL:murl view:self.container];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadDone:) name:VideoLoadDoneNotification object:nil];

    [self.container addSubview:self.startBtnView];
    [self.view addSubview:self.writeNoteView];
}




-(void)addAllControl{
    [self.view setBackgroundColor:UIBackgroundColor];
    [self.view addSubview:self.nowCourse];
    [self.view addSubview:self.nowPoint];
    [self.view addSubview:self.isDownloadLabel];
    [self.view addSubview:self.container];

    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.returnBtn];
    [self.bottomView addSubview:self.pauseBtn];
    [self.bottomView addSubview:self.speedBtn];
    [self.bottomView addSubview:self.rightViewBtn];
    [self.bottomView addSubview:self.lockBtn];
    [self.bottomView addSubview:self.timeLable];
    



}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2){
    
    }
}



-(void)playerPlayFinished{

    _alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"当前视频已播放完成,请添加您的备注"
                         
                                                 delegate:self
                         
                                        cancelButtonTitle:@"确定"
                         
                             otherButtonTitles:nil];
    
    
    [_alert show];
    _alert.tag = 1;
}

-(void)showCurrentTime:(NSTimeInterval)elapsedTime{
    
    CGFloat currentTime = MIN(elapsedTime, self.videoInfo.les_alltime);
    
    int hour = (int)(currentTime/3600);
    int minute = (int)(currentTime - hour*3600)/60;
    int second = (int)currentTime - hour*3600 - minute*60;
    int allHour = (int)(self.videoInfo.les_alltime/3600);
    int allMinute = (int)(self.videoInfo.les_alltime - allHour*3600)/60;
    int allSecond = (int)self.videoInfo.les_alltime - allHour*3600 - allMinute*60;
    NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d/%02d:%02d:%02d",hour,minute,second,allHour,allMinute,allSecond];
    self.timeLable.text = time;
    int nowTime =hour*3600+minute*60+second;
    if (nowTime == self.videoInfo.les_alltime && self.isNeedBack == NO && nowTime!=0) {
        if (_alert.tag == 0) {
            [self playerPlayFinished];
        }
        
    }
    
}

-(void)turnToTime:(UIButton *)sender{
    
//    if (!isAnimating) {
        [self.videoManager resume];
        [self.playBtn removeFromSuperview];
        [self.bottomView addSubview:self.pauseBtn];
        self.startBtnView.hidden = YES;
        [self transformRecover];
        shouldPlaying = YES;
//    }
    [self.videoManager moveToSecond:(NSTimeInterval)sender.superview.tag];
    self.slider.value = (NSTimeInterval)sender.superview.tag;
}

-(void)getStopTime{
//    ApplicationDelegate.userSession = UnLoginUserSession;
    
    if (![ApplicationDelegate.userSession isEqualToString:UnLoginUserSession]) {
        self.oversty_time = self.currentTime;
        
        NSMutableDictionary *methodParameter = [[NSMutableDictionary alloc]init];
        NSString *userID = ApplicationDelegate.userSession; // 学员内码
        NSString *userPassword = ApplicationDelegate.userPsw; // 登录密码
        NSString *lesson_id = self.lessonId;
        float oversty_time = self.oversty_time;
        if (!userPassword) {
            userPassword = @"7213116e861ef185275fcfd6e5fab98b";
        }
        [methodParameter setValue:userID forKey:@"stu_id"];
        [methodParameter setValue:userPassword forKey:@"stu_pwd"];
        [methodParameter setValue:lesson_id forKey:@"lesson_id"];
        [methodParameter setValue:@(oversty_time) forKey:@"oversty_time"];
        
        
        NSMutableDictionary *dataParameter = [[NSMutableDictionary alloc]init];
        [dataParameter setValue:methodParameter forKey:@"Data"];
        
        NSMutableDictionary *pageParameter = [[NSMutableDictionary alloc]init];
        [pageParameter setValue:dataParameter forKey:@"param"];
        [pageParameter setValue:@"AddStudentStopTime" forKey:@"method"];
        
        [HttpTool postWithparams:pageParameter success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }
    
    
    
    
}

#pragma mark - 点击事件

-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.videoManager stop];
    [self.delegate changeToLearn];
    [self getStopTime];
    
}


-(void)videoLoadDone:(NSNotification *)noti{
    
//    [self.indicatorShowView removeFromSuperview];
    [self.videoManager moveToSecond:self.beginTime];
    self.slider.value = self.beginTime;
    [self.videoManager startWithHandler:^(NSTimeInterval elapsedTime, NSTimeInterval timeRemaining, NSTimeInterval playableDuration, BOOL finished) {
        [self showCurrentTime:elapsedTime];
        self.currentTime = elapsedTime;
        self.nowPointString = [self.rightView.pointView getCurrentSubTitle:elapsedTime];
        if (self.rightView.pointView) {
            [self.rightView.pointView changeSubTitleViewWithTime:elapsedTime];
        }
        [self.rightView.tagList changeBtnLookingWithTime:elapsedTime];
        [self.nowPoint setTitle:self.nowPointString forState:UIControlStateNormal];


        
    }];
    if (!shouldPlaying) {
        [self.videoManager pause];
    }else{
        [self.videoManager resume];
    }
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(0 , self.startBtnView.height-60, self.startBtnView.width, 50)];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0;
    _slider.maximumValue = [noti.object floatValue];
    [self.startBtnView addSubview:_slider];
    [self.nowCourse setText:self.videoInfo.les_name];
    [self.isDownloadLabel setText:self.videoInfo.les_size];


}

-(void)closeWriteNoteView{

    self.writeNoteView.hidden = YES;
    
    self.textField.text = nil;
    

}

-(void)nextPlayerPlayBtnClick:(UIButton *)sender{

    
}

-(void)playBtnClick:(UIButton *)sender{
    if (!isAnimating) {
        [self.videoManager resume];
        [self.playBtn removeFromSuperview];
        [self.bottomView addSubview:self.pauseBtn];
        self.startBtnView.hidden = YES;
        [self transformRecover];
        shouldPlaying = YES;
    }
}


-(void)pauseBtnClick{

    [self.videoManager pause];
    [self.pauseBtn removeFromSuperview];
    [self.bottomView addSubview:self.playBtn];
    self.startBtnView.hidden = NO;
    [self transformAnimated];
    shouldPlaying = NO;
    
    
    [self getStopTime];
}



-(void)sliderValueChanged:(UISlider *)sender{
    
    [self.videoManager moveToSecond:sender.value];
    [self.videoManager pause];
    [self.bottomView addSubview:self.playBtn];
    [self.pauseBtn removeFromSuperview];
}

-(CGFloat)currentRate{
    
    return [self.videoManager currentRate];
    
}

-(void)resume{

    [self.videoManager resume];
    shouldPlaying = YES;
    [self.bottomView addSubview:self.pauseBtn];
    [self.playBtn removeFromSuperview];
    self.startBtnView.hidden = YES;
    [self transformRecover];

}

-(void)speedBtnClick:(CGFloat)rate{
    
    rate = [self currentRate];
    if (rate == 1.0) {
        [self.videoManager setCurrentRate:2.0];
        [self.speedBtn setImage:[UIImage imageNamed:@"5X"] forState:UIControlStateNormal];
        [self resume];
    }else if (rate == 2.0){
        [self.videoManager setCurrentRate:5.0];
        [self.speedBtn setImage:[UIImage imageNamed:@"10X"] forState:UIControlStateNormal];
        [self resume];
    }else if (rate == 5.0){
        [self.videoManager setCurrentRate:10.0];
        [self.speedBtn setImage:[UIImage imageNamed:@"20X"] forState:UIControlStateNormal];
        [self resume];
    }else if (rate == 10.0){
        [self.videoManager setCurrentRate:20.0];
        [self.speedBtn setImage:[UIImage imageNamed:@"1X"] forState:UIControlStateNormal];
        [self resume];
    }else {
        [self.videoManager setCurrentRate:1.0];
        [self.speedBtn setImage:[UIImage imageNamed:@"2X"] forState:UIControlStateNormal];
        [self resume];
    }
    
}

-(void)rightViewBtnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform = sender.selected ? CGAffineTransformMakeTranslation(-659*WidthScale, 0) : CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        [self.rightViewBtn setImage:[UIImage imageNamed:@"边栏"] forState:UIControlStateSelected];
    }];
}


-(void)lockBtnClick{
    
    self.lockView.hidden = NO;
    self.lockBtn.selected = YES;
   
}

-(void)unLockBtnClick{

    self.lockView.hidden = YES;
    self.lockBtn.selected = NO;
}


-(void)startBtnClick{

    if (!isAnimating) {
        self.startBtnView.hidden = YES;
        [self transformRecover];
        [self.videoManager resume];
        shouldPlaying = YES;
        [self.bottomView addSubview:self.pauseBtn];
        [self.playBtn removeFromSuperview];
    }
}

-(void)writeNoteBtnClick{

    self.startBtnView.hidden = YES;
    [self transformRecover];
}

-(void)writeCodeBtnClick{

    self.startBtnView.hidden = YES;
    [self transformRecover];
}

-(void)addPointBtnClick{
    
    if (![self timeExist]) {
        self.startBtnView.hidden = YES;
        [self transformRecover];
        self.writeNoteView.hidden = NO;
        [self.textField becomeFirstResponder];
        if (self.rightViewBtn.selected ) {
            self.rightViewBtn.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.rightView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                [self.rightViewBtn setImage:[UIImage imageNamed:@"边栏"] forState:UIControlStateSelected];
            }];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前时间已存在子标题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(BOOL)timeExist{
    BOOL exist = NO;
    int time = (int)self.currentTime;
    for (int i=0; i<self.videoInfo.videoSubTitles.count; i++) {
        SCVideoSubTitleMode *m = self.videoInfo.videoSubTitles[i];
        if (time== (int)m.bg_time) {
            exist = YES;
            break;
        }else {
        }
    }
    return exist;
}
//-(void)getCurrectOrder{
//
//    NSMutableArray *subTitleArr = [[NSMutableArray alloc]init];
//    int shouldInsert;
//    for (UIView *view in self.rightView.pointView.subviews) {
//        [subTitleArr addObject:view];
//    }
//    
//    for (int i=0; i<subTitleArr.count-1; i++) {
//        int m = (int)subTitleArr.count-1;
//        UIView *changeView = subTitleArr[m];
//        UIView *nowView = subTitleArr[i];
//        if (changeView.tag<nowView.tag) {
//            changeView.y = nowView.y - 100*HeightScale;
//            shouldInsert = i;
//            break;
//        }
//    }
//    for (shouldInsert; shouldInsert<subTitleArr.count; shouldInsert++) {
//        UIView *nowView = subTitleArr[shouldInsert];
//        nowView.y = nowView.y+100*HeightScale;
//    }
//    
//
//    
//}


-(void)addPoint{
    
    if (![self.textField.text isEqualToString:@""]) {
        SCVideoSubTitleMode *subTitle = [[SCVideoSubTitleMode alloc]init];
        NSTimeInterval time = self.currentTime;
        subTitle.subtitle = self.textField.text;
        subTitle.bg_time = time;
        
        // 写入网络数据库
        NSMutableDictionary *methodParameter = [[NSMutableDictionary alloc]init];
        NSString *userID = ApplicationDelegate.userSession; // 学员内码
        NSString *userPassword = ApplicationDelegate.userPsw; // 登录密码
        NSString *lesson_id = self.lessonId;
        if (!userPassword) {
            userPassword = @"7213116e861ef185275fcfd6e5fab98b";
        }
        [methodParameter setValue:userID forKey:@"stu_id"];
        [methodParameter setValue:userPassword forKey:@"stu_pwd"];
        [methodParameter setValue:lesson_id forKey:@"lesson_id"];
        [methodParameter setValue:subTitle.subtitle forKey:@"subtitle"];
        [methodParameter setValue:@((int)subTitle.bg_time) forKey:@"bg_time"];
        
        NSMutableDictionary *dataParameter = [[NSMutableDictionary alloc]init];
        [dataParameter setValue:methodParameter forKey:@"Data"];
        
        NSMutableDictionary *pageParameter = [[NSMutableDictionary alloc]init];
        [pageParameter setValue:dataParameter forKey:@"param"];
        [pageParameter setValue:@"AddStudentSubtitle" forKey:@"method"];
        
        [HttpTool postWithparams:pageParameter success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            for (int i=0; i<self.videoInfo.videoSubTitles.count; i++) {
//                SCVideoSubTitleMode *m = self.videoInfo.videoSubTitles[i];
//                if ((int)subTitle.bg_time== (int)m.bg_time) {
                    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前时间已存在节点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    
            
                    
            
                    UIView *subTitleView = [self.rightView.pointView addCustomSubTitleWithData:subTitle];
                    [self.rightView.pointView addSubview:subTitleView];
                    self.writeNoteView.hidden = YES;
                    [self.videoManager resume];
                    shouldPlaying = YES;
                    [self.bottomView addSubview:self.pauseBtn];
                    [self.playBtn removeFromSuperview];
                    
                    for (UIView *view in self.rightView.pointView.subviews) {
                        if (view.tag>subTitle.bg_time) {
                            view.y = view.y+110*HeightScale;
                            subTitleView.y = subTitleView.y-110*HeightScale;
                        
                    
                }
            }
        
            
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            // 给出插入失败的提示
            
            
            self.writeNoteView.hidden = YES;
            [self.videoManager resume];
            shouldPlaying = YES;
            [self.bottomView addSubview:self.pauseBtn];
            [self.playBtn removeFromSuperview];
            
        }];
        
        self.textField.text = nil;
        [self.textField endEditing:YES];
    }
    

}






- (void)tapBtn:(UIPanGestureRecognizer *) recognizer{

    if (!isAnimating) {
        BOOL _hidden;
        _hidden = self.startBtnView.hidden;
        
        if ([self.pauseBtn isDescendantOfView:self.bottomView]) {
            self.startBtnView.hidden = NO;
            [self transformAnimated];
            [self.videoManager pause];
            [self getStopTime];
            shouldPlaying = NO;
//            [self.speedBtn setImage:[UIImage imageNamed:@"2X"] forState:UIControlStateNormal];
            [self.bottomView addSubview:self.playBtn];
            [self.pauseBtn removeFromSuperview];
            
        }else{
            shouldPlaying = YES;
            if (_hidden) {
                [self.videoManager resume];
                [self.bottomView addSubview:self.pauseBtn];
                [self.playBtn removeFromSuperview];
            }else{
                [self.videoManager resume];
                [self.bottomView addSubview:self.pauseBtn];
                [self.playBtn removeFromSuperview];
                self.startBtnView.hidden = YES;
                [self transformRecover];
                
            }
        }
//        shouldPlaying = !shouldPlaying;

    }
    
    
}


-(void)transformAnimated{

    isAnimating = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.addPointBtn.alpha = 1;
 
        
        self.addPointBtn.frame = CGRectMake(932*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);

        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.writeCodeBtn.alpha = 1;
            self.writeNoteBtn.alpha = 1;

            self.writeNoteBtn.frame = CGRectMake(901*WidthScale*2048/1614, 568*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);
            self.writeCodeBtn.frame = CGRectMake(901*WidthScale*2048/1614, 308*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);
            self.writeCodeBtn.transform = CGAffineTransformMakeRotation(-0.5);
            self.writeNoteBtn.transform = CGAffineTransformMakeRotation(0.5);
        }completion:^(BOOL finished) {
            isAnimating = NO;
        } ];
    }];
}

-(void)transformRecover{

        
        self.addPointBtn.alpha = 0;
        self.writeCodeBtn.alpha = 0;
        self.writeNoteBtn.alpha = 0;
        self.addPointBtn.frame=CGRectMake(668*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);
        self.writeCodeBtn.frame=CGRectMake(932*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);
        self.writeNoteBtn.frame=CGRectMake(932*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563);
    

        self.writeCodeBtn.transform = CGAffineTransformMakeRotation(0);
        self.writeNoteBtn.transform = CGAffineTransformMakeRotation(0);
    

    
}



-(void)panToTime:(UIPanGestureRecognizer*) recognizer{

    CGPoint statePoint = [recognizer translationInView:self.container];
 
    
//    beginStatePoint = [recognizer locationInView:self.container];
//    
//    CGFloat beginStateX = beginStatePoint.x;
//    CGFloat endStateX;
    CGFloat endStateY;
    CGPoint endStatePoint = [recognizer locationInView:self.container];
//    endStateX = endStatePoint.x;
    endStateY = endStatePoint.y;
    CGFloat moveDistance = statePoint.x;
    if (endStateY >= 0 && endStateY < self.container.height/3) {
        CGFloat turnToSecond = self.currentTime+2000*moveDistance/self.container.width ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }else if (endStateY >= self.container.height/3 && endStateY < self.container.height*2/3){
        CGFloat turnToSecond = self.currentTime+(360*moveDistance/self.container.width) ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }else if (endStateY >= self.container.height*2/3 && endStateY < self.container.height){
        CGFloat turnToSecond = self.currentTime+60*moveDistance/self.container.width ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }
}


#pragma mark - getters

-(SCRightView *)rightView{
    
    if (!_rightView) {
        _rightView = [[SCRightView alloc]initWithFrame:CGRectMake(UIScreenWidth, 0, 659*WidthScale, 1382*HeightScale)];
        _rightView.pointViewDelegate = self;
        _rightView.subTitleArr = _videoInfo.videoSubTitles;
        _rightView.stuSubTitleArr = _videoInfo.studentSubTitle;
        [_rightView.tagList setTags:_videoInfo.videoLinks];
        _rightView.delegate = self;
    }
    return _rightView;
}

-(UIView *)container{
    
    if (!_container) {
        _container = [[UIView alloc]init];
        [_container setBackgroundColor:UIThemeColor];
        _container.frame = CGRectMake(0, 100*HeightScale, 2048*WidthScale, 1280*HeightScale);
        [self.container addGestureRecognizer:self.tap];
        [self.container addGestureRecognizer:self.pan];
    }
    return _container;
}

-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.frame = CGRectMake(0, 1382*HeightScale, UIScreenWidth, 154*WidthScale);
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
    }
    return _bottomView;
}

-(UIButton *)returnBtn{
    
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(22*WidthScale, 38*HeightScale, 44*WidthScale, 44*HeightScale);
        [_returnBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

-(UIButton *)playBtn{
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(50*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
-(UIButton *)nextPlayerPlayBtn{
    
    if (!_nextPlayerPlayBtn) {
        _nextPlayerPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextPlayerPlayBtn.frame = CGRectMake(50*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_nextPlayerPlayBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [_nextPlayerPlayBtn addTarget:self action:@selector(nextPlayerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextPlayerPlayBtn;
}


-(UIButton *)pauseBtn{

    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseBtn.frame = CGRectMake(50*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_pauseBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_pauseBtn addTarget:self action:@selector(pauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseBtn;
}

-(UIButton *)speedBtn{
    
    if (!_speedBtn) {
        _speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedBtn.frame = CGRectMake(1581*WidthScale, 45*HeightScale, 99*WidthScale, 64*HeightScale);
        [_speedBtn setImage:[UIImage imageNamed:@"2X"] forState:UIControlStateNormal];
        [_speedBtn addTarget:self action:@selector(speedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedBtn;
}

-(UIButton *)rightViewBtn{
    
    if (!_rightViewBtn) {
        _rightViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightViewBtn.frame = CGRectMake(1760*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_rightViewBtn setImage:[UIImage imageNamed:@"收起侧边栏"] forState:UIControlStateNormal];
        [_rightViewBtn addTarget:self action:@selector(rightViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightViewBtn;
}

-(UIButton *)lockBtn{
    
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lockBtn.frame = CGRectMake(1904*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_lockBtn setImage:[UIImage imageNamed:@"no hold"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"hold"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _lockBtn.selected = NO;
    }
    return _lockBtn;
}

-(UILabel *)nowCourse{
    
    if (!_nowCourse) {
        _nowCourse = [[UILabel alloc]initWithFrame:CGRectMake(160*WidthScale, 10, 440*WidthScale, 90*HeightScale)];
        _nowCourse.font = [UIFont systemFontOfSize:35*HeightScale];
        [_nowCourse setTextColor:[UIColor grayColor]];
        _nowCourse.alpha = 0.7;
    }
    return _nowCourse;
}

-(UIButton *)nowPoint{
    
    if (!_nowPoint) {
        _nowPoint = [UIButton buttonWithType:UIButtonTypeCustom];
        _nowPoint.frame = CGRectMake(630*WidthScale, 10, 440*WidthScale, 90*HeightScale);
//        [_nowPoint setTitle:self.nowPointString forState:UIControlStateNormal];
        _nowPoint.titleLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        [_nowPoint setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_nowPoint setTitleColor:UIThemeColor forState:UIControlStateHighlighted];
        _nowPoint.alpha = 0.7;
        _nowPoint.enabled = NO;
    }
    return _nowPoint;
}

-(UILabel *)timeLable{
    
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(170*WidthScale, 0, 440*WidthScale, 154*HeightScale)];
        _timeLable.font = [UIFont systemFontOfSize:35*HeightScale];
        [_timeLable setTextColor:[UIColor grayColor]];
        _timeLable.alpha = 0.9;
    }
    return _timeLable;
}

-(UITextField *)insertNote{
    
    if (!_insertNote) {
        _insertNote = [[UITextField alloc]init];
        _insertNote.placeholder = @"密码";
        _insertNote.clearButtonMode = UITextFieldViewModeWhileEditing;
        _insertNote.keyboardType = UIKeyboardTypeDefault;
        _insertNote.secureTextEntry = YES;
        _insertNote.returnKeyType = UIReturnKeyDone;
        _insertNote.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _insertNote.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imgUser = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-password"]];
        imgUser.frame = CGRectMake(10, 10, 20, 20);
        [_insertNote.leftView addSubview:imgUser];
    }
    return _insertNote;
}

-(UIView *)startBtnView{

    if (!_startBtnView) {
        _startBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2048*WidthScale, 1280*HeightScale)];
        _startBtnView.backgroundColor = [UIColor clearColor];
        [_startBtnView addSubview:self.startBtn];
        [_startBtnView addSubview:self.writeCodeBtn];
        [_startBtnView addSubview:self.writeNoteBtn];
        [_startBtnView addSubview:self.addPointBtn];
        _startBtnView.hidden = YES;
       
    }
    return _startBtnView;
}

-(UIButton *)startBtn{

    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [_startBtn setFrame:CGRectMake(668*WidthScale*2048/1614, 361*HeightScale/1212*1563, 234*WidthScale*2048/1614, 234*HeightScale/1212*1563)];
        [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _startBtn;
}

-(UIButton *)writeCodeBtn{
    
    if (!_writeCodeBtn) {
        _writeCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeCodeBtn setBackgroundImage:[UIImage imageNamed:@"敲代码"] forState:UIControlStateNormal];
        [_writeCodeBtn setFrame:CGRectMake(932*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563)];
        [_writeCodeBtn addTarget:self action:@selector(writeCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _writeCodeBtn.alpha = 0;
    }
    return _writeCodeBtn;
}



-(UIButton *)writeNoteBtn{
    
    if (!_writeNoteBtn) {
        _writeNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeNoteBtn setBackgroundImage:[UIImage imageNamed:@"记笔记"] forState:UIControlStateNormal];
//        [_writeNoteBtn setFrame:CGRectMake(906*WidthScale*2048/1614, 265*HeightScale/1212*1563, 213*WidthScale*2048/1614, 157*HeightScale/1212*1563)];
        [_writeNoteBtn setFrame:CGRectMake(932*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563)];
        [_writeNoteBtn addTarget:self action:@selector(writeNoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _writeNoteBtn.alpha = 0;
        
    }
    return _writeNoteBtn;
}

-(UIButton *)addPointBtn{
    
    if (!_addPointBtn) {
        _addPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPointBtn setBackgroundImage:[UIImage imageNamed:@"写备注"] forState:UIControlStateNormal];
        [_addPointBtn setFrame:CGRectMake(668*WidthScale*2048/1614, 438*HeightScale/1212*1563, 234*WidthScale*2048/1614, 75*HeightScale/1212*1563)];
        [_addPointBtn addTarget:self action:@selector(addPointBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addPointBtn.alpha = 0;
    }
    return _addPointBtn;
}

- (UITapGestureRecognizer *)tap{
    
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtn:)];
        
    }
    return _tap;
}



-(UIView *)lockView{

    if (!_lockView) {
        _lockView = [[UIView alloc]initWithFrame:self.view.frame];
        [_lockView setBackgroundColor:[UIColor clearColor]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(1904*WidthScale, 1427*HeightScale, 64*WidthScale, 64*HeightScale)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(unLockBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.lockView addSubview:btn];
        [self.view addSubview:_lockView];
        _lockView.hidden = YES;
    }
    return _lockView;
}

//-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.writeNoteView resignFirstResponder];
//}

-(UIView *)writeNoteView{

    if (!_writeNoteView) {
        _writeNoteView = [[UIView alloc]initWithFrame:self.view.frame];
        _writeNoteView.backgroundColor = [UIColor clearColor];

        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"添加备注"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 100*WidthScale, 100*HeightScale);
        [btn addTarget:self action:@selector(addPoint) forControlEvents:UIControlEventTouchUpInside];
  
        [self.textField.rightView addSubview:btn];
        [_writeNoteView addSubview:self.textField];
        _writeNoteView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeWriteNoteView)];
        [_writeNoteView addGestureRecognizer:tap];
        
        
    }
    return _writeNoteView;
}

-(UITextField *)textField{

    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width-1700*WidthScale)/2,361*HeightScale/1212*1563 , 1700*WidthScale, 200*HeightScale)];
        _textField.placeholder = @"请添加节点，不超过20字";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        textField.keyboardType = UIKeyboardTypeDefault;
        _textField.secureTextEntry = NO;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.backgroundColor = UIBackgroundColor;
        _textField.textColor = UIThemeColor;
        _textField.font = [UIFont systemFontOfSize:70*HeightScale];
        _textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(1580*WidthScale, 50*HeightScale, 100*WidthScale, 100*HeightScale)];
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.textField resignFirstResponder];
}

-(UILabel *)isDownloadLabel{

    if (!_isDownloadLabel) {
        _isDownloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(1743*WidthScale, 10, 305*WidthScale, 90*HeightScale)];
        _isDownloadLabel.font = [UIFont systemFontOfSize:35*HeightScale];
        [_isDownloadLabel setTextColor:[UIColor grayColor]];
        _isDownloadLabel.alpha = 0.7;
    }
    return _isDownloadLabel;
}

-(UIPanGestureRecognizer *)pan{

    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToTime:)];
    }
    return _pan;
}

-(void)pausePlayer{
    
    if ([self.videoManager currentRate] != 0) {
        [self.videoManager pause];
        [self.pauseBtn removeFromSuperview];
        [self.bottomView addSubview:self.playBtn];
        self.startBtnView.hidden = NO;
        [self transformAnimated];
        shouldPlaying = NO;
    }
}

// 显示网页
- (void)showWeb:(SCVideoLinkMode *)link {
    [self pausePlayer];
    SCWebViewController *webVC = [[SCWebViewController alloc]init];
    [webVC getUrl:link.web_url];
    [self.navigationController pushViewController:webVC animated:YES ];
}

// 显示播放器
- (void)showPlayer:(SCVideoLinkMode *)link {
    // 写入网络数据库
    NSMutableDictionary *methodParameter = [[NSMutableDictionary alloc]init];
    NSString *userID = ApplicationDelegate.userSession; // 学员内码
    NSString *userPassword = ApplicationDelegate.userPsw; // 登录密码
    NSString *lesson_id = link.link_les_id;
    if (!userPassword) {
        userPassword = @"7213116e861ef185275fcfd6e5fab98b";
    }
    [methodParameter setValue:userID forKey:@"stu_id"];
    [methodParameter setValue:userPassword forKey:@"stu_pwd"];
    [methodParameter setValue:lesson_id forKey:@"lesson_id"];
    
    NSMutableDictionary *dataParameter = [[NSMutableDictionary alloc]init];
    [dataParameter setValue:methodParameter forKey:@"Data"];
    
    NSMutableDictionary *pageParameter = [[NSMutableDictionary alloc]init];
    [pageParameter setValue:dataParameter forKey:@"param"];
    [pageParameter setValue:@"CheckPermission" forKey:@"method"];
    
    [HttpTool postWithparams:pageParameter success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *permission = dic[@"data"];
        if ([permission isEqualToString:@"是"]) {
            //    BOOL isFirstView;
            SCPlayerViewController *playerVC = [[SCPlayerViewController alloc]init];
            playerVC.lessonId = link.link_les_id;
            //    isFirstView = NO;
            [self pausePlayer];
            [self.navigationController pushViewController:playerVC animated:YES];
        }else{
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前视频无权限" delegate:self cancelButtonTitle:@"是" otherButtonTitles: nil];
            [view show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        // 给出插入失败的提示，未完成
    }];
}

// 打开链接
-(void)openLink:(SCVideoLinkMode *)link{
    
    if ([link.target_type isEqualToString:@"视频"]) {
        self.oversty_time = self.currentTime;
        [self showPlayer:link];
    }else if ([link.target_type isEqualToString:@"网页"]){
        [self showWeb:link];
    }
    
}

// 检查链接的权限（当前学员是否可以观看链接视频）




-(UIActivityIndicatorView *)indicatorView{

    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.container.width-200*WidthScale)/2, (self.container.height-200*HeightScale)/2, 200*WidthScale, 200*HeightScale)];
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.backgroundColor = [UIColor whiteColor];
    }
    return _indicatorView;
}

-(UIView *)indicatorShowView{

    if (!_indicatorShowView) {
        _indicatorShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*HeightScale, self.view.width, self.view.height)];
        _indicatorShowView.backgroundColor = [UIColor clearColor];
        [_indicatorShowView addSubview:self.indicatorView];
    }
    return _indicatorShowView;
}


@end
