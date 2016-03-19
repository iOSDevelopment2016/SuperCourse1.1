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
#import "SCIntroductionDataSource.h"
#import "SCVideoSubTitleMode.h"
#import "SCWebViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "NSObject+MJProperty.h"
//#import "LocalDatabase.h"
#import "SZYNoteSolidater.h"
#import "SCDownlodaMode.h"
#import "WQPlaySound.h"
#import "SCWillLearn.h"
#import <AudioToolbox/AudioToolbox.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface SCPlayerViewController ()<SCPointViewDelegate, SCRightViewDelegate, UITextFieldDelegate,WXApiDelegate,TencentSessionDelegate>{
    BOOL isAnimating; // 正在动画
    BOOL isFirstView;
    BOOL shouldPlaying;
    UIView *showView;
    CGPoint leftTopPoint;
    CGFloat writeNoteTime;
    CGFloat writeCodeTime;
    CGFloat nowTimel;
    BOOL isPlayFinished;
    CGFloat studyTime;
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
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) SZYNoteSolidater  *db;
@property (nonatomic, strong) UIView *hubView;
@property (nonatomic, strong) UITapGestureRecognizer *tapToRemove;
@property (nonatomic, strong) UIView *playFinishedHubView;
@property (nonatomic, strong) UIButton *cutBtn;
@property (nonatomic, strong) UIPanGestureRecognizer *panToSetVoice;
@property (nonatomic, strong) UIButton *sureToCut;
@property (nonatomic, strong) UIButton *chooseViewAgain;
@property (nonatomic, strong) UIView *playerPlayFinishedView;
@property (nonatomic ,strong) SCIntroductionDataSource *datasource;
@property (nonatomic, strong) UIView *preLabel;

@property (retain, nonatomic) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSMutableArray *writeNoteTimeArr;
@property (nonatomic, strong) NSMutableArray *writeCodeTimeArr;

@property (nonatomic, strong) NSString *shareString;

@end

@implementation SCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db=[[SZYNoteSolidater alloc]init];
    isAnimating = NO; //防止重复的动画
    [self addAllControl]; //加载界面上的所有控件
    isFirstView = YES;
    [self loadVideoInfo]; //从网络上下载视频文件的所有信息
    [self getSystemTime];
    [self observe];
    _preLabel = [self getPreKnowLabel];
    self.isNeedBack = NO;
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105153909" andDelegate:self];
    
    
}

-(void)observe{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playWithFile:)
                                                 name: @"downloadFinished"
                                               object: nil];
    
    
    
    
}

-(UIView *)getPreKnowLabel{
    UIView *preKnowView = [[UIView alloc]initWithFrame:CGRectMake(0.03*SCREEN_WIDTH+30*WidthScale, 0.12*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH-30*WidthScale, 0.23*SCREEN_HEIGHT)];
    NSString *Id=self.lessonId;
    NSDictionary *para = @{@"method":@"Getintroduction",
                           @"param":@{@"Data":@{@"les_id":Id}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = dic[@"data"];
        NSArray *willKnowArr = dict[@"willknow"];
        for (int i=0; i<willKnowArr.count; i++) {
            NSDictionary *willknowDic = willKnowArr[i];
            NSString *willknow = willknowDic[@"har_des"];
            UILabel *preKnowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*0.03*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH-30*WidthScale, 0.03*SCREEN_HEIGHT)];
            preKnowLabel.text = willknow;
            preKnowLabel.textColor = [UIColor grayColor];
            preKnowLabel.font = [UIFont systemFontOfSize:25*WidthScale];
            preKnowLabel.textAlignment =NSTextAlignmentLeft;
            [preKnowView addSubview:preKnowLabel];
        }
        
    }failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    //    preKnowLabel.backgroundColor = UIThemeColor;
    
    return preKnowView;
}

-(void)setIsDownloadLabelText{
    
    if ([self isDownLoad]) {
        self.isDownloadLabel.text = [NSString stringWithFormat:@"已下载"];
    }else{
        [self.isDownloadLabel setText:self.videoInfo.les_size];
    }
}

