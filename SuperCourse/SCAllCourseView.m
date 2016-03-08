//
//  SCAllCourseView.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCAllCourseView.h"
#import "SCCustomButton.h"
//#import "SCCourse.h"
//#import "SCCourseGroup.h"
//#import "SCCourseCategory.h"
#import "SCCourseTableViewCell.h"
#import "AFNetworking.h"
#import "NSData+SZYKit.h"
#import "AFDownloadRequestOperation.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "SCLoginView.h"
#import "HttpTool.h"
#import "SCCoursePlayLog.h"
//#import "LocalDatabase.h"
#import "UIImageView+WebCache.h"
#import "SZYNoteSolidater.h"
#import "SCDownlodaMode.h"
@interface SCAllCourseView ()<UITableViewDataSource, UITableViewDelegate,SCCourseTableViewDelegate,MBProgressHUDDelegate,SCLoginViewDelegate>

@property (weak, nonatomic  ) IBOutlet UITextField                *phone;
@property (weak, nonatomic  ) IBOutlet UITextField                *password;
@property (weak, nonatomic  ) IBOutlet UIButton                   *sendPsw;
@property (weak, nonatomic  ) IBOutlet UIButton                   *login;
@property (weak, nonatomic  ) IBOutlet UIButton                   *usertext;
@property (nonatomic ,strong) UIImageView                *topImageView;
@property (nonatomic ,strong) UIImageView                *headImageView;
@property (nonatomic ,strong) UIImageView                *characterImageView;
@property (nonatomic ,strong) UITableView                *firstTableView;
@property (nonatomic ,strong) UIButton                   *leftBtn;
@property (nonatomic ,strong) UIButton                   *rightBtn;
@property (nonatomic ,strong) UIView                     *scrollView;
@property (nonatomic ,strong) UIView                     *leftView;
@property (nonatomic ,strong) UIView                     *rightView;
@property (nonatomic, strong) SCCourseCategory           *firstCategory;
@property (nonatomic, strong) SCCourseCategory           *secondCategory;
@property (nonatomic, strong) SCCourseCategory           *currentSource;
@property (retain,nonatomic ) UIActivityIndicatorView    *activityIndicator;
@property (nonatomic ,strong) AFDownloadRequestOperation *fileDownloader;
@property (nonatomic ,strong) MBProgressHUD              *HUD;


@property (nonatomic ,strong) SCCoursePlayLog          *playLog;


@property (nonatomic ,strong) UIView        *headView;

@property (nonatomic, strong) SZYNoteSolidater          *db;

@end

@implementation SCAllCourseView{
    NSMutableArray *courseCategoryArr;
    CGRect  initFrame;
    CGFloat defaultViewHeight;
    CGPoint headImageCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self.db=[[SZYNoteSolidater alloc]init];
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headView];
        [_headView addSubview:self.topImageView];
        [_headView addSubview:self.startBtn];
        [_headView addSubview:self.characterImageView];
        [_headView addSubview:self.headImageView];
        [_headView addSubview:self.leftBtn];
        [_headView addSubview:self.rightBtn];
        [_headView addSubview:self.scrollView];
        [self.HUD show:YES];
        [self loadCourseListFromNetwork];
        //[self change];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imageShouldChange) name:@"ImageShouldChange" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(beDownload:)
                                                     name: @"beingDownload"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(beFinished:)
                                                     name: @"beingFinished"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(beDelete:)
                                                     name: @"beingDelete"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(BeDownloading:)
                                                     name: @"toBeDownload"
                                                   object: nil];

        
    }
    return self;
}


