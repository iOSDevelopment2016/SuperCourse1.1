//
//  SCDownloadConditionViewController.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/4.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCDownloadConditionViewController.h"
#import "SCDownloadTableViewCell.h"
#import "AFDownloadRequestOperation.h"
//#import "LocalDatabase.h"
#import "SCDownlodaMode.h"
#import "SCPlayerViewController.h"
#import "SZYNoteSolidater.h"
@interface SCDownloadConditionViewController ()<UITableViewDataSource, UITableViewDelegate,SCDownloadTableViewCellDelegate>

@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong)UITableView *downloadTableView;
@property (nonatomic, strong)AFDownloadRequestOperation *fileDownloader;
//@property (nonatomic, strong)SCDownlodaMode *data;
//@property (nonatomic, strong)UIView     *view;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)SZYNoteSolidater *db;

@end

@implementation SCDownloadConditionViewController{
    __block NSArray *datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor=UIColorFromRGB(0xeeeeee);;
    self.db=[[SZYNoteSolidater alloc]init];
    [self.view addSubview:self.backImageBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.downloadTableView];
    [self.view addSubview:self.label];
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readallBySuccessHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            datasource=noteArr;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    
    
    [self.downloadTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(getChange)
                                                 name: @"sendDownloadCondition"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(toRefresh)
                                                 name: @"getRefresh"
                                               object: nil];

    ApplicationDelegate.mark=@"YES";
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 移除所有观察者
}



-(void)getChange{
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readallBySuccessHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            datasource=noteArr;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    [self.downloadTableView reloadData];
}

-(void)toRefresh{
    [self toGetChange];
}

-(void)toGetChange{
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readallBySuccessHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            datasource=noteArr;
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadTableView reloadData];
    });
    
}