- (void)playWithFile:(NSNotification *)message{
    
    NSDictionary *userInfo = [message userInfo];
    NSString *les_ID = userInfo[@"les_ID"];
    BOOL isDownload =YES;
    if (isDownload) {
        if ([les_ID isEqualToString:self.lessonId]) {
            [self continuePlaying];
        }
    }
    [self.downloadBtn removeFromSuperview];
    self.isDownloadLabel.text = [NSString stringWithFormat:@"已下载"];
    
}
-(void)continuePlaying{
    
    [self getStopTimeWithCurrentTime:self.currentTime];
    self.oversty_time = self.currentTime;
    [self.slider removeFromSuperview];
    [self.videoManager stop];
    self.videoManager = nil;
    [self loadVideoInfo];
    [self.videoManager moveToSecond:self.oversty_time];
    
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

-(BOOL)isDownLoad{
    //    LocalDatabase *db = [LocalDatabase sharedManager];
    //    BOOL msg=[db isDownload:self.lessonId];
    __block BOOL isdownload;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByID:self.lessonId successHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            SCDownlodaMode *mode=[noteArr firstObject];
            if ([mode.finished isEqualToString:@"YES"]) {
                isdownload=YES;
            }else{
                isdownload=NO;
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    
    return isdownload;
}

-(void)getVideoURLWithDict:(SCVideoInfoModel *)m AndVideoInfoDict:(NSArray *)videoInfoDict AndLes_name:(NSString *)les_name{
    BOOL isDownLoad = [self isDownLoad];
    NSString *url = videoInfoDict[0][@"les_url"];
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *name = array[4];
    if (isDownLoad) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *url=[docDir stringByAppendingPathComponent:name];
        m.les_url = url;
    }else{
        m.les_url = videoInfoDict[0][@"les_url"];
    }
}


-(SCVideoInfoModel *)getVideoInfo:(NSDictionary *)dict{
    
    SCVideoInfoModel *m = [[SCVideoInfoModel alloc]init];
    NSMutableDictionary *dataDict = dict[@"data"];
    NSArray *videoInfoDict = dataDict[@"videoInfo"];
    m.les_name = videoInfoDict[0][@"les_name"];
    m.les_alltime = [videoInfoDict[0][@"les_alltime"] floatValue];
    //    m.oversty_time = [videoInfoDict[0][@"oversty_time"] floatValue];
    //    self.beginTime = m.oversty_time;
    //    m.les_url = videoInfoDict[0][@"les_url"];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *docDir = [paths objectAtIndex:0];
    //    NSString *url=[docDir stringByAppendingPathComponent:@"load2.mp4"];
    //    m.les_url = url;
    [self getVideoURLWithDict:m AndVideoInfoDict:videoInfoDict AndLes_name:m.les_name];
    m.les_size = videoInfoDict[0][@"les_size"];
    self.videoInfo.les_size = m.les_size;
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
    NSURL *murl = nil;
    if ([self isDownLoad]) {
        murl=[NSURL fileURLWithPath:self.videoInfo.les_url];
    }else{
        murl = [NSURL URLWithString:self.videoInfo.les_url];
    }
    
    [self.videoManager setUpRemoteVideoPlayerWithContentURL:murl view:self.container];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadDone:) name:VideoLoadDoneNotification object:nil];
    
    [self.container addSubview:self.startBtnView];
    [self.view addSubview:self.writeNoteView];
    [self.videoManager moveToSecond:self.oversty_time];
    [self setIsDownloadLabelText];
    
}




-(void)addAllControl{
    [self.view setBackgroundColor:UIBackgroundColor];
    [self.view addSubview:self.nowCourse];
    [self.view addSubview:self.nowPoint];
    [self.view addSubview:self.isDownloadLabel];
    [self.view addSubview:self.container];
    if (![self isDownLoad]) {
        [self.view addSubview:self.downloadBtn];
    }
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.returnBtn];
    [self.bottomView addSubview:self.pauseBtn];
    [self.bottomView addSubview:self.speedBtn];
    [self.bottomView addSubview:self.rightViewBtn];
    [self.bottomView addSubview:self.lockBtn];
    [self.bottomView addSubview:self.timeLable];
    [self.bottomView addSubview:self.cutBtn];
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            CGFloat time = 0;
            [_slider removeFromSuperview];
            [self getStopTimeWithCurrentTime:time];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2){
        
    }
}

-(NSString *)changeTimeToString:(CGFloat )time{

    int hour = (int)(time/3600);
    int minute = (int)(time - hour*3600)/60;
    int second = (int)time - hour*3600 - minute*60;
    NSString *string = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    return string;
}