-(void)beDownload:(NSNotification *)message{
    NSDictionary *userInfo = [message userInfo];
    NSString *name = userInfo[@"name"];
    for(int i=0;i<20;i++){
        for(int j=0;j<20;j++){
            NSIndexPath *index =  [NSIndexPath indexPathForItem:j inSection:i];
            SCCourseTableViewCell *cell =  [self.firstTableView cellForRowAtIndexPath:index];
            NSLog(@"%@",cell.contentField.titleLabel.text);
            if([cell.contentField.titleLabel.text isEqualToString:name]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    SCCourseGroup *temp=self.currentSource.sec_arr[i];
                    SCCourse *temp_=temp.lesarr[j];
                    __block BOOL isDodownloading;
                    
                    
                    
                    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                        [self.db readOneByName:name successHandler:^(id result) {
                            NSArray *noteArr = (NSArray *)result;
                            if ([noteArr count] < 1) {
                                isDodownloading=NO;
                            }else{
                                isDodownloading=YES;
                            }
                        } failureHandler:^(NSString *errorMsg) {
                            NSLog(@"%@",errorMsg);
                        }];
                        
                    }];
                    
                    if(isDodownloading){
                        cell.beDownloadingLabel.text=@"当前下载";
                        temp_.downloading=@"YES";
                    }else{
                        cell.beDownloadingLabel.text=@"等待下载";
                        temp_.downloading=@"NO";
                    }
                    
                    
                    [self.firstTableView reloadData];
                    temp_.downloading=nil;
                });
                break;
            }
           
        }
    }
    
}
-(void)BeDownloading:(NSNotification *)message{
    NSDictionary *userInfo = [message userInfo];
    NSString *name = userInfo[@"name"];
    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            NSIndexPath *index =  [NSIndexPath indexPathForItem:j inSection:i];
            SCCourseTableViewCell *cell =  [self.firstTableView cellForRowAtIndexPath:index];
            NSLog(@"%@",cell.contentField.titleLabel.text);
            if([cell.contentField.titleLabel.text isEqualToString:name]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    SCCourseGroup *temp=self.currentSource.sec_arr[i];
                    SCCourse *temp_=temp.lesarr[j];
                    
                    
                        cell.beDownloadingLabel.text=@"当前下载";
                        temp_.downloading=@"YES";
                                        
                    
                    [self.firstTableView reloadData];
                    temp_.downloading=nil;
                });
                break;
            }
            
        }
    }
    
}

-(void)beFinished:(NSNotification *)message{
    NSDictionary *userInfo = [message userInfo];
    NSString *name = userInfo[@"name"];
    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            NSIndexPath *index =  [NSIndexPath indexPathForItem:j inSection:i];
            SCCourseTableViewCell *cell =  [self.firstTableView cellForRowAtIndexPath:index];
            NSLog(@"%@",cell.contentField.titleLabel.text);
            if([cell.contentField.titleLabel.text isEqualToString:name]){
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    SCCourseGroup *temp=self.currentSource.sec_arr[i];
                    SCCourse *temp_=temp.lesarr[j];
                    temp_.downloaded=@"YES";
                    [self.firstTableView reloadData];
                    temp_.downloaded=nil;
                });
                break;
            }
            
        }
    }
}
-(void)beDelete:(NSNotification *)message{
    NSDictionary *userInfo = [message userInfo];
    NSString *name = userInfo[@"name"];
    for(int i=0;i<20;i++){
        for(int j=0;j<20;j++){
            NSIndexPath *index =  [NSIndexPath indexPathForItem:j inSection:i];
            SCCourseTableViewCell *cell =  [self.firstTableView cellForRowAtIndexPath:index];
            NSLog(@"%@",cell.contentField.titleLabel.text);
            if([cell.contentField.titleLabel.text isEqualToString:name]){
                cell.downloadBtn.enabled=YES;
                
                [cell.downloadBtn setHidden:NO];
                [cell.beDownloadingLabel setHidden:YES];
                break;
            }
            
        }
    }
}


-(void)imageShouldChange{
    
    
    //    NSDictionary *para = @{@"method":@"GetStudentPlayLog",
    //                           @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession,
    //                                                @"stu_pwd":ApplicationDelegate.userPsw}}};
    //
    //    NSString *psw = ApplicationDelegate.userPsw;
    //    NSString *uid =ApplicationDelegate.userSession;
    //
    //    [HttpTool postWithparams:para success:^(id responseObject) {
    //
    //        NSData *data = [[NSData alloc] initWithData:responseObject];
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
    //        SCCoursePlayLog *playLog = [SCCoursePlayLog objectWithKeyValues:dic[@"data"]];
    //        NSLog(@"");
    //
    //
    //    } failure:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
    
}


-(void)changeImage{
    [self.startBtn setImage:[UIImage imageNamed:@"SC_continue"] forState:UIControlStateNormal];
}
-(void)changeImageBack{
    [self.startBtn setImage:[UIImage imageNamed:@"SC_start"] forState:UIControlStateNormal];
}


