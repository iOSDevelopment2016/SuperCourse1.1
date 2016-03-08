//
//  SCReviseViewController.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/3/3.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCReviseViewController.h"

@interface SCReviseViewController ()<UITextFieldDelegate>


@property (nonatomic, strong)UITextField *reviewTextField;
@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong)UIView     *bottomView;
@property (nonatomic, strong)UIButton   *confirmBtn;
@property (nonatomic, strong)UIButton   *maleBtn;
@property (nonatomic, strong)UIButton   *femaleBtn;

@property (nonatomic, strong)UIImageView *maleImageView;
@property (nonatomic, strong)UIImageView *femaleImageView;

@end

@implementation SCReviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.backImageBtn];
    [self.femaleImageView setImage:[UIImage imageNamed:@"选择灰色"]];
    [self.maleImageView setImage:[UIImage imageNamed:@"选择灰色"]];


    if(self.tag!=2){
        [self.view addSubview:self.bottomView];
        [self.bottomView addSubview:self.reviewTextField];
        [self.view addSubview:self.confirmBtn];
    }else{
        [self.view addSubview:self.maleBtn];
        [self.view addSubview:self.femaleBtn];
        [self.view addSubview:self.femaleImageView];
        [self.view addSubview:self.maleImageView];
        if([self.infomation isEqualToString:@"男"]){
            [self.maleImageView setImage:[UIImage imageNamed:@"选择高亮"]];
            [self.femaleImageView setImage:[UIImage imageNamed:@"选择灰色"]];
        }else if([self.infomation isEqualToString:@"女"]){
            [self.femaleImageView setImage:[UIImage imageNamed:@"选择高亮"]];
            [self.maleImageView setImage:[UIImage imageNamed:@"选择灰色"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backImageBtn.frame=CGRectMake(40, 42, 20, 35);
    self.backBtn.frame=CGRectMake(30, 40, 160, 40);
    self.bottomView.frame=CGRectMake(0, 100, self.view.width, 50);
    self.reviewTextField.frame=CGRectMake(30, 0, 900, 50);
    self.confirmBtn.frame=CGRectMake(1024-120,40, 100, 40);
    self.maleBtn.frame=CGRectMake(0, 100, self.view.width, 50);
    self.femaleBtn.frame=CGRectMake(0, 153, self.view.width, 50);
    self.maleImageView.frame=CGRectMake(self.view.width-60, 110, 30, 30);
    self.femaleImageView.frame=CGRectMake(self.view.width-60, 163, 30, 30);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.reviewTextField resignFirstResponder];
    return YES;
}
-(UITextField *)reviewTextField{
    if(!_reviewTextField){
        _reviewTextField=[[UITextField alloc]init];
        
        [_reviewTextField setBackgroundColor:[UIColor whiteColor]];
        _reviewTextField.text = self.infomation;
        
        _reviewTextField.returnKeyType=UIReturnKeyDone;
        
        _reviewTextField.font = [UIFont systemFontOfSize:45*WidthScale];
        _reviewTextField.textAlignment=UITextAlignmentLeft;
        
        _reviewTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSString *a=self.placeHoder;
        _reviewTextField.placeholder=[NSString stringWithFormat:@"请输入%@",a];
        _reviewTextField.delegate=self;
    }
    return _reviewTextField;
}
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:self.placeHoder forState:UIControlStateNormal];
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
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)bottomView{
    if(!_bottomView){
        _bottomView=[[UIView alloc]init];
        //        _bottomView.layer.masksToBounds = YES;
        //        _bottomView.layer.cornerRadius = 50*WidthScale;
        _bottomView.backgroundColor=[UIColor whiteColor];
    }
    return _bottomView;
}
-(UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn=[[UIButton alloc]init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        _confirmBtn.layer.masksToBounds = YES;
        //        _confirmBtn.layer.cornerRadius = 26;
        //        _confirmBtn.backgroundColor=[UIColor redColor];
    }
    return _confirmBtn;
}
-(void)confirmClick{
    [self.delegate changeContent:self.reviewTextField.text AndTag:self.tag];
    [self.navigationController popViewControllerAnimated:YES];
    //[self postSuccessAlart];
}
-(void)postSuccessAlart{
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"信息修改成功！" confirmTitle:@"好的" confirmHandler:^(UIAlertAction *action) {
    }];
}

-(UIButton *)maleBtn{
    if(!_maleBtn){
        _maleBtn=[[UIButton alloc]init];
        _maleBtn.backgroundColor=[UIColor whiteColor];
        [_maleBtn setTitle:@"            男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_maleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_maleBtn setFont:[UIFont systemFontOfSize:23.5]];
        [_maleBtn addTarget:self action:@selector(maleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleBtn;
}
-(UIButton *)femaleBtn{
    if(!_femaleBtn){
        _femaleBtn=[[UIButton alloc]init];
        _femaleBtn.backgroundColor=[UIColor whiteColor];
        [_femaleBtn setTitle:@"            女" forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_femaleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_femaleBtn setFont:[UIFont systemFontOfSize:23.5]];
        [_femaleBtn addTarget:self action:@selector(femaleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femaleBtn;
}
-(void)maleBtnClick{
    [self.delegate changeContent:@"男" AndTag:self.tag];
    [self.navigationController popViewControllerAnimated:YES];
    //[self postSuccessAlart];
}
-(void)femaleBtnClick{
    [self.delegate changeContent:@"女" AndTag:self.tag];
    [self.navigationController popViewControllerAnimated:YES];
    //[self postSuccessAlart];
}
-(UIImageView *)maleImageView{
    if(!_maleImageView){
        _maleImageView=[[UIImageView alloc]init];
        //[_maleImageView setImage:[UIImage imageNamed:@"完成"]];
    }
    return _maleImageView;
}
-(UIImageView *)femaleImageView{
    if(!_femaleImageView){
        _femaleImageView=[[UIImageView alloc]init];
        //[_femaleImageView setImage:[UIImage imageNamed:@"完成"]];
    }
    return _femaleImageView;
}

@end