-(void)playerPlayFinished{
    
    CGFloat finishedTime = [self getSystemTime];
    studyTime = finishedTime - studyTime;
    CGFloat allCodeTime = 0;
    CGFloat allNoteTime = 0;
    for (int i=0 ; i<self.writeCodeTimeArr.count; i++) {
        allCodeTime = allCodeTime + [self.writeCodeTimeArr[i] floatValue];
    }
    for (int i=0 ; i<self.writeNoteTimeArr.count; i++) {
        allNoteTime = allNoteTime + [self.writeNoteTimeArr[i] floatValue];
    }
    
    
    NSString *lesname = self.videoInfo.les_name;
    int writeNoteTimes = self.writeNoteTimeArr.count;
    int writeCodeTimes = self.writeCodeTimeArr.count;
    NSString *allCodeTimeString = [self changeTimeToString:allCodeTime];
    NSString *allNoteTimeString = [self changeTimeToString:allNoteTime];
    NSString *allStudyTimeString = [self changeTimeToString:studyTime];
    
    
    NSString *playFinishedString = [NSString stringWithFormat:@"我学习的课程为:%@。\n在本次学习中共敲代码:%d次，用时%@。 \n共记笔记%d次，用时%@。 \n本次学习总时长为:%@。",lesname,writeCodeTimes,allCodeTimeString,writeNoteTimes,allNoteTimeString,allStudyTimeString];
    _shareString = playFinishedString;
    
    //    _alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"当前视频已播放完成,请添加您的备注"
    //
    //                                      delegate:self
    //
    //                             cancelButtonTitle:@"确定"
    //
    //                             otherButtonTitles:nil];
    //
    //
    //    [_alert show];
    //    _alert.tag = 1;
    [self.view addSubview:self.playFinishedHubView];
    [self.view addSubview:self.playerPlayFinishedView];
    
    
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
            if (!_playerPlayFinishedView) {
                [self playerPlayFinished];
            }
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

-(void)getStopTimeWithCurrentTime:(CGFloat)time{
    //    ApplicationDelegate.userSession = UnLoginUserSession;
    
    if (![ApplicationDelegate.userSession isEqualToString:UnLoginUserSession]) {
        self.oversty_time = time;
        
        NSMutableDictionary *methodParameter = [[NSMutableDictionary alloc]init];
        NSString *userID = ApplicationDelegate.userSession; // 学员内码
        NSString *userPassword = ApplicationDelegate.userPsw; // 登录密码
        NSString *lesson_id = self.lessonId;
        NSString *is_ready = @"否";
        float oversty_time = self.oversty_time;
        if (isPlayFinished) {
            is_ready = @"是";
        }
        
        if (!userPassword) {
            userPassword = @"7213116e861ef185275fcfd6e5fab98b";
        }
        [methodParameter setValue:userID forKey:@"stu_id"];
        [methodParameter setValue:userPassword forKey:@"stu_pwd"];
        [methodParameter setValue:lesson_id forKey:@"lesson_id"];
        [methodParameter setValue:@(oversty_time) forKey:@"oversty_time"];
        [methodParameter setValue:is_ready forKey:@"is_ready"];
        
        
        NSMutableDictionary *dataParameter = [[NSMutableDictionary alloc]init];
        [dataParameter setValue:methodParameter forKey:@"Data"];
        
        NSMutableDictionary *pageParameter = [[NSMutableDictionary alloc]init];
        [pageParameter setValue:dataParameter forKey:@"param"];
        [pageParameter setValue:@"AddStudentStopTime" forKey:@"method"];
        
        [HttpTool postWithparams:pageParameter success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateHistoryInfo" object:self userInfo:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    
    
}

#pragma mark - 点击事件

-(void)backBtnClick{
    [self getStopTimeWithCurrentTime:self.currentTime];
    self.lessonId=nil;
    [self.videoManager stop];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate changeToLearn];
    self.lessonId = nil;
    
}


-(void)videoLoadDone:(NSNotification *)noti{
    
    //    [self.indicatorShowView removeFromSuperview];
    [self.videoManager moveToSecond:self.beginTime];
    studyTime = [self getSystemTime];
    self.slider.value = self.beginTime;
    [self.videoManager startWithHandler:^(NSTimeInterval elapsedTime, NSTimeInterval timeRemaining, NSTimeInterval playableDuration, BOOL finished) {
        [self showCurrentTime:elapsedTime];
        self.currentTime = elapsedTime;
        nowTimel = timeRemaining;
        self.nowPointString = [self.rightView.pointView getCurrentSubTitle:elapsedTime];
        if (self.rightView.pointView) {
            [self.rightView.pointView changeSubTitleViewWithTime:elapsedTime];
        }
        [self.rightView.tagList changeBtnLookingWithTime:elapsedTime];
        [self.nowPoint setTitle:self.nowPointString forState:UIControlStateNormal];
        
        self.slider.value = self.currentTime;
        
        
    }];
    if (!shouldPlaying) {
        [self.videoManager pause];
    }else{
        [self.videoManager resume];
    }
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(0 , self.startBtnView.height-60, self.startBtnView.width, 50)];
    }
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0;
    _slider.maximumValue = [noti.object floatValue];
    [self.startBtnView addSubview:_slider];
    [self.nowCourse setText:self.videoInfo.les_name];
    [self setIsDownloadLabelText];
    
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
    
    
    [self getStopTimeWithCurrentTime:self.currentTime];
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
    writeNoteTime = [self getSystemTime];
    
    
}