//从网络请求课程列表
-(void)loadCourseListFromNetwork{
    
    NSDictionary *para = @{@"method":@"VideoList",
                           @"param":@{@"Data":@{@"stuid":ApplicationDelegate.userSession}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        
        NSLog(@"%@",ApplicationDelegate.userSession);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WebDataHaveLoadDone" object:nil];
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        courseCategoryArr = [NSMutableArray array];
        for (NSDictionary *catDict in dic[@"data"][@"categoryArr"]) {
            SCCourseCategory *cat = [SCCourseCategory objectWithKeyValues:catDict];
            NSMutableArray *secArr = [[NSMutableArray alloc]init];
            for (NSDictionary *secDict in catDict[@"sec_arr"]) {
                [SCCourseGroup setupObjectClassInArray:^NSDictionary *{
                    return @{@"lesarr":@"SCCourse"};
                }];
                SCCourseGroup *sec = [SCCourseGroup objectWithKeyValues:secDict];
                [secArr addObject:sec ];
            }
            cat.sec_arr = secArr;
            [courseCategoryArr addObject:cat];
        }
        
        //        [SCCourseGroup setupObjectClassInArray:^NSDictionary *{
        //            return @{@"lesarr":@"SCCourse"};
        //        }];
        //        [SCCourseCategory setupObjectClassInArray:^NSDictionary *{
        //            return @{@"sec_arr":@"SCCourseGroup"};
        //        }];
        //        [SCCourseCategory setupObjectClassInArray:^NSDictionary *{
        //            return @{@"categoryArr":@"SCCourseCategory"};
        //        }];
        //        SCCourseCategoryList *categoryList = [SCCourseCategoryList objectWithKeyValues:dic[@"data"]];
        
        self.firstCategory=(SCCourseCategory *)(courseCategoryArr[0]);
        self.secondCategory=(SCCourseCategory *)(courseCategoryArr[1]);
        //        self.firstCategory=(SCCourseCategory *)(categoryList.categoryArr[0]);
        //        self.secondCategory=(SCCourseCategory *)(categoryList.categoryArr[1]);
        self.currentSource=self.firstCategory;
        
        [self addSubview:self.firstTableView];
        
        //[self.activityIndicator stopAnimating];               !!!!!!!!!停止加载动画
        //        NSLog(@"%@", first.course_catagory_title);
        //        NSLog(@"%@", first.course_category_id);
        //        NSLog(@"%@", first.sec_arr);
        //        for (int i = 0; i<first.sec_arr.count; i++) {
        //            SCCourseGroup *m = first.sec_arr[i];
        //            NSLog(@"%@",m.lessections_id);
        //            NSLog(@"%@",m.lessections_name);
        //            NSLog(@"%@",m.lesarr);
        //            for (int j = 0; j<m.lesarr.count; j++) {
        //                SCCourse *c = m.lesarr[j];
        //                NSLog(@"%@", c.les_id);
        //                NSLog(@"%@", c.les_name);
        //            }
        //        }
        //        NSLog(@"%@", first.sec_arr);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];

    self.leftBtn.selected = YES;
    self.headView.frame= CGRectMake(0, 0, self.width, 800*HeightScale);
    self.topImageView.frame = CGRectMake(0, 0, self.width, 670*HeightScale);
    self.startBtn.frame = CGRectMake((self.topImageView.width-225)/2, self.topImageView.height-100, 225, 60);
    self.headImageView.frame=CGRectMake(744*WidthScale,65*HeightScale, 158*WidthScale, 158*HeightScale);
    self.characterImageView.frame=CGRectMake(270*WidthScale,280*HeightScale, 1087*WidthScale, 138*HeightScale);
    self.leftBtn.frame=CGRectMake(0.312*self.width, 670*HeightScale, 0.127*self.width, 130*HeightScale);
    self.rightBtn.frame=CGRectMake(0.562*self.width, 670*HeightScale, 0.127*self.width, 130*HeightScale);
    self.firstTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    self.firstTableView.frame = CGRectMake(0, 800*HeightScale, self.width, 500*HeightScale);
    //self.secondTableView.frame = CGRectMake(0, 800*HeightScale, self.width, 500*HeightScale);
    
    [self setUPAnimation];
}

#pragma mark - 顶部动画

-(void)setUPAnimation{
    initFrame = _topImageView.frame;
    defaultViewHeight = initFrame.size.height;
    headImageCenter = CGPointMake(_headImageView.centerX, _headImageView.centerY);
    
    UIView *headerView = [[UIView alloc]initWithFrame:self.headView.frame];
    _firstTableView.tableHeaderView = headerView;
    
    [_firstTableView addSubview:self.headView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置header与tableview同宽
    CGRect f     = _topImageView.frame;
    f.size.width = _firstTableView.frame.size.width;
    _topImageView.frame  = f;
    
    CGFloat destinaOffset = 300;
    CGFloat offset = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
    CGFloat alph = 1;
    
    if (scrollView.contentOffset.y < 0){//从起始点向下拉
        
        initFrame.origin.x = - offset/2;
        initFrame.origin.y = - offset;
        initFrame.size.width = _firstTableView.frame.size.width+offset;
        initFrame.size.height = defaultViewHeight+offset;
        _topImageView.frame = initFrame;

        _headImageView.frame = CGRectMake(0, 0, 158*HeightScale+offset/5, 158*HeightScale+offset/5);
        _headImageView.center = CGPointMake(headImageCenter.x, headImageCenter.y);
        
    }
    else if (scrollView.contentOffset.y >= 0  && scrollView.contentOffset.y < destinaOffset){//从起始点向上拉
        
        alph = 1 - (-offset / 300.0f);
        _headImageView.alpha = alph;
        _characterImageView.alpha = alph;
    }
    else{//向上超过终点之后
        
    }
}

-(void)viewDidLayoutSubviews
{
    initFrame.size.width = _firstTableView.frame.size.width;
    _topImageView.frame = initFrame;
}

-(void)postDownload{
    [self.delegate poseDownloads];
}


-(void)change{
    
    NSString *stu_id = ApplicationDelegate.userSession;
    NSString *stu_pwd = ApplicationDelegate.userPsw;
    if([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession])
    {
        [self changeImageBack];
    }else{
        //[self changeImage];
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
            if(self.playLog.oversty_time){
                [self changeImage];
            }else{
                [self changeImageBack];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}


#pragma mark - delegate
//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
// {
//        UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
//         return cell.frame.size.height;
//}

-(IBAction)downloadClickWithWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
    //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //        NSString *docDir = [paths objectAtIndex:0];
    //   NSIndexPath *cellIndexpath=[[NSIndexPath alloc]init];
    
    //    cellIndexpath.section=secIndex;
    //    cellIndexpath.row=rowIndex;
    
    //LocalDatabase *db = [LocalDatabase sharedManager];
    
    if(!self.rightBtn.selected){
        SCCourseGroup *courseGroup=self.firstCategory.sec_arr[secIndex];
        SCCourse *selectedCourse = courseGroup.lesarr[rowIndex];
        [self.delegate postDownloadName:selectedCourse.les_name AndURL:selectedCourse.les_url AndSize:selectedCourse.les_size AndID:selectedCourse.les_id];
        
    }else{
        SCCourseGroup *courseGroup=self.secondCategory.sec_arr[secIndex];
        SCCourse *selectedCourse = courseGroup.lesarr[rowIndex];
        [self.delegate postDownloadName:selectedCourse.les_name AndURL:selectedCourse.les_url AndSize:selectedCourse.les_size AndID:selectedCourse.les_id];
    }
    
    // 检查是否正在下载
    
//        if([db findConfig:selectedCourse.les_id]==YES){
//            [self.delegate downloadingAlart];
//        }else{
//
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"sendDownloadCondition" object:self userInfo:@{@"name":selectedCourse.les_name,@"size":selectedCourse.les_size,@"url":selectedCourse.les_url,@"id":selectedCourse.les_id}];
//            
//        }
    
    
//    [UIAlertController showAlertAtViewController:self withMessage:@"您确定退出登录吗？" cancelTitle:@"取消" confirmTitle:@"注销" cancelHandler:^(UIAlertAction *action) {
//        
//    } confirmHandler:^(UIAlertAction *action) {
//        //退出登录
//        ApplicationDelegate.userSession=UnLoginUserSession;
//        
//        //ApplicationDelegate.userSession = ApplicationDelegat;
//        ApplicationDelegate.userPsw = nil;
//        ApplicationDelegate.userPhone =nil;
//        ApplicationDelegate.playLog=@"";
//        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
//        [defaultes removeObjectForKey:UserSessionKey];
//        [defaultes removeObjectForKey:UserPswKey];
//        [defaultes removeObjectForKey:UserPhoneKey];
//        [defaultes removeObjectForKey:PlayLogKey];
//        [defaultes synchronize];
//        
//        [self unlogin];
//    }];

}


-(IBAction)contendFieldDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
    SCCourseGroup *courseGroup=self.currentSource.sec_arr[secIndex];
    SCCourse *selectedCourse = courseGroup.lesarr[rowIndex];
    if ([selectedCourse.operations isEqualToString:@"视频"]) {
        //NSString *urlvideo = selectedCourse.les_url;
        [self.delegate videoPlayClickWithCourse:selectedCourse];
    }else if ([selectedCourse.operations isEqualToString:@"网页"]) {
        NSString *urlWeb=selectedCourse.les_url;
        [self.delegate contendClick:secIndex AndRowIndex:rowIndex AndUrl:urlWeb];
    }
}

-(IBAction)imageBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
    if(!self.rightBtn.selected){
        SCCourseGroup *courseGroup=self.firstCategory.sec_arr[secIndex];
        SCCourse *selectedCourse = courseGroup.lesarr[rowIndex];
        [self.delegate imageClickWithCoutse:selectedCourse];
        
    }else{
        SCCourseGroup *courseGroup=self.secondCategory.sec_arr[secIndex];
        SCCourse *selectedCourse = courseGroup.lesarr[rowIndex];
        [self.delegate imageClickWithCoutse:selectedCourse];
    }
    //NSString *url=selectedCourse.les_url;
    //[self.delegate imageClickWithCoutse:selectedCourse];
}


# pragma mark - 私有方法
-(void)move:(CGFloat)x{
    if(x>0){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.transform=CGAffineTransformMakeTranslation(x,0);
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.transform=CGAffineTransformIdentity;
        }];
        //self.scrollView.transform=CGAffineTransformIdentity;
    }
}