//- (void)toDownload:(NSNotification *)message{
//    NSDictionary *userInfo = [message userInfo];
//    NSString *name = userInfo[@"name"];
//    NSString *size = userInfo[@"size"];
//    NSString *url  = userInfo[@"url"];
//    NSString *courseId = userInfo[@"id"];
//    //执行下载功能
//    [self downloadWithUrl:url andName:name];
//    //插入数据库
//    LocalDatabase *db = [[LocalDatabase alloc]init];
//    [db openDB];
//    [db createTable];
////    [db insertRecordIntoTableName:@"PERSONINFO" withField1:@"id" field1Value:courseId andField2:@"name" field2Value:name andField3:@"url" field3Value:url andField4:@"size" field4Value:size];
//    datasource= [db getAllData];
////    [datasource addObject:data];      //是这么写么。。。。
//    [db closeDB];
//    [self.downloadTableView reloadData];
//}
//

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backImageBtn.frame=CGRectMake(40, 42, 20, 35);
    self.backBtn.frame=CGRectMake(40, 40, 190, 40);
    self.downloadTableView.frame = CGRectMake(0, 180*HeightScale, 2048*WidthScale, 1000*HeightScale);
    self.downloadTableView.backgroundColor=UIColorFromRGB(0xeeeeee);
    self.label.frame=CGRectMake(0, 0, 0.3*self.view.width, 0.2*self.view.height);
    self.label.center=self.view.center;
}
#pragma mark - click
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)downloadWithUrl:(NSString *)url andName:(NSString *)downloadName{
////    NSString *url=selectedCourse.les_url;
//    
//    //NSString *srlStr = @"http://www.shengcaibao.com/download/SCB/1.mp3";
//    //如果请求正文包含中文，需要处理
//    //    srlStr = [srlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/"];
//    NSString *name=[NSString stringWithFormat :@"%@.mp4",downloadName];
//    self.fileDownloader = [[AFDownloadRequestOperation alloc]initWithRequest:request fileIdentifier:name targetPath:filePath shouldResume:YES];
//    self.fileDownloader.shouldOverwrite = YES;
//    
//    [self.fileDownloader start];
//    
//    //下载进度
//    
//    
//    
//    
//    [self.fileDownloader setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
//        
//        CGFloat percent = (float)totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
//        NSLog(@"百分比:%.3f%% %ld  %lld  %lld  %lld", percent * 100, (long)bytesRead, totalBytesRead, totalBytesReadForFile, totalBytesExpectedToReadForFile);
//        NSString *time=[NSString stringWithFormat :@"%lf",percent];;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendTime" object:self userInfo:@{@"time":time}];
//        
//        
//    }];
//    
//    //结束
//    [self.fileDownloader setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"下载成功 %@", responseObject);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"下载失败 %@", error);
//        
//    }];
//
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // NSString *key = [keys objectAtIndex:section];
    
    
    // create the parent view that will hold header Label
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.view.width, 670*HeightScale)];
    
    customView.backgroundColor=[UIColor whiteColor];;
    
    UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel1.backgroundColor = [UIColor clearColor];
    
    headerLabel1.opaque = NO;
    
    headerLabel1.textColor = [UIColor blackColor];
    
    headerLabel1.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel1.font = [UIFont italicSystemFontOfSize:35*HeightScale];
    
    headerLabel1.frame = CGRectMake(160, 10.0, 300.0, 44.0);
    
    // SCCourseGroup *temp = self.currentSource.sec_arr[section];
    
    headerLabel1.text = @"视频";
    
    
    [customView addSubview:headerLabel1];
    UILabel *headerLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel2.backgroundColor = [UIColor clearColor];
    
    headerLabel2.opaque = NO;
    
    headerLabel2.textColor = [UIColor blackColor];
    
    headerLabel2.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel2.font = [UIFont italicSystemFontOfSize:35*HeightScale];
    
    headerLabel2.frame = CGRectMake(self.view.width-540, 10.0, 300.0, 44.0);
    
    // SCCourseGroup *temp = self.currentSource.sec_arr[section];
    
    headerLabel2.text = @"下载进度";
    
    
    [customView addSubview:headerLabel2];
    UILabel *headerLabel3 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel3.backgroundColor = [UIColor clearColor];
    
    headerLabel3.opaque = NO;
    
    headerLabel3.textColor = [UIColor blackColor];
    
    headerLabel3.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel3.font = [UIFont italicSystemFontOfSize:35*HeightScale];
    
    headerLabel3.frame = CGRectMake(self.view.width-270, 10.0, 300.0, 44.0);
    
    // SCCourseGroup *temp = self.currentSource.sec_arr[section];
    
    headerLabel3.text = @"视频大小";
    
    
    [customView addSubview:headerLabel3];
    UILabel *headerLabel4 = [[UILabel alloc] initWithFrame:CGRectZero];
    
    headerLabel4.backgroundColor = [UIColor clearColor];
    
    headerLabel4.opaque = NO;
    
    headerLabel4.textColor = [UIColor blackColor];
    
    headerLabel4.highlightedTextColor = [UIColor whiteColor];
    
    headerLabel4.font = [UIFont italicSystemFontOfSize:35*HeightScale];
    
    headerLabel4.frame = CGRectMake(self.view.width-100, 10.0, 300.0, 44.0);
    
    // SCCourseGroup *temp = self.currentSource.sec_arr[section];
    
    headerLabel4.text = @"操作";
    
    
    [customView addSubview:headerLabel4];
    
    
    return customView;
    
}
















//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    //return self.currentSource.sec_arr.count;
    
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
    //return 1;
    //SCCourseGroup *temp = self.currentSource.sec_arr[section];
    //return temp.lesarr.count;
    NSInteger count=datasource.count;
    if(count==0){
        [self.label setHidden:NO];
    }else{
        [self.label setHidden:YES];
    }
    return datasource.count;
}

