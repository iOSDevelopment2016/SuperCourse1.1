//
//  SCDownloader.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/18.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCDownloader.h"
#import "AFDownloadRequestOperation.h"
//#import "LocalDatabase.h"
#import "SCDownlodaMode.h"
#import "SZYNoteSolidater.h"


@interface SCDownloader ()
@property (nonatomic, strong)AFDownloadRequestOperation *fileDownloader;
@property (nonatomic, strong) NSString *program;
@property (nonatomic, strong)SZYNoteSolidater *db;
@end


@implementation SCDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        self.program=@"";

        [self addAllObserver];
        self.db=[[SZYNoteSolidater alloc]init];
        
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            // 在另一个线程中启动下载功能，加GCD控制
            [self startDownload];
        });
    }
    return self;
}

-(void)addAllObserver{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(toDownload:)
                                                 name: @"sendDownloadCondition"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(toDelete:)
                                                 name: @"deleteLesson"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pause)
                                                 name: @"pause"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(continueToDownload)
                                                 name: @"continue"
                                               object: nil];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 移除所有观察者
}


-(void)startDownload{
    BOOL exit = NO;

    while (!exit) {
        //LocalDatabase *db = [LocalDatabase sharedManager];
        
        __block BOOL isDodownloading;

        
        
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
            [self.db readOneByDownloading:@"YES" successHandler:^(id result) {
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
        
        // 检查是否正在下载
        if(isDodownloading==YES){
            
        }else{
        // 空闲，检查数据库中是否有需要启动的下载任务
                if([self hasTask]){
                    // 有，获得相关参数，启动下载任务
                    //NSString *value=@"YES";
                    __block SCDownlodaMode *mode;
                    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                        [self.db readOneByFinished:@"NO" successHandler:^(id result) {
                            NSArray *noteArr = (NSArray *)result;
                            mode=[noteArr firstObject];
                        } failureHandler:^(NSString *errorMsg) {
                            NSLog(@"%@",errorMsg);
                        }];
                        
                    }];
                    
                    //SCDownlodaMode *mode=[db getdownloadData];
                    mode.les_downloading=@"YES";
                    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                        [self.db updateDownloading:mode successHandler:^(id result) {
                            
                        } failureHandler:^(NSString *errorMsg) {
                            NSLog(@"%@",errorMsg);
                        }];
                        
                    }];
                    
                    //[db updateDownloading:mode.les_id];
                    //[db updateDBInfoValueWithKey:[mode.les_id UTF8String] value:[value UTF8String]];
                    
                    //[db updateTable];
                    [self downloadWithSCDownlodaMode:mode];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"getRefresh" object:self userInfo:@{}];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"toBeDownload" object:self userInfo:@{@"name":mode.les_name}];
//                    if([ApplicationDelegate.mark isEqualToString:@"YES"]){
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendDownloadCondition" object:self userInfo:@{}];
//                    }
                }
        
        }
        // 暂停一段时间
        
        sleep(1);
    }
}

-(BOOL)hasTask{
    __block BOOL exist = NO;
    // 打开数据
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByFinished:@"NO" successHandler:^(id result) {
            NSArray *noteArr = (NSArray *)result;
            if ([noteArr count] < 1) {
                exist=NO;
            }else{
                exist=YES;
            }
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
        
    }];
    //LocalDatabase *db = [LocalDatabase sharedManager];
    // 查询finished为否的数据，设置exist的值
//    if([db findToDownload]==YES){
//        
//
//        exist=YES;
//    }
    // 返回结果
    

    return exist;
}