#pragma mark - 响应事件
-(void)startBtnClick{
    
    [self.delegate startBtnDidClick];
}



-(void)leftBtnClick{
    self.leftBtn.selected=YES;
    self.rightBtn.selected=NO;
    self.currentSource=self.firstCategory;
    [self.firstTableView reloadData];
    [self.leftBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
    [self move:-1];
    
}
-(void)rightBtnClick{
    self.leftBtn.selected=NO;
    //    self.rightBtn.selected=YES;
    self.currentSource=self.secondCategory;
    [self.firstTableView reloadData];
    CGFloat variety=self.rightBtn.frame.origin.x-self.scrollView.frame.origin.x;
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    if(self.rightBtn.selected!=YES){
        [self move:variety];
    }
    self.rightBtn.selected=YES;
}

#pragma mark - getters

-(UIImageView *)topImageView{
    if (!_topImageView){
        _topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SC_background"]];
        
        _topImageView.userInteractionEnabled = YES;
        _topImageView.clipsToBounds = YES;
    }
    return _topImageView;
}

-(SCCustomButton *)startBtn{
    if (!_startBtn){
        _startBtn = [SCCustomButton buttonWithType:UIButtonTypeCustom];
        //        if(ApplicationDelegate.playLog){
        //            [_startBtn setImage:[UIImage imageNamed:@"SC_continue"] forState:UIControlStateNormal];
        //        }else{
        [_startBtn setImage:[UIImage imageNamed:@"SC_start"] forState:UIControlStateNormal];
        //        }
        [_startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _startBtn;
}



//-(void)changeLearn{
//    if(ApplicationDelegate.playLog){
//        [_startBtn setImage:[UIImage imageNamed:@"SC_continue"] forState:UIControlStateNormal];
//    }else{
//        [_startBtn setImage:[UIImage imageNamed:@"SC_start"] forState:UIControlStateNormal];
//    }
//}


-(UIImageView *)headImageView{
    if(!_headImageView){
        
        _headImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iOS"]];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:@"http://101.200.73.189/SuperCourseServer/Images/AllCourseHeadImage.png"] placeholderImage:[UIImage imageNamed:@"iOS"]];
    }
    return _headImageView;
    
}
-(UIView *)headView{
    if(!_headView){
        _headView=[[UIView alloc]init];
        _headView.clipsToBounds = YES;
        _headView.clipsToBounds = NO;
        //        _headView.backgroundColor = [UIColor orangeColor];
    }
    return _headView;
}

-(UIImageView *)characterImageView{
    if(!_characterImageView){
        
        _characterImageView=[[UIImageView alloc]init];
        
        [_characterImageView sd_setImageWithURL:[NSURL URLWithString:@"http://101.200.73.189/SuperCourseServer/Images/AllCourseCharaImage.png"] placeholderImage:[UIImage imageNamed:@"SC_c"]];
        
    }
    
    return _characterImageView;
    
}

-(UITableView *)firstTableView{
    if(!_firstTableView){
        _firstTableView = [[UITableView alloc]init];
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return  _firstTableView;
}

//-(UITableView *)secondTableView{
//    if(!_secondTableView){
//        _secondTableView = [[UITableView alloc]init];
//        _secondTableView.dataSource = self;
//        _secondTableView.delegate = self;
//    }
//    return  _secondTableView;
//}
//



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // NSString *key = [keys objectAtIndex:section];
    
    
    // create the parent view that will hold header Label
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.width, 670*HeightScale)];
    
    customView.backgroundColor=UIColorFromRGB(0xeeeeee);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.opaque = NO;
    
    headerLabel.textColor = [UIColor blackColor];
    
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel.font = [UIFont italicSystemFontOfSize:45*HeightScale];
    
    headerLabel.frame = CGRectMake(40.0, 10.0, self.width, 44.0);
    
    SCCourseGroup *temp = self.currentSource.sec_arr[section];
    
    headerLabel.text = temp.lessections_name;
    
    
    [customView addSubview:headerLabel];
    
    
    return customView;
    
}









//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return 2;//返回标题数组中元素的个数来确定分区的个数
    return self.currentSource.sec_arr.count;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//    SCCourseGroup *temp = self.firstCategory.courseGroupArr[section];
//
//    return temp.courseGroupTitle;
//
//
//
//}



//调整标题宽度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 59;
}