//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    SCCourseTableViewCell;
    static NSString *CellIdentifier = @"Cell";
    SCDownloadTableViewCell *cell = (SCDownloadTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SCDownloadTableViewCell class]) owner:nil options:nil] lastObject];
        [cell.layer setBorderWidth:1];//设置边界的宽度
        [cell.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
        //cell.delegate=self;
        //SCCourseGroup *temp=self.currentSource.sec_arr[indexPath.section];
        //SCCourse *temp_=temp.lesarr[indexPath.row];
        //cell.textLabel.text=temp_.courseTitle;
        //        [cell.contentField setTitle:temp_.les_name forState:UIControlStateNormal];
        //        [cell.contentField setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        //        cell.contentField.tag =indexPath.section * 1000 + indexPath.row;
        //        cell.imageBtn.tag =indexPath.section * 1000 + indexPath.row;
        //
        //        if([temp_.operations isEqualToString:@"网页"]){
        //            cell.downloadBtn.hidden=YES;
        //        }
        //cell.courseLabel.text=temp_.les_size;
        cell.delegate=self;
        SCDownlodaMode *temp =datasource[indexPath.row];
        cell.playBtn.tag=indexPath.section * 1000 + indexPath.row;
        cell.deleteBtn.tag=indexPath.section * 1000 + indexPath.row;
        cell.pauseBtn.tag=indexPath.section * 1000 + indexPath.row;
        cell.deleteImageBtn.tag=indexPath.section * 1000 + indexPath.row;
        cell.playImageBtn.tag=indexPath.section * 1000 + indexPath.row;
        cell.videoSize.text=temp.les_size;
        cell.videoName.text=temp.les_name;
        if([temp.finished isEqualToString:@"NO"]){
            [cell.example2 setHidden:NO];
            [cell.completeLabel setHidden:YES];
            [cell.circle1 setHidden:YES];
            [cell.program setHidden:NO];
            //[cell.pauseBtn setHidden:YES];
//            LocalDatabase *db = [LocalDatabase sharedManager];
            if([temp.les_downloading isEqualToString:@"YES"]){
                cell.program.text=@"当前进度：";
                NSString *a=ApplicationDelegate.program;
                if([ApplicationDelegate.program isEqualToString:@""]){
                    [cell.pauseBtn setHidden:NO];
                    
                    [cell.pauseBtn setTitle:@"继续下载" forState:UIControlStateNormal];
                }else{
                    [cell.pauseBtn setHidden:NO];
                    
                    [cell.pauseBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
                }
                
                [cell.pauseBtn setTitleColor:UIThemeColor forState:UIControlStateNormal];
            }else{
                [cell.example2 setHidden:YES];
                [cell.pauseBtn setTitle:@"等待下载" forState:UIControlStateNormal];
                cell.program.text=@"";
            }
        }else{
            [cell.example2 setHidden:YES];
            [cell.completeLabel setHidden:NO];
            [cell.circle1 setHidden:NO];
            [cell.program setHidden:YES];
            [cell.pauseBtn setTitle:@"进度完成" forState:UIControlStateNormal];
            [cell.pauseBtn setTitleColor:UIThemeColor forState:UIControlStateNormal];
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}









#pragma mark - getters
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"下载管理" forState:UIControlStateNormal];
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

-(UITableView *)downloadTableView{
    if(!_downloadTableView){
        _downloadTableView = [[UITableView alloc]init];
        _downloadTableView.delegate = self;
        _downloadTableView.dataSource = self;
        _downloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//删除小黑条！！
        
    }
    return  _downloadTableView;
}

-(void)pause{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pause" object:self userInfo:@{}];
    sleep(0.5);
    ApplicationDelegate.program=@"";
}
-(void)continueToDownload{
    //这里实际上会重新建立一个新的链接执行剩余部分的下载
    //Content-Range会记录上次结束时状态
    //ApplicationDelegate.program=@"";
[[NSNotificationCenter defaultCenter]postNotificationName:@"continue" object:self userInfo:@{}];
    sleep(0.5);
    ApplicationDelegate.program=@"1";

    
}
-(IBAction)playClick:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
    SCDownlodaMode *temp =datasource[rowIndex];
    [self videoPlayClickWithCourse:temp];
    
}
-(IBAction)deleteClick:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
    [UIAlertController showAlertAtViewController:self withMessage:@"您确定要删除该文件吗？" cancelTitle:@"取消" confirmTitle:@"确定" cancelHandler:^(UIAlertAction *action) {
        
    } confirmHandler:^(UIAlertAction *action) {
        __block SCDownlodaMode *temp =datasource[rowIndex];
        
        __block SCDownlodaMode *mode =[[SCDownlodaMode alloc]init];
        
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
            [self.db readOneByID:temp.les_id successHandler:^(id result) {
                NSArray *noteArr = (NSArray *)result;
                mode=[noteArr firstObject];
            } failureHandler:^(NSString *errorMsg) {
                
            }];
        }];

        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beingDelete" object:self userInfo:@{@"name":mode.les_name}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteLesson" object:self userInfo:@{@"id":temp.les_id}];
        ApplicationDelegate.program=@"";
        
        if([mode.les_downloading isEqualToString:@"YES"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pause" object:self userInfo:@{}];
            //        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendDownloadCondition" object:self userInfo:@{}];
            //[self.navigationController popViewControllerAnimated:YES];
            
            //[self.view reloadInputViews];
            
        }
        
        
        [self getChange];
        NSString *name=[NSString stringWithFormat :@"%@.mp4",temp.les_name];
        NSFileManager* fileManager=[NSFileManager defaultManager];
        //    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/tmp/Incomplete/"]; 用哪个？
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:name];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (!blHave) {
            NSLog(@"no  have");
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/tmp/Incomplete/"];
            NSString *uniquePath2=[filePath stringByAppendingPathComponent:name];
            BOOL blHave2=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath2];
            if(!blHave2){
                //[self poseDownloads];
                return;
            }else {
                NSLog(@" have");
                BOOL blDele= [fileManager removeItemAtPath:uniquePath2 error:nil];
                if (blDele) {
                    NSLog(@"dele success");
                    
                }else {
                    NSLog(@"dele fail");
                }
                
            }
            return ;
        }else {
            NSLog(@" have");
            BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
            if (blDele) {
                NSLog(@"dele success");
                
                
                //            LocalDatabase *db = [[LocalDatabase alloc]init];
                //            [db openDB];
                //            [db deleteData:temp.les_id];
                //            [db closeDB];
                
                
            }else {
                NSLog(@"dele fail");
            }
            
        }

    
    
    }];
    }