-(void)writeCodeBtnClick{
    
    self.startBtnView.hidden = YES;
    [self transformRecover];
    writeCodeTime = [self getSystemTime];
    
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
            //            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前时间已存在节点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            
            
            
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


-(void)downloadVideo{
    NSString *les_name = self.videoInfo.les_name;
    NSString *les_url = self.videoInfo.les_url;
    NSString *les_size = self.videoInfo.les_size;
    NSString *lessonID = self.lessonId;
    NSLog(@"%@,%@,%@,%@",les_name,les_url,les_size,lessonID);
    //从播放界面下载视频。
    __block BOOL isExist;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByID:lessonID successHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            if ([noteArr count] < 1) {
                isExist=NO;
            }else{
                isExist=YES;
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    //    LocalDatabase *db = [LocalDatabase sharedManager];
    if(!isExist){
        //    [db insertRecordIntoTableName:@"DOWNLOADINFO" withField1:@"LESSON_ID" field1Value:lessonID andField2:@"LESSON_NAME" field2Value:les_name andField3:@"LESSON_URL" field3Value:les_url andField4:@"LESSON_SIZE" field4Value:les_size andField5:@"LESSON_DOWNLOADING" field5Value:@"NO" andField6:@"FINISHED" field6Value:@"NO"];
        //        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"已成功加入下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
        //        }];
        SCDownlodaMode *mode=[[SCDownlodaMode alloc]init];
        mode.les_id=lessonID;
        mode.les_name=les_name;
        mode.les_url=les_url;
        mode.les_size=les_size;
        mode.les_downloading=@"NO";
        mode.finished=@"NO";
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
            [self.db saveOne:mode successHandler:^(id result) {
                
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"成功添加到下载列表" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
        }];
    }else{
        //        [UIAlertController showAlertAtViewController:self withMessage:@"该进程在下载列表中已存在" cancelTitle:@"" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
        //        } confirmHandler:^(UIAlertAction *action) {
        //        }];
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"该进程在下载列表中已存在" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
        }];
    }
}

-(void)tapToRemove:(UITapGestureRecognizer *)recognizer{
    
    [self.hubView removeFromSuperview];
    [self.videoManager resume];
    [self.bottomView addSubview:self.pauseBtn];
    [self.playBtn removeFromSuperview];
    
    leftTopPoint = CGPointMake(0, 0);
    [self.sureToCut removeFromSuperview];
    [self.chooseViewAgain removeFromSuperview];
}