//每组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 0;
    SCCourseGroup *temp = self.currentSource.sec_arr[section];
    return temp.lesarr.count;
}

//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    SCCourseTableViewCell;
    static NSString *CellIdentifier = @"Cell";
    SCCourseTableViewCell *cell = (SCCourseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SCCourseTableViewCell class]) owner:nil options:nil] lastObject];
        [cell.layer setBorderWidth:1];//设置边界的宽度
        [cell.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
        cell.delegate=self;
        SCCourseGroup *temp=self.currentSource.sec_arr[indexPath.section];
        SCCourse *temp_=temp.lesarr[indexPath.row];
        //cell.textLabel.text=temp_.courseTitle;
        [cell.contentField setTitle:temp_.les_name forState:UIControlStateNormal];
        [cell.contentField setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        cell.contentField.tag =indexPath.section * 1000 + indexPath.row;
        cell.imageBtn.tag =indexPath.section * 1000 + indexPath.row;
        cell.downloadBtn.tag =indexPath.section * 1000 + indexPath.row;
        if([temp_.operations isEqualToString:@"网页"]){
            cell.downloadBtn.hidden=YES;
        }
        [cell.beDownloadingLabel setHidden:YES];
        cell.beDownloadingLabel.textColor=UIColorFromRGB(0x6fccdb);
        cell.courseLabel.text=temp_.les_size;
        //        cell.courseLabel.font=FONT_18;
        //        cell.courseLabel.font=[UIFont systemFontOfSize:35*HeightScale];
        ////        if([temp_.permission isEqualToString:@"否"]){
        //
        //            cell.selected=NO;
        //        //}
        //LocalDatabase *db=[LocalDatabase sharedManager];
                if([temp_.downloaded isEqualToString:@"YES"]){
            cell.downloadBtn.enabled=NO;
            cell.beDownloadingLabel.text=@"下载完成";
            cell.beDownloadingLabel.font=FONT_25;
            [cell.downloadBtn setHidden:YES];
            [cell.beDownloadingLabel setHidden:NO];
            
        }else if([temp_.downloading isEqualToString:@"YES"]){
            cell.downloadBtn.enabled=NO;
            cell.beDownloadingLabel.text=@"当前下载";
            cell.beDownloadingLabel.font=FONT_25;
            [cell.downloadBtn setHidden:YES];
            [cell.beDownloadingLabel setHidden:NO];
        }else if([temp_.downloading isEqualToString:@"NO"]){
            cell.downloadBtn.enabled=NO;
            cell.beDownloadingLabel.text=@"等待下载";
            cell.beDownloadingLabel.font=FONT_25;
            [cell.downloadBtn setHidden:YES];
            [cell.beDownloadingLabel setHidden:NO];
        }else{
            __block BOOL isDodownloading;
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                [self.db readOneByID:temp_.les_id successHandler:^(id result) {
                    NSArray *noteArr = (NSArray *)result;
                    SCDownlodaMode *mode=[noteArr firstObject];
                    if([mode.les_downloading isEqualToString:@"YES"]){
                        isDodownloading=YES;
                    }else{
                        isDodownloading=NO;
                    }
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"%@",errorMsg);
                }];
                
            }];

            if(isDodownloading){
                cell.downloadBtn.enabled=NO;
                cell.beDownloadingLabel.text=@"当前下载";
                cell.beDownloadingLabel.font=FONT_25;
                [cell.downloadBtn setHidden:YES];
                [cell.beDownloadingLabel setHidden:NO];
            }else{
                __block BOOL isDodownloaded;
                [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                    [self.db readOneByID:temp_.les_id successHandler:^(id result) {
                        NSArray *noteArr = (NSArray *)result;
                        SCDownlodaMode *mode=[noteArr firstObject];
                        if([mode.finished isEqualToString:@"YES"]){
                            isDodownloaded=YES;
                        }else{
                            isDodownloaded=NO;
                        }
                    } failureHandler:^(NSString *errorMsg) {
                        NSLog(@"%@",errorMsg);
                    }];
                    
                }];

                if(isDodownloaded){
                    cell.downloadBtn.enabled=NO;
                    cell.beDownloadingLabel.text=@"下载完成";
                    cell.beDownloadingLabel.font=FONT_25;
                    [cell.downloadBtn setHidden:YES];
                    [cell.beDownloadingLabel setHidden:NO];
                    
                }else{
                    __block BOOL isExist;
                    
                    
                    
                    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                        [self.db readOneByID:temp_.les_id successHandler:^(id result) {
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
                    if(isExist)
                    {
                        cell.downloadBtn.enabled=NO;
                        cell.beDownloadingLabel.text=@"等待下载";
                        cell.beDownloadingLabel.font=FONT_25;
                        [cell.downloadBtn setHidden:YES];
                        [cell.beDownloadingLabel setHidden:NO];
                    }
                }
            }

        }
        
        
        
        cell.width=self.width;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}