- (void)toDownload:(NSNotification *)message{
    
    // 收到下载通知，获得下载参数（URL、名称……）
    // 将下载任务加入到本机数据库中
    
    NSDictionary *userInfo = [message userInfo];
    NSString *name = userInfo[@"name"];
    NSString *size = userInfo[@"size"];
    NSString *url  = userInfo[@"url"];
    NSString *courseId = userInfo[@"id"];
//    //执行下载功能
//    [self downloadWithUrl:url andName:name];
    //插入数据库
    SCDownlodaMode *mode=[[SCDownlodaMode alloc]init];
    mode.les_id=courseId;
    mode.les_name=name;
    mode.les_url=url;
    mode.les_size=size;
    mode.les_downloading=@"NO";
    mode.finished=@"NO";
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db saveOne:mode successHandler:^(id result) {
            
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];
//    LocalDatabase *db = [LocalDatabase sharedManager];
//    [db insertRecordIntoTableName:@"DOWNLOADINFO" withField1:@"LESSON_ID" field1Value:courseId andField2:@"LESSON_NAME" field2Value:name andField3:@"LESSON_URL" field3Value:url andField4:@"LESSON_SIZE" field4Value:size andField5:@"LESSON_DOWNLOADING" field5Value:@"NO" andField6:@"FINISHED" field6Value:@"NO"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"beingDownload" object:self userInfo:@{@"name":name}];
  //  datasource= [db getAllData];
    //    [datasource addObject:data];      //是这么写么。。。。
       // [self.downloadTableView reloadData];
    

    
    
}
-(void)toDelete:(NSNotification *)message{
    NSDictionary *userInfo = [message userInfo];
    NSString *user_id = userInfo[@"id"];
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db deleteOneByID:user_id successHandler:^(id result) {
            
        } failureHandler:^(NSString *errorMsg) {
            NSLog(@"%@",errorMsg);
        }];
    }];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"getRefresh" object:self userInfo:@{}];
    
}

-(void)downloadWithSCDownlodaMode:(SCDownlodaMode *)mode{
    //    NSString *url=selectedCourse.les_url;
    
    //NSString *srlStr = @"http://www.shengcaibao.com/download/SCB/1.mp3";
    //如果请求正文包含中文，需要处理
    //    srlStr = [srlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mode.les_url]];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/"];
    NSString *name=[NSString stringWithFormat :@"%@.mp4",mode.les_name];
    self.fileDownloader = [[AFDownloadRequestOperation alloc]initWithRequest:request fileIdentifier:name targetPath:filePath shouldResume:YES];
    self.fileDownloader.shouldOverwrite = YES;
    
    [self.fileDownloader start];
    
    //下载进度
    
    ApplicationDelegate.program=@"1";
    
    
    [self.fileDownloader setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        
        CGFloat percent = (float)totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
        NSLog(@"百分比:%.3f%% %ld  %lld  %lld  %lld", percent * 100, (long)bytesRead, totalBytesRead, totalBytesReadForFile, totalBytesExpectedToReadForFile);
        NSString *time=[NSString stringWithFormat :@"%lf",percent];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendTime" object:self userInfo:@{@"time":time}];
        self.program=time;
        ApplicationDelegate.pram=percent;
    }];
    
    //结束
    [self.fileDownloader setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"下载成功 %@", responseObject);
        mode.les_downloading=@"NO";
        mode.finished=@"YES";
//        LocalDatabase *db = [LocalDatabase sharedManager];
//        [db releaseDownloading:mode.les_id];
//        [db updateFinished:mode.les_id];
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
            [self.db updateDownloading:mode successHandler:^(id result) {
                
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];
        [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
            [self.db updateFinished:mode successHandler:^(id result) {
                
            } failureHandler:^(NSString *errorMsg) {
                NSLog(@"%@",errorMsg);
            }];
        }];

        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadFinished" object:self userInfo:@{@"les_ID":mode.les_id}];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"beingFinished" object:self userInfo:@{@"name":mode.les_name}];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getRefresh" object:self userInfo:@{}];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"下载失败 %@", error);
        
    }];
    
}
-(void)pause{
    [self.fileDownloader pause];
    NSLog(@"下载已暂停，点击resume重启下载");
}
-(void)continueToDownload{
    //这里实际上会重新建立一个新的链接执行剩余部分的下载
    //Content-Range会记录上次结束时状态
    __block BOOL isDodownloading;
    
    
    
    [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
        [self.db readOneByDownloading:@"YES" successHandler:^(id result) {
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
    
    //LocalDatabase *db = [LocalDatabase sharedManager];
    if(isDodownloading==YES){
        if([self.program isEqualToString:@""]){
            __block SCDownlodaMode *temp;
            [ApplicationDelegate.dbQueue inDatabase:^(FMDatabase *database) {
                [self.db readOneByDownloading:@"YES" successHandler:^(id result) {
                    NSArray *noteArr = (NSArray *)result;
                    temp=[noteArr firstObject];
                } failureHandler:^(NSString *errorMsg) {
                    NSLog(@"%@",errorMsg);
                }];
            }];

            [self downloadWithSCDownlodaMode:temp];
        }
    }
    [self.fileDownloader resume];
    NSLog(@"重启下载，点击pause暂停下载");
    
}


@end
