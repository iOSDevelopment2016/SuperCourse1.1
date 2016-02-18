//
//  SCSearchView.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCSearchView.h"
#import "SCCustomButton.h"
#import "SCCourse.h"
#import "SCCourseGroup.h"
#import "SCCourseCategory.h"
#import "SCSearchTableViewCell.h"
#import "AFNetworking.h"
#import "NSData+SZYKit.h"
#import "AFDownloadRequestOperation.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "SClesson_list.h"
#import "UIAlertController+SZYKit.h"
@interface SCSearchView ()<UITableViewDataSource, UITableViewDelegate,SCSearchTableViewDelegate>
@property (nonatomic ,strong) UITableView *firstSearchTableView;
@property (nonatomic ,strong) UITableView *secondSearchTableView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic,strong)UIView *scrollSearchView;
@property (nonatomic, strong)UIView *stateView;
@property (nonatomic,strong)UILabel *state;
@property (nonatomic, strong)UILabel *label;


@end
@implementation SCSearchView{
    NSMutableArray *firstLessonArr;
    NSMutableArray *secondLessonArr;
    NSMutableArray *currentSource;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    self.leftBtn.font=FONT_30;
    self.rightBtn.font=FONT_30;
    self.state.font=FONT_25;
    self.label.font=FONT_25;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self addSubview:self.firstSearchTableView];
        [self addSubview:self.scrollSearchView];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.stateView];
        [self addSubview:self.state];
        [self addSubview:self.label];
        [self addSubview:self.secondSearchTableView];
        [self addSubview:self.firstSearchTableView];
        
        currentSource  = [NSMutableArray array];
        //[self leftBtnClick];
        
    }
    return self;
}
       
-(void)layoutSubviews{
    [super layoutSubviews];
    self.firstSearchTableView.frame = CGRectMake(0, 200*HeightScale+7, self.width,810*HeightScale );
    self.secondSearchTableView.frame = CGRectMake(0, 200*HeightScale+7, self.width,810*HeightScale );
    self.scrollSearchView.frame = CGRectMake(0,100*HeightScale+7 , self.width, 100*HeightScale);
    self.scrollSearchView.backgroundColor= [UIColor whiteColor];
    self.firstSearchTableView.backgroundColor=[UIColor whiteColor];
    self.stateView.backgroundColor=[UIColor whiteColor];
    self.backgroundColor=UIBackgroundColor;
    self.leftBtn.frame=CGRectMake(0.312*self.width, 100*HeightScale+7 , 0.127*self.width, 100*HeightScale);
    self.rightBtn.frame=CGRectMake(0.562*self.width, 100*HeightScale+7 , 0.127*self.width, 100*HeightScale);
    self.stateView.frame = CGRectMake(0, 0, self.width, 100*HeightScale);
    self.state.frame= CGRectMake(0.631*self.width, 0, 0.351*self.width, 100*HeightScale);
    self.label.frame= CGRectMake(0.027*self.width, 0, 0.103*self.width, 100*HeightScale);
//         [self addSubview:self.firstSearchTableView];
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self loadCourseListFromNetwork];
}


