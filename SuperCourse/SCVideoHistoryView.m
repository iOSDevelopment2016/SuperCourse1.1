//
//  SCVideoHistoryView.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCVideoHistoryView.h"
#import "SCCustomButton.h"
#import "SCCourse.h"
#import "SCCourseGroup.h"
#import "SCCourseCategory.h"
#import "SCHistoryTableViewCell.h"
#import "AFNetworking.h"
#import "NSData+SZYKit.h"
#import "AFDownloadRequestOperation.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "SCHistory.h"
#import "UIAlertController+SZYKit.h"
@interface SCVideoHistoryView ()<UITableViewDataSource, UITableViewDelegate,SCHistoryTableViewDelegate>
@property (nonatomic ,strong) UITableView *historyTableView;
@property (nonatomic ,strong) UIView             *hubView;
@property (nonatomic ,strong) UIWebView          *webView;
@property (nonatomic ,strong) SCHistory *historyData;
@property (nonatomic ,strong) NSMutableArray *historyArr;

@end


@implementation SCVideoHistoryView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self initData];
         self.backgroundColor = [UIColor whiteColor];
        _historyArr = [[NSMutableArray alloc]init];

//        [self addSubview:self.historyTableView];
        [self loadCourseListFromNetwork];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCourseListFromNetwork) name:@"UserDidLogin" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearHistory) name:@"UserDidLogout" object:nil];

    }
    return self;
}

-(void)clearHistory
{
    
    [self.historyTableView removeFromSuperview];
}


-(void)loadCourseListFromNetwork{
    
    NSString *stu_id = ApplicationDelegate.userSession;
//    NSString *stu_id = @"9720513e-6d0e-d0ef-0a7c-de862380c581";
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:stu_id forKey:@"stu_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary alloc]init];
    [secondDic setValue:firstDic forKey:@"Data"];
    
    NSMutableDictionary *thirdDic = [[NSMutableDictionary alloc]init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"History" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        [self setDataWithDic:dic];
        
        [self addSubview:self.historyTableView];
        [self.historyTableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setDataWithDic:(NSDictionary *)dict{

    NSMutableDictionary *dataDict = dict[@"data"];
    NSArray *historyInfoDict = dataDict[@"historyData"];
    NSMutableArray *historyArr = [[NSMutableArray alloc]init];
    for (int i=0; i<historyInfoDict.count; i++) {
        SCHistory *h = [[SCHistory alloc]init];
        NSDictionary *historyDict = historyInfoDict[i];
//        NSDictionary *historyDict = dict[@"0"];
        h.oversty_time = [historyDict[@"oversty_time"] floatValue];
        h.les_name = historyInfoDict[i][@"les_name"];
        [historyArr addObject:h];
        _historyArr[i] = historyArr[i];
    }

}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.historyTableView.frame = CGRectMake(0, 0, self.width, self.height);
    self.historyTableView.backgroundColor= [UIColor whiteColor];
//    [self loadCourseListFromNetwork];
}



-(UITableView *)historyTableView{
    if(!_historyTableView){
        _historyTableView = [[UITableView alloc]init];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return  _historyTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _historyArr.count;
}

//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    SCHistoryTableViewCell *cell = (SCHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){

        cell= [[[NSBundle mainBundle]loadNibNamed:@"SCHistoryTableViewCell"owner:nil options:nil] firstObject];
        [cell.layer setBorderWidth:1];//设置边界的宽度
        [cell.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
        cell.delegate=self;

        SCHistory *h=_historyArr[indexPath.row];
        //cell.textLabel.text=temp_.courseTitle;
        [cell.historyBtn setTitle:h.les_name forState:UIControlStateNormal];
        [cell.historyBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        cell.historyBtn.tag =indexPath.section * 1000 + indexPath.row;

        CGFloat currentTime = h.oversty_time;
        
        int hour = (int)(currentTime/3600);
        int minute = (int)(currentTime - hour*3600)/60;
        int second = (int)currentTime - hour*3600 - minute*60;
        NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
        if ([h.is_ready isEqualToString:@"是"]) {
            cell.state.text=@"已看完";
        }else{
            cell.state.text= [NSString stringWithString:time];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
//数据桩（调试程序用的假数据）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *state = [ApplicationDelegate getNetWorkStates];
    if ([state isEqualToString:@"无网络"]) {
        [UIAlertController showAlertAtViewController:self.viewController withMessage:@"请检查您的网络" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            
        }];
    }
    else if ([state isEqualToString:@"wifi"]){
        SCHistory *currentHis = _historyArr[indexPath.row];
        [self.delegate historyDidClick:currentHis.les_id];
    }
    else{
        [UIAlertController showAlertAtViewController:self.viewController withMessage:@"您正在使用3G/4G流量" cancelTitle:@"取消" confirmTitle:@"继续播放" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            SCHistory *currentHis = _historyArr[indexPath.row];
            [self.delegate historyDidClick:currentHis.les_id];

        }];
    }
}



@end