- (void)tapBtn:(UITapGestureRecognizer *) recognizer{
    
    if (!isAnimating) {
        BOOL _hidden;
        _hidden = self.startBtnView.hidden;
        
        if ([self.pauseBtn isDescendantOfView:self.bottomView]) {
            self.startBtnView.hidden = NO;
            [self transformAnimated];
            [self.videoManager pause];
            [self getStopTimeWithCurrentTime:self.currentTime];
            shouldPlaying = NO;
            [self.bottomView addSubview:self.playBtn];
            [self.pauseBtn removeFromSuperview];
            
        }else{
            shouldPlaying = YES;
            if (_hidden) {
                [self.videoManager resume];
                [self.bottomView addSubview:self.pauseBtn];
                [self.playBtn removeFromSuperview];
                if (writeCodeTime != 0) {
                    writeCodeTime = [self getSystemTime] - writeCodeTime;
                    [self.writeCodeTimeArr addObject:@(writeCodeTime)];
                } else if (writeNoteTime != 0){
                    writeNoteTime = [self getSystemTime] - writeNoteTime;
                    [self.writeNoteTimeArr addObject:@(writeNoteTime)];
                    
                }
                writeCodeTime = 0;
                writeNoteTime = 0;
                
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

-(void)setTime:(UIPanGestureRecognizer *)recognizer{
    CGPoint statePoint = [recognizer translationInView:self.container];
    CGFloat endStateY;
    CGPoint endStatePoint = [recognizer locationInView:self.container];
    endStateY = endStatePoint.y;
    CGFloat moveDistance = statePoint.x;
    if (endStateY >= 0 && endStateY < self.container.height/3) {
        CGFloat turnToSecond = self.currentTime+720*moveDistance/self.container.width ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }else if (endStateY >= self.container.height/3 && endStateY < self.container.height*2/3){
        CGFloat turnToSecond = self.currentTime+(180*moveDistance/self.container.width) ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }else if (endStateY >= self.container.height*2/3 && endStateY < self.container.height){
        CGFloat turnToSecond = self.currentTime+60*moveDistance/self.container.width ;
        [self.videoManager moveToSecond:turnToSecond];
        self.slider.value = turnToSecond;
    }
    
}

-(void)setVoiceAndLight:(UIPanGestureRecognizer *)recognizer{
    CGPoint beginPoint;
    CGPoint point = [recognizer locationInView:self.container];
    if (beginPoint.y < 1) {
        beginPoint = point;
    }
    CGFloat halfScreenWidth =[UIScreen mainScreen].bounds.size.width/3;
    CGFloat thirdScreenWidth =2*[UIScreen mainScreen].bounds.size.width/3;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height*10;
    CGPoint panPoint = [recognizer translationInView:self.container];
    CGFloat panDistance = panPoint.y;
    if (beginPoint.x<halfScreenWidth) {
        CGFloat voiceVolume = -panDistance/screenHeight;
        [self.videoManager setVoice:voiceVolume];
    }else if (beginPoint.x>thirdScreenWidth){
        CGFloat light = -panDistance/screenHeight;
        [self setLight:light];
    }
}

-(void)setLight:(CGFloat )light{
    CGFloat brightness =  [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness:brightness+light];
}

-(void)panToTime:(UIPanGestureRecognizer*) recognizer{
    
    CGPoint statePoint = [recognizer translationInView:self.container];
    if (fabs(statePoint.x)  > fabs(statePoint.y)*9 ) {
        [self setTime:recognizer];
    }else if ((fabs(statePoint.y)  > fabs(statePoint.x)*9 )){
        [self setVoiceAndLight:recognizer];
    }
}


-(void)cutBtnClick{
    
    UIImage *thumbImage=[self.videoManager.player thumbnailImageAtTime:self.currentTime timeOption:MPMovieTimeOptionNearestKeyFrame];
    [_cutScreenImageArr addObject:thumbImage];
    UIImageWriteToSavedPhotosAlbum(thumbImage,self, nil, nil);
    //    if (showView == nil) {
    //        CGFloat width = self.container.width/2;
    //        CGFloat height = self.container.height/2;
    //        showView = [[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-width)/2, ([UIScreen mainScreen].bounds.size.height-height)/2, width, height)];
    //        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)   ];
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [btn setBackgroundColor:[UIColor clearColor]];
    //        [btn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    //        [btn setFrame:imageView.frame];
    //        [showView addSubview:btn];
    //        [imageView setImage:thumbImage];
    //        [showView addSubview:imageView];
    //        [self.container addSubview:showView];
    //    }
    CGFloat x =self.cutBtn.x-self.cutBtn.width-600*WidthScale;
    CGFloat y =self.cutBtn.y;
    CGFloat width = 500*WidthScale;
    CGFloat height = self.cutBtn.height;
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    sureLabel.text = @"截屏已保存到本地相册！";
    sureLabel.font = [UIFont systemFontOfSize:40*WidthScale];
    sureLabel.textColor = UIThemeColor;
    sureLabel.textAlignment = NSTextAlignmentCenter;
    sureLabel.alpha = 0;
    UIView *whiteView = [[UIView alloc]initWithFrame:self.view.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    //    whiteView.alpha = 0;
    [UIView animateWithDuration:0 animations:^{
        //        WQPlaySound *sound = [[WQPlaySound alloc]initForPlayingSystemSoundEffectWith:@"Tock" ofType:@"aif"];
        //        [sound play];
        sureLabel.alpha = 1;
        [self.view addSubview:whiteView];
        [self.bottomView addSubview:sureLabel];
        whiteView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [whiteView removeFromSuperview];
        }];
        [UIView animateWithDuration:4 animations:^{
            sureLabel.alpha = 0;
            
        } completion:^(BOOL finished) {
            [sureLabel removeFromSuperview];
            
        }];
    }];
}

-(void)closeView:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
    showView = nil;
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
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(333*WidthScale, 526*HeightScale, 1300*WidthScale, 160*HeightScale);
        imageView.image = [UIImage imageNamed:@"圆角输入框备注带阴影"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_writeNoteView addSubview:imageView];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"添加备注带阴影"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(1613*WidthScale , 526*HeightScale, 160*WidthScale, 160*HeightScale);
        [btn addTarget:self action:@selector(addPoint) forControlEvents:UIControlEventTouchUpInside];
        
        [_writeNoteView addSubview:btn];
        [_writeNoteView addSubview:self.textField];
        _writeNoteView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeWriteNoteView)];
        [_writeNoteView addGestureRecognizer:tap];
        
        
    }
    return _writeNoteView;
}