-(void)loadCourseListFromNetwork{

    
    if ([self.keyWord isEqualToString:@""] || !self.keyWord) {
        return;
    }
    
    NSDictionary *para = @{@"method":@"Search",
                           @"param":@{@"Data":@{@"searchinfo":self.keyWord,@"stuid":ApplicationDelegate.userSession}}};

    [HttpTool postWithparams:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        firstLessonArr = [NSMutableArray array];
        secondLessonArr = [NSMutableArray array];
        
        NSError *error;
        for (NSDictionary *tempDict in dic[@"data"][@"SearchResult"][0][@"lesson_list"]) {
            SClesson_list *list =  [SClesson_list objectWithKeyValues:tempDict error:&error];
            [firstLessonArr addObject:list];
        }
        
        for (NSDictionary *tempDict in dic[@"data"][@"SearchResult"][1][@"lesson_list"]) {
            SClesson_list *list =  [SClesson_list objectWithKeyValues:tempDict];
            [secondLessonArr addObject:list];
        }
       
        [self leftBtnClick];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(UIView *)scrollSearchView{
    if(!_scrollSearchView){
        _scrollSearchView=[[UIView alloc]initWithFrame:CGRectMake(0, 100*HeightScale+7, self.width, 100*HeightScale)];
        _scrollSearchView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollSearchView;
}
-(UIView *)stateView{
    if(!_stateView){
        _stateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 100*HeightScale)];
        _stateView.backgroundColor = [UIColor whiteColor];
    }
    return _stateView;
}
-(UILabel *)state{
    if(! _state){
        _state=[[UILabel alloc]init];
        _state.font=[UIFont systemFontOfSize:25];
        _state.textColor=[UIColor grayColor];
//        SClesson_list *l =[[SClesson_list alloc]init];
          _state.adjustsFontSizeToFitWidth = YES;
//        if (!l.les_name) {
//            _state.text= [NSString stringWithFormat:@"搜索%@共找到0个视频课程",_keyWord];
//        }else{
//        _state.text=[NSString stringWithFormat:@"搜索%@共找到%lu个视频课程",_keyWord,(unsigned long)currentSource.count];
//        }
    }
    return _state;
}
-(UILabel *)label{
    if(! _label){
        _label=[[UILabel alloc]init];
        _label.font=[UIFont systemFontOfSize:25];
        _label.textColor=[UIColor grayColor];
        _label.text=@"搜索结果";
        _label.adjustsFontSizeToFitWidth = YES;
        
    }
    return _label;
}


-(UITableView *)firstSearchTableView{
    if(!_firstSearchTableView){
        _firstSearchTableView = [[UITableView alloc]init];
        _firstSearchTableView.delegate = self;
        _firstSearchTableView.dataSource = self;
        _firstSearchTableView.backgroundColor=[UIColor whiteColor];
        _firstSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return  _firstSearchTableView;
}
-(UITableView *)secondSearchTableView{
    if(!_secondSearchTableView){
        _secondSearchTableView = [[UITableView alloc]init];
        _secondSearchTableView.delegate = self;
        _secondSearchTableView.dataSource = self;
        _secondSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
    }
    return  _secondSearchTableView;
}
//每组中的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 0;
    return currentSource.count;
}

//返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    SCSearchTableViewCell *cell = (SCSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if(cell == nil){
        cell= [[[NSBundle mainBundle]loadNibNamed:@"SCSearchTableViewCell"owner:nil options:nil] firstObject];
        [cell.layer setBorderWidth:1];//设置边界的宽度
        [cell.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
        cell.delegate=self;
            SClesson_list *temp= currentSource[indexPath.row];
        [cell.searchBtn setTitle:temp.les_name forState:UIControlStateNormal];
        [cell.searchBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateHighlighted];
        cell.searchBtn.tag =indexPath.section * 1000 + indexPath.row;
    
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //[_leftBtn setBackgroundColor:[UIColor greenColor]];
        [_leftBtn setTitle:@"大纲" forState:UIControlStateNormal];
        [_leftBtn setFont:[UIFont systemFontOfSize:30]];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
     

    }
    
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"拓展" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setFont:[UIFont systemFontOfSize:30]];
        [_rightBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
        //[_rightBtn setFont:[UIFont systemFontOfSize:<#(CGFloat)#>]];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBtn;
}

//-(UIView *)scrollView{
//    if(!_scrollView){
//        _scrollView=[[UIView alloc]initWithFrame:CGRectMake(520*WidthScale, 780*HeightScale, 200*HeightScale, 9*HeightScale)];
//        [_scrollView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
//    }
//    return _scrollView;
//}