//数据桩（调试程序用的假数据）
-(void)initData{
    //    self.firstCategory = [self getCourseCatagory:@"大纲"];
    //    self.secondCategory = [self getCourseCatagory2:@"拓展"];
    self.currentSource = self.firstCategory;
}

//
//-(SCCourseCategory *)getCourseCatagory2:(NSString *)title{
//    SCCourseCategory *temp = [[SCCourseCategory alloc]init];
//    temp.course_catagory_title = title;
//    temp.course_category_id = @"UUID";
//    SCCourseGroup *c1 = [self getCourseGroup:@"改变了"];
//    SCCourseGroup *c2 = [self getCourseGroup:@"第二分组"];
//    SCCourseGroup *c3 = [self getCourseGroup:@"第三分组"];
//    SCCourseGroup *c4 = [self getCourseGroup:@"第四分组"];
//    temp.sec_arr = @[c1,c2,c3,c4];
//    return temp;
//
//}
//
//
//
//-(SCCourseGroup *)getCourseGroup:(NSString *)title{
//    SCCourseGroup *temp = [[SCCourseGroup alloc]init];
//    temp.lessections_name = title;
//    temp.lessections_id = @"UUID";
//    SCCourse *c1 = [self getCourse:@"这是视频"];
//    SCCourse *c2 = [self getCourse:@"这是网页"];
//    SCCourse *c3 = [self getCourse:@"第3节课"];
//    SCCourse *c4 = [self getCourse:@"第4节课"];
//    SCCourse *c5 = [self getCourse:@"第5节课"];
//    SCCourse *c6 = [self getCourse:@"第6节课"];
//    temp.lesarr = @[c1,c2,c3,c4,c5,c6];
//    return temp;
//
//}
//-(SCCourseCategory *)getCourseCatagory:(NSString *)title{
//    SCCourseCategory *temp = [[SCCourseCategory alloc]init];
//    temp.course_catagory_title = title;
//    temp.course_category_id = @"UUID";
//    SCCourseGroup *c1 = [self getCourseGroup:@"第一分组"];
//    SCCourseGroup *c2 = [self getCourseGroup:@"第二分组"];
//    SCCourseGroup *c3 = [self getCourseGroup:@"第三分组"];
//    SCCourseGroup *c4 = [self getCourseGroup:@"第四分组"];
//    temp.sec_arr = @[c1,c2,c3,c4];
//    return temp;
//
//}

