//
//  SCDownloadConditionViewController.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/4.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCDownloadConditionViewController.h"
#import "SCDownloadTableViewCell.h"
@interface SCDownloadConditionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong)UITableView *downloadTableView;
@property (nonatomic, strong)UIView     *view;

@end

@implementation SCDownloadConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor=UIColorFromRGB(0xeeeeee);;
    [self.view addSubview:self.backImageBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.downloadTableView];

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backImageBtn.frame=CGRectMake(40, 22, 20, 35);
    self.backBtn.frame=CGRectMake(40, 20, 250, 40);
    self.downloadTableView.frame = CGRectMake(0, 180*HeightScale, 2000, 1000*HeightScale);
}
#pragma mark - click
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


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
    
    customView.backgroundColor=UIColorFromRGB(0xeeeeee);;
    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    
//    headerLabel.backgroundColor = [UIColor clearColor];
//    
//    headerLabel.opaque = NO;
//    
//    headerLabel.textColor = [UIColor blackColor];
//    
//    headerLabel.highlightedTextColor = [UIColor whiteColor];
//    
//    headerLabel.font = [UIFont italicSystemFontOfSize:35*HeightScale];
//    
//    headerLabel.frame = CGRectMake(40.0, 10.0, 300.0, 44.0);
//    
//    // SCCourseGroup *temp = self.currentSource.sec_arr[section];
//    
//    // headerLabel.text = temp.lessections_name;
//    
//    
//    [customView addSubview:headerLabel];
    
    
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
    return 1;
    //SCCourseGroup *temp = self.currentSource.sec_arr[section];
    //return temp.lesarr.count;
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
        cell.videoName.text=@"222222";
        cell.textColor=[UIColor redColor];
        
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



@end