-(UITextField *)textField{
    
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(413*WidthScale ,547*HeightScale ,1140*WidthScale, 100*HeightScale)];
        _textField.placeholder = @"请添加节点，不超过20字";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        textField.keyboardType = UIKeyboardTypeDefault;
        _textField.secureTextEntry = NO;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = UIThemeColor;
        _textField.font = [UIFont systemFontOfSize:40*HeightScale];
        _textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(1580*WidthScale, 50*HeightScale, 100*WidthScale, 100*HeightScale)];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
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

-(UIButton *)downloadBtn{
    
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadBtn.frame = CGRectMake(1643*WidthScale, 38*HeightScale, 54*WidthScale, 44*HeightScale);
        [_downloadBtn addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchUpInside];
        [_downloadBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    }
    return _downloadBtn;
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



-(UIButton *)cutBtn{
    
    if (!_cutBtn) {
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cutBtn.frame = CGRectMake(1451*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
        [_cutBtn setImage:[UIImage imageNamed:@"截"] forState:UIControlStateNormal];
        [_cutBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _cutBtn.titleLabel.font = [UIFont systemFontOfSize:55*WidthScale];
        _cutBtn.backgroundColor = [UIColor clearColor];
        //        _cutBtn.backgroundColor = UIThemeColor;
        [_cutBtn addTarget:self action:@selector(cutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cutBtn;
}

//-(UIPanGestureRecognizer *)panToSetVoice{
//
//    if (!_panToSetVoice) {
//        _panToSetVoice = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToSetVoice:)];
//    }
//    return _panToSetVoice;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.textField resignFirstResponder];
    return YES;
}

-(UIView *)getTopViewWithTitle:(NSString *)title{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.49*SCREEN_WIDTH, 0.065*SCREEN_HEIGHT)];
    topView.backgroundColor = UIBackgroundColor;
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*WidthScale, 0, 0.49*SCREEN_WIDTH, 0.065*SCREEN_HEIGHT)];
    topLabel.text = title;
    topLabel.font = [UIFont systemFontOfSize:32*WidthScale];
    topLabel.textColor = [UIColor blackColor];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:topLabel];
    return topView;
}

-(UIView *)getPreKnowView{
    
    UIView *preKnowView = [[UIView alloc]initWithFrame:CGRectMake(30*WidthScale, 0.08*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT)];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.02*SCREEN_HEIGHT, 0.02*SCREEN_HEIGHT)];
    leftView.image = [UIImage imageNamed:@"小圆"];
    [preKnowView addSubview:leftView];
    UILabel *preKnowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*SCREEN_HEIGHT, 0, 0.47*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT)];
    preKnowLabel.text = [NSString stringWithFormat:@"本节已学习的知识点（请检查自己是否掌握）"];
    preKnowLabel.font = [UIFont systemFontOfSize:25*WidthScale];
    preKnowLabel.textColor = [UIColor grayColor];
    preKnowLabel.textAlignment = NSTextAlignmentLeft;
    [preKnowView addSubview:preKnowLabel];
    return preKnowView;
}