-(UIView *)leftView{
    if(_leftView){
        _leftView=[[UIView alloc]initWithFrame:CGRectMake(0.312*self.width, 670*HeightScale, 0.127*self.width, 9*HeightScale)];
        [_leftView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
    }
    return _leftView;
}
-(UIView *)rightView{
    if(_rightView){
        _rightView=[[UIView alloc]initWithFrame:CGRectMake(0.312*self.width, 670*HeightScale, 0.127*self.width, 9*HeightScale)];
        [_rightView setBackgroundColor:UIColorFromRGB(0x6fccdb)];
    }
    return _rightView;
    
}
# pragma mark - 私有方法
-(void)move:(CGFloat)x{
    if(x>0){
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollSearchView.transform=CGAffineTransformMakeTranslation(x,0);
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollSearchView.transform=CGAffineTransformIdentity;
        }];
        //self.scrollView.transform=CGAffineTransformIdentity;
    }
}
#pragma mark - 响应事件

-(void)leftBtnClick{
    self.leftBtn.selected=YES;
    self.rightBtn.selected=NO;
    currentSource = firstLessonArr;
    [self.firstSearchTableView reloadData];
    [self.leftBtn setTitleColor:UIColorFromRGB(0x6fccdb) forState:UIControlStateSelected];
    if (!currentSource || currentSource.count == 0) {
        _state.text= [NSString stringWithFormat:@"搜索“%@”共找到0个视频课程",_keyWord];
        
        
        
         //[str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    }else{
        _state.text=[NSString stringWithFormat:@"搜索“%@”共找到%lu个视频课程",_keyWord,(unsigned long)currentSource.count];
    }
}
-(void)rightBtnClick{
    self.leftBtn.selected=NO;
    self.rightBtn.selected=YES;
    currentSource = secondLessonArr;
    [self.firstSearchTableView reloadData];
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    if (!currentSource || currentSource.count == 0) {
        _state.text= [NSString stringWithFormat:@"搜索“%@”共找到0个视频课程",_keyWord];
    }else{
        _state.text=[NSString stringWithFormat:@"搜索“%@”共找到%lu个视频课程",_keyWord,(unsigned long)currentSource.count];
    }
}


//-(IBAction)searchBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex{
////    SCCourseGroup *courseGroup=self.firstSearchCategory.sec_arr[secIndex];
//    SClesson_list *selectedCourse = currentSource[rowIndex];
//    if ([selectedCourse.operations isEqualToString:@"视频"]) {
//        //NSString *urlvideo = selectedCourse.les_url;
//        [self.delegate videoPlayClickWithCourse:selectedCourse];
//    }else if ([selectedCourse.operations isEqualToString:@"网页"]) {
//        NSString *urlWeb=selectedCourse.les_url;
//        [self.delegate searchBtnClick:secIndex AndRowIndex:rowIndex AndUrl:urlWeb];
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *state = [ApplicationDelegate getNetWorkStates];
    if ([state isEqualToString:@"无网络"]) {
        [UIAlertController showAlertAtViewController:self.viewController withMessage:@"请检查您的网络" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            
        }];
    }
    else if ([state isEqualToString:@"wifi"]){
        SClesson_list *currentSearch = currentSource[indexPath.row];
        [self.delegate searchDidClick:currentSearch.les_id ];

    }
    else{
        [UIAlertController showAlertAtViewController:self.viewController withMessage:@"您正在使用3G/4G流量" cancelTitle:@"取消" confirmTitle:@"继续播放" cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            SClesson_list *currentSearch = currentSource[indexPath.row];
            [self.delegate searchDidClick:currentSearch.les_id ];
            
        }];
    }
//
//    SClesson_list *currentSearch = currentSource[indexPath.row];
//    [self.delegate searchDidClick:currentSearch.les_id ];
    
//    [self.delegate searchDidClick:currentSearch.les_id beginTime:currentSearch.bgsty_time];
}


@end