//生成一个课程信息
-(SCCourse *)getCourse:(NSString *)title{
    SCCourse *temp = [[SCCourse alloc]init];
    temp.les_name = title;
    temp.les_id = @"UUID";
    //temp.courseUrl = @"";
    //    temp.courseAbstract = @"描述";
    return temp;
}

-(UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //[_leftBtn setBackgroundColor:[UIColor greenColor]];
        [_leftBtn setTitle:@"大纲" forState:UIControlStateNormal];
        
        _leftBtn.titleLabel.font = FONT_35;
        
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        _leftBtn.backgroundColor = [UIColor orangeColor];
    }
    
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"拓展" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = FONT_35;
        //[_rightBtn setFont:[UIFont systemFontOfSize:35]];
        [_rightBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        //[_rightBtn setFont:[UIFont systemFontOfSize:<#(CGFloat)#>]];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBtn;
}

-(UIView *)scrollView{
    if(!_scrollView){
        _scrollView=[[UIView alloc]initWithFrame:CGRectMake(520*WidthScale, 780*HeightScale, 200*HeightScale, 9*HeightScale)];
        [_scrollView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
    }
    return _scrollView;
}


//-(UIView *)leftView{
//    if(!_leftView){
//        _leftView=[[UIView alloc]initWithFrame:CGRectMake(0.312*self.width, 670*HeightScale, 0.127*self.width, 9*HeightScale)];
//        [_leftView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
//    }
//    return _leftView;
//}
//-(UIView *)rightView{
//    if(!_rightView){
//        _rightView=[[UIView alloc]initWithFrame:CGRectMake(0.312*self.width, 670*HeightScale, 0.127*self.width, 9*HeightScale)];
//        [_rightView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
//    }
//    return _rightView;
//
//}
-(UIActivityIndicatorView *)activityIndicator{
    if(!_activityIndicator){
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 450, 100, 100)];
        
        /*
         指定指示器的类型
         一共有三种类型：
         UIActivityIndicatorViewStyleWhiteLarge   //大型白色指示器
         UIActivityIndicatorViewStyleWhite      //标准尺寸白色指示器
         UIActivityIndicatorViewStyleGray    //灰色指示器，用于白色背景
         */
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        //停止后是否隐藏(默认为YES)
        self.activityIndicator.hidesWhenStopped = YES;
        
        
        
    }
    return _activityIndicator;
}

-(NSString *)getNextLessonID:(NSString *)currentLessonID{
    NSString *nextLessonID = currentLessonID;
    NSMutableArray *lessonArr = [[NSMutableArray alloc]init];
    for (SCCourseCategory *category in courseCategoryArr) {
        for (SCCourseGroup *group in category.sec_arr) {
            for (SCCourse *lesson in group.lesarr) {
                [lessonArr addObject:lesson];
            }
        }
    }
    for (int i=0; i<lessonArr.count; i++) {
        SCCourse *lesson = lessonArr[i];
        if ([currentLessonID isEqualToString:lesson.les_id]) {
            if (i<lessonArr.count-1) {
                SCCourse *nextLesson = lessonArr[i+1];
                nextLessonID = nextLesson.les_id;
                break;
            }
        }
    }
    return nextLessonID;
}


@end