-(UIView *)getShareView{
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0.13*SCREEN_WIDTH, 0.28*SCREEN_HEIGHT, 0.29*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 0.02*SCREEN_HEIGHT, 0.02*SCREEN_HEIGHT);
    [leftBtn setImage:[UIImage imageNamed:@"选择灰色26"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"选择高亮26"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(chooseToShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:leftBtn];
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.03*SCREEN_HEIGHT, 0, 0.26*SCREEN_WIDTH, 0.02*SCREEN_HEIGHT)];
    shareLabel.text = [NSString stringWithFormat:@"太棒了！将我的学习成果分享给好友"];
    shareLabel.font = [UIFont systemFontOfSize:25*WidthScale];
    shareLabel.textColor = [UIColor grayColor];
    shareLabel.textAlignment = NSTextAlignmentLeft;
    [shareView addSubview:shareLabel];
    return shareView;
}

-(UIButton *)getRightTopBtn{
    
    UIButton *rightTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightTopBtn.frame = CGRectMake(0.45*SCREEN_WIDTH,  0.065*SCREEN_HEIGHT/4,  0.065*SCREEN_HEIGHT/2,  0.065*SCREEN_HEIGHT/2);
    [rightTopBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightTopBtn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    return rightTopBtn;
}

-(void)showShareView{
    
    [self.playerPlayFinishedView removeFromSuperview];
    [self.view addSubview:[self changeView]];
}

-(UIView *)changeView{
    
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0.255*SCREEN_WIDTH, 0.283*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH, 0.434*SCREEN_HEIGHT)];
    changeView.backgroundColor = [UIColor whiteColor];
    NSString *title = @"     分享到：";
    [changeView addSubview:[self getTopViewWithTitle:title]];
    [changeView addSubview:[self chooseToShare]];
    UIButton *bcBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [bcBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [bcBtn setFrame:CGRectMake(0.02*SCREEN_HEIGHT, 0.02*SCREEN_HEIGHT, 0.016*SCREEN_HEIGHT, 0.025*SCREEN_HEIGHT)];
    [bcBtn addTarget:self action:@selector(backToFinished:) forControlEvents:UIControlEventTouchUpInside];
    [changeView addSubview:bcBtn];
    return changeView;
}

-(UIView *)chooseToShare{
    
    UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.065*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH, 0.369*SCREEN_HEIGHT)];
    //    [chooseView setBackgroundColor:UIThemeColor];
    NSArray *arr = @[@"QQ",@"空间",@"微信好友",@"朋友圈"];
    NSArray *titleArr= @[@"QQ好友",@"QQ空间",@"微信好友",@"朋友圈"];
    for (int i=0; i<arr.count; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0.083*SCREEN_WIDTH+i*0.09*SCREEN_WIDTH, 0.110*SCREEN_HEIGHT, 0.059*SCREEN_WIDTH, 0.059*SCREEN_WIDTH);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [chooseView addSubview:btn];
        if (i==0) {
            [btn addTarget:self action:@selector(shareToQFriend) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){
            [btn addTarget:self action:@selector(shareToQZone) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==2){
            [btn addTarget:self action:@selector(shareToVFriend) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn addTarget:self action:@selector(shareToVZone) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.083*SCREEN_WIDTH+i*0.09*SCREEN_WIDTH, 0.211*SCREEN_HEIGHT, 0.059*SCREEN_WIDTH, 0.023*SCREEN_HEIGHT)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:0.019*SCREEN_HEIGHT];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        
        [chooseView addSubview:label];
    }
    
    return chooseView;
}



-(void)shareToQFriend{
    [self clickWithQQ];
    NSLog(@"shareToQFriend");
}

-(void)shareToQZone{
    [self clickWithQQ];
    NSLog(@"shareToQZone");
}

-(void)shareToVFriend{
    [self ShareToWXFriend];
    NSLog(@"shareToVFriend");
}

-(void)shareToVZone{
    [self Share];
    NSLog(@"shareToVZone");
}