-(void)poseDownloads{
    [UIAlertController showAlertAtViewController:self withMessage:@"暂无本地文件" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
    } confirmHandler:^(UIAlertAction *action) {
    }];
}


-(void)videoPlayClickWithCourse:(SCDownlodaMode *)temp{
    //        if([SCcourse.permission isEqualToString:@"是"])
    
    __block BOOL isDodownloaded;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByID:temp.les_id successHandler:^(id result) {
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
    if(!isDodownloaded){
        [UIAlertController showAlertAtViewController:self withMessage:@"未下载完成视频仍使用网络资源" cancelTitle:@"先不看了" confirmTitle:@"我要观看" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            
            if(![ApplicationDelegate.userSession isEqualToString:@"UnLoginUserSession"]){
                NSString *state = [ApplicationDelegate getNetWorkStates];
                if ([state isEqualToString:@"无网络"]) {
                    [UIAlertController showAlertAtViewController:self withMessage:@"请检查您的网络连接" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
                    } confirmHandler:^(UIAlertAction *action) {
                    }];
                }
                else if ([state isEqualToString:@"wifi"]){
                    
                    [self jumpToPlayerWithCourse:temp];
                    
                }else{
                    
                    [UIAlertController showAlertAtViewController:self withMessage:@"您当前正在使用3G/4G流量" cancelTitle:@"取消" confirmTitle:@"继续播放" cancelHandler:^(UIAlertAction *action) {
                        
                    } confirmHandler:^(UIAlertAction *action) {
                        [self jumpToPlayerWithCourse:temp];
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

            
            
        }];
    }else{
        if(![ApplicationDelegate.userSession isEqualToString:@"UnLoginUserSession"]){
            
            [self jumpToPlayerWithCourse:temp];               
            
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
    
    
    
    
    }

-(void)jumpToPlayerWithCourse:(SCDownlodaMode *)temp
{
    SCPlayerViewController *playVC = [[SCPlayerViewController alloc]init];
    //playVC.delegate=self;
    NSString *courseId = temp.les_id;
    playVC.lessonId = courseId;
    [self.navigationController pushViewController:playVC animated:YES];
}


-(UILabel *)label{
    if(!_label){
        _label=[[UILabel alloc]init];
        _label.text=@"暂无下载文件";
        _label.font=[UIFont systemFontOfSize:45];
        _label.textAlignment=UITextAlignmentCenter;
        _label.textColor=[UIColor lightGrayColor];
    }
    return _label;
}

@end