-(UIView *)playerPlayFinishedView{
    
    if (!_playerPlayFinishedView) {
        _playerPlayFinishedView = [[UIView alloc]initWithFrame:CGRectMake(0.255*SCREEN_WIDTH, 0.283*SCREEN_HEIGHT, 0.49*SCREEN_WIDTH, 0.434*SCREEN_HEIGHT)];
        _playerPlayFinishedView.backgroundColor = [UIColor whiteColor];
        //        [_playerPlayFinishedView addSubview:[self getShareView]];
        NSString *title = @" 播放完成！";
        [_playerPlayFinishedView addSubview:_preLabel];
        [_playerPlayFinishedView addSubview:[self getPreKnowView]];
        [_playerPlayFinishedView addSubview:[self getTopViewWithTitle:title]];
        [_playerPlayFinishedView addSubview:[self getSureBtn]];
        [_playerPlayFinishedView addSubview:[self getRightTopBtn]];
    }
    return _playerPlayFinishedView;
}
-(UIButton *)getSureBtn{
    
    UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确     定" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(0.076*SCREEN_WIDTH, 0.33*SCREEN_HEIGHT, 0.35*SCREEN_WIDTH, 0.065*SCREEN_HEIGHT);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"btnn"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    
    return sureBtn;
}

-(void)backToRoot{
    isPlayFinished = YES;

    
    CGFloat time = 0;
    [_slider removeFromSuperview];
    [self getStopTimeWithCurrentTime:time];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //添加is_ready ＝ 是；
    
}

-(CGFloat)getSystemTime{
    
    NSDate* senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString* locationString=[dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString* morelocationString=[dateformatter stringFromDate:senddate];
    NSArray *array = [morelocationString componentsSeparatedByString:@"-"];
    CGFloat systemTime = 0;
    for (int i=0; i<array.count ; i++) {
        NSString *time = array[i];
        if (i==3) {
            systemTime = systemTime + [time floatValue] *3600;
        }else if (i==4){
            systemTime = systemTime + [time floatValue] *60;
        }else if (i==5){
            systemTime = systemTime + [time floatValue];
        }
    }
    return systemTime;
}

-(void)backToFinished:(UIButton *)sender{
    
    [sender.superview removeFromSuperview];
    [self.view addSubview:self.playerPlayFinishedView];
}

-(void)chooseToShare:(UIButton *)sender{
    
    if (sender.selected == YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

-(UIView *)playFinishedHubView{
    
    if (!_playFinishedHubView) {
        _playFinishedHubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _playFinishedHubView.backgroundColor = [UIColor blackColor];
        _playFinishedHubView.alpha = 0.3;
    }
    return _playFinishedHubView;
}





#pragma mark - 分享专题

- (void)Share {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = _shareString;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    } else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alView show];
    }
}
- (void)ShareToWXFriend {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = _shareString;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
        
    } else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你还没有安装微信,无法使用此功能" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alView show];
    }
}

#pragma mark 文字分享
- (void)sharedByWeChatWithText:(NSString *)WeChatMessage
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text  = WeChatMessage;
    req.bText = YES;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark 图片分享
- (void)sharedByWeChatWithImage:(NSString *)imageName
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:imageName]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    ext.imageData  = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:ext.imageData];
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = WXSceneTimeline;
    
    [WXApi sendReq:req];
}



- (void) sendTextContent
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"文本内容";
    req.bText = YES;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}
// 例子 分享图片到朋友圈
-(void)aaa{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}




-(void)onReq:(BaseReq *)req{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg   = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
        //[alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg   = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //[alert release];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg   = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //[alert release];
    }
    
}
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //[alert release];
    }
}







-(void)clickWithQQ{
    
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"QQ互联测试"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
    
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            //[msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

- (BOOL)onTencentReq:(TencentApiReq *)req
{
    return YES;
}

-(NSMutableArray *)writeNoteTimeArr{
    
    if (!_writeNoteTimeArr) {
        _writeNoteTimeArr = [[NSMutableArray alloc]init];
    }
    return _writeNoteTimeArr;
}
-(NSMutableArray *)writeCodeTimeArr{
    
    if (!_writeCodeTimeArr) {
        _writeCodeTimeArr = [[NSMutableArray alloc]init];
    }
    return _writeCodeTimeArr;
}

@end
