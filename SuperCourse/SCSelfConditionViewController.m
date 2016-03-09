//
//  SCSelfConditionViewController.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/28.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCSelfConditionViewController.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "SCSelfConditionMode.h"
#import "AFNetworking.h"
#import "SCReviseViewController.h"

#define IOS8 ([[[UIDevice currentDevice] systemVersion]floatValue]>=8.0?YES:NO)
@interface SCSelfConditionViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,SCReviseViewDelegate>

@property (nonatomic, strong)UIButton   *backBtn;
@property (nonatomic, strong)UIButton   *backImageBtn;

@property (nonatomic, strong)UITextField *userName;//姓名
@property (nonatomic, strong)UITextField *userSex;//性别
@property (nonatomic, strong)UITextField *userSchool;//学校
@property (nonatomic, strong)UITextField *userDepartment;//院系
@property (nonatomic, strong)UITextField *userProfession;//专业
@property (nonatomic, strong)UITextField *userGrade;//年级
@property (nonatomic, strong)UITextField *userEmail;//邮箱
@property (nonatomic, strong)UIImageView *userImage;//用户头像

@property (nonatomic, strong)UILabel    *headLabel;

@property (nonatomic, strong)UILabel *userNameLabel;//姓名
@property (nonatomic, strong)UILabel *userSexLabel;//性别
@property (nonatomic, strong)UILabel *userSchoolLabel;//学校
@property (nonatomic, strong)UILabel *userDepartmentLabel;//院系
@property (nonatomic, strong)UILabel *userProfessionLabel;//专业
@property (nonatomic, strong)UILabel *userGradeLabel;//年级
@property (nonatomic, strong)UILabel *userEmailLabel;//邮箱
@property (nonatomic, strong)UILabel *userImageLabel;//用户头像
@property (nonatomic, strong)UIButton *confirmBtn;//确认BTN
@property (nonatomic, strong)SCSelfConditionMode *mode;

@property (nonatomic, strong)UIView *imageView;
@property (nonatomic, strong)UIView *nameView;
@property (nonatomic, strong)UIView *sexView;
@property (nonatomic, strong)UIView *emailView;
@property (nonatomic, strong)UIView *schoolView;
@property (nonatomic, strong)UIView *departmentView;
@property (nonatomic, strong)UIView *professionView;
@property (nonatomic, strong)UIView *gradeView;

@property (nonatomic, strong)UIButton *imageBtn;
@property (nonatomic, strong)UIButton *nameBtn;
@property (nonatomic, strong)UIButton *sexBtn;
@property (nonatomic, strong)UIButton *emainBtn;
@property (nonatomic, strong)UIButton *schoolBtn;
@property (nonatomic, strong)UIButton *departmentBtn;
@property (nonatomic, strong)UIButton *professionBtn;
@property (nonatomic, strong)UIButton *gradeBtn;

@property (nonatomic, strong)UIButton *getImage;




//@property (nonatomic, strong)ImagePickerViewController *pickImage;

@end

@implementation SCSelfConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str=[NSString stringWithFormat:@"%@.jpg",ApplicationDelegate.userSession];
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:str];
    UIImage *savedImage =[[UIImage alloc]initWithContentsOfFile:fullPath];
    if(savedImage==nil){
        NSString *url=[NSString stringWithFormat:@"http://101.200.73.189/SuperCourseServer/uploadimg/%@",str];
        savedImage=[self getImageFromURL:url];
    }
    
    [self.userImage setImage:savedImage];
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
    [self.view addSubview:self.backImageBtn];
    [self.view addSubview:self.backBtn];
    [self.nameView addSubview:self.userNameLabel];
    [self.nameView addSubview:self.userName];
    [self.sexView addSubview:self.userSexLabel];
    [self.sexView addSubview:self.userSex];
    [self.schoolView addSubview:self.userSchoolLabel];
    [self.schoolView addSubview:self.userSchool];
    [self.departmentView addSubview:self.userDepartmentLabel];
    [self.departmentView addSubview:self.userDepartment];
    [self.professionView addSubview:self.userProfessionLabel];
    [self.professionView addSubview:self.userProfession];
    [self.gradeView addSubview:self.userGradeLabel];
    [self.gradeView addSubview:self.userGrade];
    [self.emailView addSubview:self.userEmailLabel];
    [self.emailView addSubview:self.userEmail];
    [self.imageView addSubview:self.userImageLabel];
    [self.imageView addSubview:self.userImage];
    //[self.view addSubview:self.confirmBtn];
    
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.sexView];
    [self.view addSubview:self.emailView];
    [self.view addSubview:self.schoolView];
    [self.view addSubview:self.departmentView];
    [self.view addSubview:self.professionView];
    [self.view addSubview:self.gradeView];
    
    [self.imageView addSubview:self.imageBtn];
    [self.nameView addSubview:self.nameBtn];
    [self.sexView addSubview:self.sexBtn];
    [self.emailView addSubview:self.emainBtn];
    [self.schoolView addSubview:self.schoolBtn];
    [self.departmentView addSubview:self.departmentBtn];
    [self.professionView addSubview:self.professionBtn];
    [self.gradeView addSubview:self.gradeBtn];
    
    [self getData];
    
    //[self.view addSubview:self.getImage];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    
    
    return result;
    
}
-(void)getData{
    NSDictionary *para = @{@"method":@"SelectStudentBaseinfo",
                           @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.mode=[SCSelfConditionMode objectWithKeyValues:dic[@"data"]];
        self.userName.text=self.mode.stu_name;
        self.userSex.text=self.mode.stu_sex;
        self.userSchool.text=self.mode.stu_school;
        self.userDepartment.text=self.mode.stu_department;
        self.userProfession.text=self.mode.stu_profession;
        self.userGrade.text=self.mode.stu_grade;
        self.userEmail.text=self.mode.stu_email;
        //暂时未解决上传头像系列问题
        //[self.confirmBtn setTitle:@"修改信息" forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%f",self.view.height);
    self.backImageBtn.frame=CGRectMake(40, 42, 20, 35);
    self.backBtn.frame=CGRectMake(40, 40, 190, 40);
    self.userNameLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userName.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userSexLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userSex.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userSchoolLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userSchool.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userDepartmentLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userDepartment.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userProfessionLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userProfession.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userGradeLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userGrade.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userEmailLabel.frame=CGRectMake(0, 10, 100, 40);
    self.userEmail.frame=CGRectMake(1024-470, 10, 400, 40);
    self.userImageLabel.frame=CGRectMake(0, 20, 100, 40);
    self.userImage.frame=CGRectMake(1024-140, 10, 60, 60);
    self.confirmBtn.frame=CGRectMake(1024/2-350*WidthScale, 768-200*HeightScale, 700*WidthScale, 100*HeightScale);
    self.imageView.frame=CGRectMake(0, 100, 1024, 80);
    self.nameView.frame=CGRectMake(0, 182, 1024, 60);
    self.sexView.frame=CGRectMake(0, 244, 1024, 60);
    self.emailView.frame=CGRectMake(0, 306, 1024, 60);
    self.schoolView.frame=CGRectMake(0, 380, 1024, 60);
    self.departmentView.frame=CGRectMake(0, 442, 1024, 60);
    self.professionView.frame=CGRectMake(0, 504, 1024, 60);
    self.gradeView.frame=CGRectMake(0, 566, 1024, 60);
    
    self.imageBtn.frame=CGRectMake(1024-60, 20, 40, 40);
    self.nameBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.sexBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.emainBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.schoolBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.departmentBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.professionBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    self.gradeBtn.frame=CGRectMake(1024-60, 10, 40, 40);
    
    self.getImage.frame=CGRectMake(1024/2-350*WidthScale, 1024-200*HeightScale, 700*WidthScale, 100*HeightScale);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
#pragma mark - click
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)confirmClick{
    self.nameBtn.tag=0;
    self.sexBtn.tag=0;
    self.emainBtn.tag=0;
    self.schoolBtn.tag=0;
    self.departmentBtn.tag=0;
    self.professionBtn.tag=0;
    self.gradeBtn.tag=0;
    
    self.userName.enabled=NO;
    self.userSex.enabled=NO;
    self.userEmail.enabled=NO;
    self.userSchool.enabled=NO;
    self.userDepartment.enabled=NO;
    self.userProfession.enabled=NO;
    self.userGrade.enabled=NO;
    
    [self.userName resignFirstResponder];
    [self.userSex resignFirstResponder];
    [self.userEmail resignFirstResponder];
    [self.userSchool resignFirstResponder];
    [self.userDepartment resignFirstResponder];
    [self.userProfession resignFirstResponder];
    [self.userGrade resignFirstResponder];
    if(self.userEmail.text){
        NSDictionary *para = @{@"method":@"StudentBaseinfo",
                               @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession,@"stu_name":self.userName.text,@"stu_sex":self.userSex.text,@"stu_school":self.userSchool.text,@"stu_department":self.userDepartment.text,@"stu_profession":self.userDepartment.text,@"stu_grade":self.userGrade.text,@"stu_email":self.userEmail.text,@"stu_image":@""}}};
        [HttpTool postWithparams:para success:^(id responseObject) {
            //            NSData *data = [[NSData alloc] initWithData:responseObject];
            //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            //[self postSuccessAlart];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTitle" object:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        

    }else if([self isValidateEmail:self.userEmail.text]){
        NSDictionary *para = @{@"method":@"StudentBaseinfo",
                               @"param":@{@"Data":@{@"stu_id":ApplicationDelegate.userSession,@"stu_name":self.userName.text,@"stu_sex":self.userSex.text,@"stu_school":self.userSchool.text,@"stu_department":self.userDepartment.text,@"stu_profession":self.userDepartment.text,@"stu_grade":self.userGrade.text,@"stu_email":self.userEmail.text,@"stu_image":@""}}};
        [HttpTool postWithparams:para success:^(id responseObject) {
//            NSData *data = [[NSData alloc] initWithData:responseObject];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            //[self postSuccessAlart];
            
//            changeTitle
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTitle" object:nil];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
    }else{
        [self postAlart8];
        self.userEmail.text=@"";
        [self getData];
    }
    
    
}
-(void)postSuccessAlart{
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"信息修改成功！" confirmTitle:@"好的" confirmHandler:^(UIAlertAction *action) {
    }];
}
//-(void)postAlart{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入用户名称" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}
//-(void)postAlart2{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入性别" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}

//-(void)postAlart3{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入所在学校" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}
//
//-(void)postAlart4{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入所在院系" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}
//
//-(void)postAlart5{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入所学专业" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}
//
//-(void)postAlart6{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入所在年级" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}

//-(void)postAlart7{
//    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"请输入邮箱" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
//    }];
//}
-(void)postAlart8{
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"邮箱格式不正确" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}
-(void)postAlart9{
    [UIAlertController showAlertAtViewController:self title:@"提示" message:@"性别格式不正确" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
    }];
}



#pragma mark - getters

-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"个人中心" forState:UIControlStateNormal];
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
-(UITextField *)userName{
    if(!_userName){
        _userName=[[UITextField alloc]init];
        [_userName setBackgroundColor:[UIColor whiteColor]];
        _userName.placeholder = @"      请输入昵称";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userName.returnKeyType=UIReturnKeyDone;
        _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userName.font = [UIFont systemFontOfSize:45*WidthScale];
        _userName.delegate=self;
        _userName.enabled=NO;
        //        _searchTextField.layer.masksToBounds = YES;
        //        _searchTextField.layer.cornerRadius = 50*WidthScale;
        _userName.textAlignment = UITextAlignmentLeft;
//        _userName.rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 170*WidthScale, 150*HeightScale)];
//        _userName.rightView.backgroundColor=UIColorFromRGB(0x6fccdb);
//        _userName.rightViewMode=UITextFieldViewModeAlways;
////        UIButton *searchBtn=[[UIButton alloc]init];
//        [searchBtn setImage:[UIImage imageNamed:@"搜索白色"] forState:UIControlStateNormal];
//        searchBtn.frame=CGRectMake(45*WidthScale, 45*HeightScale, 64*WidthScale, 64*HeightScale);
//        [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_userName.rightView addSubview:searchBtn];
        //_searchTextField.delegate=self;
        _userName.textAlignment=UITextAlignmentRight;
        _userName.textColor=UIThemeColor;
    }
    return _userName;
}
-(UITextField *)userSex{
    if(!_userSex){
        _userSex=[[UITextField alloc]init];
        _userSex=[[UITextField alloc]init];
        [_userSex setBackgroundColor:[UIColor whiteColor]];
        _userSex.placeholder = @"      请输入性别";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userSex.returnKeyType=UIReturnKeyDone;
        _userSex.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userSex.font = [UIFont systemFontOfSize:45*WidthScale];
        _userSex.textAlignment=UITextAlignmentRight;
        _userSex.textColor=UIThemeColor;
        _userSex.enabled=NO;
        _userSex.delegate=self;
    }
    return _userSex;
}

-(UITextField *)userSchool{
    if(!_userSchool){
        
        _userSchool=[[UITextField alloc]init];
        [_userSchool setBackgroundColor:[UIColor whiteColor]];
        _userSchool.placeholder = @"      请输入学校";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userSchool.returnKeyType=UIReturnKeyDone;
        _userSchool.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userSchool.font = [UIFont systemFontOfSize:45*WidthScale];
        _userSchool.textAlignment=UITextAlignmentRight;
        _userSchool.textColor=UIThemeColor;
        _userSchool.enabled=NO;
        _userSchool.delegate=self;
    }
    return _userSchool;
}

-(UITextField *)userDepartment{
    if(!_userDepartment){
        _userDepartment=[[UITextField alloc]init];
        _userDepartment=[[UITextField alloc]init];
        [_userDepartment setBackgroundColor:[UIColor whiteColor]];
        _userDepartment.placeholder = @"      请输入院系";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userDepartment.returnKeyType=UIReturnKeyDone;
        _userDepartment.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userDepartment.font = [UIFont systemFontOfSize:45*WidthScale];
        _userDepartment.textAlignment=UITextAlignmentRight;
        _userDepartment.textColor=UIThemeColor;
        _userDepartment.delegate=self;
        _userDepartment.enabled=NO;
    }
    return _userDepartment;
}

-(UITextField *)userProfession{
    if(!_userProfession){
        _userProfession=[[UITextField alloc]init];
        _userProfession=[[UITextField alloc]init];
        [_userProfession setBackgroundColor:[UIColor whiteColor]];
        _userProfession.placeholder = @"      请输入专业";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userProfession.returnKeyType=UIReturnKeyDone;
        _userProfession.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userProfession.font = [UIFont systemFontOfSize:45*WidthScale];
        _userProfession.textAlignment=UITextAlignmentRight;
        _userProfession.textColor=UIThemeColor;
        _userProfession.delegate=self;
        _userProfession.enabled=NO;
    }
    return _userProfession;
}
-(UITextField *)userGrade{
    if(!_userGrade){
        _userGrade=[[UITextField alloc]init];
        _userGrade=[[UITextField alloc]init];
        [_userGrade setBackgroundColor:[UIColor whiteColor]];
        _userGrade.placeholder = @"      请输入年级";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userGrade.returnKeyType=UIReturnKeyDone;
        _userGrade.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userGrade.font = [UIFont systemFontOfSize:45*WidthScale];
        _userGrade.textAlignment=UITextAlignmentRight;
        _userGrade.textColor=UIThemeColor;
        _userGrade.delegate=self;
        _userGrade.enabled=NO;
    }
    return _userGrade;
}

-(UITextField *)userEmail{
    if(!_userEmail){
        _userEmail=[[UITextField alloc]init];
        _userEmail=[[UITextField alloc]init];
        [_userEmail setBackgroundColor:[UIColor whiteColor]];
        _userEmail.placeholder = @"      请输入邮箱";
        //_searchTextField.keyboardType=UIKeyboardAppearanceDefault;
        //_searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        //_searchTextField.secureTextEntry=YES;
        _userEmail.returnKeyType=UIReturnKeyDone;
        _userEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userEmail.font = [UIFont systemFontOfSize:45*WidthScale];
        _userEmail.textAlignment=UITextAlignmentRight;
        _userEmail.textColor=UIThemeColor;
        _userEmail.delegate=self;
        _userEmail.enabled=NO;
    }
    return _userEmail;
}
-(UIImageView *)userImage{
    if(!_userImage){
        _userImage=[[UIImageView alloc]init];

    }
    return _userImage;
}

-(UILabel *)headLabel{
    if(!_headLabel){
        _headLabel=[[UILabel alloc]init];
        _headLabel.text=@"您的个人信息";
        
    }
    return _headLabel;
}

-(UILabel *)userNameLabel{
    if(!_userNameLabel){
        _userNameLabel=[[UILabel alloc]init];
        _userNameLabel.text=@"昵称";
        _userNameLabel.font=[UIFont systemFontOfSize:23.5];
        _userNameLabel.textColor=[UIColor grayColor];
        _userNameLabel.textAlignment=UITextAlignmentRight;
    }
    return _userNameLabel;
}
-(UILabel *)userSexLabel{
    if(!_userSexLabel){
        _userSexLabel=[[UILabel alloc]init];
        _userSexLabel.text=@"性别";
        _userSexLabel.font=[UIFont systemFontOfSize:23.5];
        _userSexLabel.textColor=[UIColor grayColor];
        _userSexLabel.textAlignment=UITextAlignmentRight;
    }
    return _userSexLabel;
}
-(UILabel *)userSchoolLabel{
    if(!_userSchoolLabel){
        _userSchoolLabel=[[UILabel alloc]init];
        _userSchoolLabel.text=@"学校";
        _userSchoolLabel.font=[UIFont systemFontOfSize:23.5];
        _userSchoolLabel.textColor=[UIColor grayColor];
        _userSchoolLabel.textAlignment=UITextAlignmentRight;
    }
    return _userSchoolLabel;
}
-(UILabel *)userDepartmentLabel{
    if(!_userDepartmentLabel){
        _userDepartmentLabel=[[UILabel alloc]init];
        _userDepartmentLabel.text=@"院系";
        _userDepartmentLabel.font=[UIFont systemFontOfSize:23.5];
        _userDepartmentLabel.textColor=[UIColor grayColor];
        _userDepartmentLabel.textAlignment=UITextAlignmentRight;
    }
    return _userDepartmentLabel;
}
-(UILabel *)userProfessionLabel{
    if(!_userProfessionLabel){
        _userProfessionLabel=[[UILabel alloc]init];
        _userProfessionLabel.text=@"专业";
        _userProfessionLabel.font=[UIFont systemFontOfSize:23.5];
        _userProfessionLabel.textColor=[UIColor grayColor];
        _userProfessionLabel.textAlignment=UITextAlignmentRight;
    }
    return _userProfessionLabel;
}
-(UILabel *)userGradeLabel{
    if(!_userGradeLabel){
        _userGradeLabel=[[UILabel alloc]init];
        _userGradeLabel.text=@"年级";
        _userGradeLabel.font=[UIFont systemFontOfSize:23.5];
        _userGradeLabel.textColor=[UIColor grayColor];
        _userGradeLabel.textAlignment=UITextAlignmentRight;
    }
    return _userGradeLabel;
}

-(UILabel *)userEmailLabel{
    if(!_userEmailLabel){
        _userEmailLabel=[[UILabel alloc]init];
        _userEmailLabel.text=@"邮箱";
        _userEmailLabel.font=[UIFont systemFontOfSize:23.5];
        _userEmailLabel.textColor=[UIColor grayColor];
        _userEmailLabel.textAlignment=UITextAlignmentRight;
    }
    return _userEmailLabel;
}
-(UILabel *)userImageLabel{
    if(!_userImageLabel){
        _userImageLabel=[[UILabel alloc]init];
        _userImageLabel.text=@"头像";
        _userImageLabel.font=[UIFont systemFontOfSize:23.5];
        _userImageLabel.textColor=[UIColor grayColor];
        _userImageLabel.textAlignment=UITextAlignmentRight;
    }
    return _userImageLabel;
}

-(UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn=[[UIButton alloc]init];
        [_confirmBtn setTitle:@"上传头像" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(getImageClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 26;
        _confirmBtn.backgroundColor=[UIColor redColor];
    }
    return _confirmBtn;
}
-(UIView *)imageView{
    if(!_imageView){
        _imageView=[[UIView alloc]init];
        _imageView.backgroundColor=[UIColor whiteColor];
    }
    return _imageView;
}
-(UIView *)nameView{
    if(!_nameView){
        _nameView=[[UIView alloc]init];
        _nameView.backgroundColor=[UIColor whiteColor];
    }
    return _nameView;
}
-(UIView *)sexView{
    if(!_sexView){
        _sexView=[[UIView alloc]init];
        _sexView.backgroundColor=[UIColor whiteColor];
    }
    return _sexView;
}
-(UIView *)emailView{
    if(!_emailView){
        _emailView=[[UIView alloc]init];
        _emailView.backgroundColor=[UIColor whiteColor];
    }
    return _emailView;
}
-(UIView *)schoolView{
    if(!_schoolView){
        _schoolView=[[UIView alloc]init];
        _schoolView.backgroundColor=[UIColor whiteColor];
    }
    return _schoolView;
}
-(UIView *)departmentView{
    if(!_departmentView){
        _departmentView=[[UIView alloc]init];
        _departmentView.backgroundColor=[UIColor whiteColor];
    }
    return _departmentView;
}
-(UIView *)professionView{
    if(!_professionView){
        _professionView=[[UIView alloc]init];
        _professionView.backgroundColor=[UIColor whiteColor];
    }
    return _professionView;
}
-(UIView *)gradeView{
    if(!_gradeView){
        _gradeView=[[UIView alloc]init];
        _gradeView.backgroundColor=[UIColor whiteColor];
    }
    return _gradeView;
}

-(UIButton *)imageBtn{
    if(!_imageBtn){
        _imageBtn=[[UIButton alloc]init];
        [_imageBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        //[_imageBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:]
        _imageBtn.tag=0;
        [_imageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
-(void)imageBtnClick{
    
        UIActionSheet *sheet;
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//            sheet=[[UIActionSheet alloc]initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选择", nil];
//        }else{
        sheet =[[UIActionSheet alloc]initWithTitle:@"图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"相机拍照" ,@"图库选择",@"取消",nil];
//        }
        [sheet showInView:self.view];
    
}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSUInteger sourceType=0;
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        switch (buttonIndex) {
//            case 1:
//                sourceType=UIImagePickerControllerSourceTypeCamera;
//                break;
//            case 2:
//                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//                break;
//        }
//    }else{
//        if(buttonIndex == 1){
//            sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        }
//    }
//    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
//    imagePickerController.delegate=self;
//    imagePickerController.allowsEditing=YES;
//    imagePickerController.sourceType=sourceType;
//    [self presentViewController:imagePickerController animated:YES completion:^{
//        
//    }];
//}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // “相机”
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 1:
            // “图库”
        {
            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
            imagePickerController.delegate=self;
            imagePickerController.allowsEditing=YES;
            imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];

            break;
            
            
        }
        case 2:
            // “取消”
            break;
        default:
            break;
    }
}


//-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    NSUInteger sourceType=0;
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        switch (buttonIndex) {
//            case 1:
//                sourceType=UIImagePickerControllerSourceTypeCamera;
//                break;
//            case 2:
//                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//                break;
//        }
//    }else{
//        if(buttonIndex == 1){
//            sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
//            imagePickerController.delegate=self;
//            imagePickerController.allowsEditing=YES;
//            imagePickerController.sourceType=sourceType;
//            [self presentViewController:imagePickerController animated:YES completion:^{
//                
//            }];
//
//        }
//    }
//}


-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *str=[NSString stringWithFormat:@"%@.jpg",ApplicationDelegate.userSession];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float length = [imageData length]/1024;
    if(length<1024){
        [self saveImage:image withName:str];
        NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:str];
        UIImage *savedImage =[[UIImage alloc]initWithContentsOfFile:fullPath];
        [self.userImage setImage:savedImage];
        [self uploadPersonImginitWithImage:image];
    }else{
        [UIAlertController showAlertAtViewController:self title:@"提示" message:@"图片大小不能超过1M" confirmTitle:@"我知道了" confirmHandler:^(UIAlertAction *action) {
        }];
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIButton *)nameBtn{
    if(!_nameBtn){
        _nameBtn=[[UIButton alloc]init];
        [_nameBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _nameBtn.tag=0;
        [_nameBtn addTarget:self action:@selector(nameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameBtn;
}
//-(void)nameBtnClick{
//    if(self.nameBtn.tag==0){
//        self.userName.enabled=YES;
//        [self.userName becomeFirstResponder];
//        self.nameBtn.tag=1;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//}
-(void)nameBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userName.text;
    revise.delegate=self;
    revise.tag=1;
    revise.placeHoder=@"昵称";
    [self.navigationController pushViewController:revise animated:YES];
}

-(void)changeContent:(NSString *)text AndTag:(int)tag{
    switch (tag) {
        case 1:
            self.userName.text=text;
            break;
        case 2:
            self.userSex.text=text;
            break;
        case 3:
            self.userEmail.text=text;
            break;
        case 4:
            self.userSchool.text=text;
            break;
        case 5:
            self.userDepartment.text=text;
            break;
        case 6:
            self.userProfession.text=text;
            break;
        case 7:
            self.userGrade.text=text;
            break;
        default:
            break;
    }
    
    [self confirmClick];
}

-(UIButton *)sexBtn{
    if(!_sexBtn){
        _sexBtn=[[UIButton alloc]init];
        [_sexBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _sexBtn.tag=0;
        [_sexBtn addTarget:self action:@selector(sexBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sexBtn;
}
//-(void)sexBtnClick{
//    if(self.sexBtn.tag==0){
//        self.userSex.enabled=YES;
//        [self.userSex becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=1;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//
//}
-(void)sexBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userSex.text;
    revise.delegate=self;
    revise.tag=2;
    revise.placeHoder=@"性别";
    [self.navigationController pushViewController:revise animated:YES];
}

-(UIButton *)emainBtn{
    if(!_emainBtn){
        _emainBtn=[[UIButton alloc]init];
        [_emainBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _emainBtn.tag=0;
        [_emainBtn addTarget:self action:@selector(emailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emainBtn;
}
//-(void)emailBtnClick{
//    if(self.emainBtn.tag==0){
//        self.userEmail.enabled=YES;
//        [self.userEmail becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=1;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//}
-(void)emailBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userEmail.text;
    revise.delegate=self;
    revise.tag=3;
    revise.placeHoder=@"邮箱";
    [self.navigationController pushViewController:revise animated:YES];
}
-(UIButton *)schoolBtn{
    if(!_schoolBtn){
        _schoolBtn=[[UIButton alloc]init];
        [_schoolBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _schoolBtn.tag=0;
        [_schoolBtn addTarget:self action:@selector(schoolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _schoolBtn;
}
//-(void)schoolBtnClick{
//    if(self.schoolBtn.tag==0){
//        self.userSchool.enabled=YES;
//        [self.userSchool becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=1;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//
//}
-(void)schoolBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userSchool.text;
    revise.delegate=self;
    revise.tag=4;
    revise.placeHoder=@"学校";
    [self.navigationController pushViewController:revise animated:YES];
}

-(UIButton *)departmentBtn{
    if(!_departmentBtn){
        _departmentBtn=[[UIButton alloc]init];
        [_departmentBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _departmentBtn.tag=0;
        [_departmentBtn addTarget:self action:@selector(departmentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _departmentBtn;
}
//-(void)departmentBtnClick{
//    if(self.departmentBtn.tag==0){
//        self.userDepartment.enabled=YES;
//        [self.userDepartment becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=1;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//
//}
-(void)departmentBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userDepartment.text;
    revise.delegate=self;
    revise.tag=5;
    revise.placeHoder=@"院系";
    [self.navigationController pushViewController:revise animated:YES];
}

-(UIButton *)professionBtn{
    if(!_professionBtn){
        _professionBtn=[[UIButton alloc]init];
        [_professionBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _professionBtn.tag=0;
        [_professionBtn addTarget:self action:@selector(professionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _professionBtn;
}
//-(void)professionBtnClick{
//    if(self.professionBtn.tag==0){
//        self.userProfession.enabled=YES;
//        [self.userProfession becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=1;
//        self.gradeBtn.tag=0;
//    }else{
//        [self confirmClick];
//    }
//
//}
-(void)professionBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userProfession.text;
    revise.delegate=self;
    revise.tag=6;
    revise.placeHoder=@"请输入专业";
    [self.navigationController pushViewController:revise animated:YES];
}
-(UIButton *)gradeBtn{
    if(!_gradeBtn){
        _gradeBtn=[[UIButton alloc]init];
        [_gradeBtn setImage:[UIImage imageNamed:@"返回 灰色小"] forState:UIControlStateNormal];
        _gradeBtn.tag=0;
        [_gradeBtn addTarget:self action:@selector(gradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gradeBtn;
}
//-(void)gradeBtnClick{
//    if(self.gradeBtn.tag==0){
//        [self.userGrade becomeFirstResponder];
//        self.nameBtn.tag=0;
//        self.sexBtn.tag=0;
//        self.emainBtn.tag=0;
//        self.schoolBtn.tag=0;
//        self.departmentBtn.tag=0;
//        self.professionBtn.tag=0;
//        self.gradeBtn.tag=1;
//    }else{
//        [self confirmClick];
//    }
//
//}
-(void)gradeBtnClick{
    SCReviseViewController *revise=[[SCReviseViewController alloc]init];
    revise.infomation=self.userGrade.text;
    revise.delegate=self;
    revise.tag=7;
    revise.placeHoder=@"年级";
    [self.navigationController pushViewController:revise animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userName resignFirstResponder];
    [self.userSex resignFirstResponder];
    [self.userEmail resignFirstResponder];
    [self.userSchool resignFirstResponder];
    [self.userDepartment resignFirstResponder];
    [self.userProfession resignFirstResponder];
    [self.userGrade resignFirstResponder];
    [self confirmClick];
//    if(textField==self.searchTextField){
//        self.allCourseBtn.selected=NO;
//        self.allCourseBtnImage.selected=NO;
//        self.videoHistoryBtn.selected=NO;
//        self.videoHistoryBtnImage.selected=NO;
//        self.myNotesBtn.selected=NO;
//        self.myNotesBtnImage.selected=NO;
//        self.favouriteSettingBtn.selected=NO;
//        self.favouriteSettingBtnImage.selected=NO;
//        [self.scroll setHidden:YES];
//        [self.searchTextField resignFirstResponder];//放弃当前焦点
//        [self searchBtnClick];
//        
//        
//        if ([self.searchTextField.text isEqualToString:@""]) {
//            [UIAlertController showAlertAtViewController:self withMessage:@"请输入关键词搜索" cancelTitle:@"取消" confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
//                
//            } confirmHandler:^(UIAlertAction *action) {
//                [self.searchTextField becomeFirstResponder];
//            }];
//        }
//        else{
//            self.searchView.keyWord = textField.text;
//            [self.mainView addSubview:self.searchView];
//        }
//    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.userSex resignFirstResponder];
    [self.userEmail resignFirstResponder];
    [self.userSchool resignFirstResponder];
    [self.userDepartment resignFirstResponder];
    [self.userProfession resignFirstResponder];
    [self.userGrade resignFirstResponder];
    
}

#pragma mark--------------    上传头像图片
-(void)uploadPersonImginitWithImage:(UIImage *)image{
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://101.200.73.189/SuperCourseServer/upload.php"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //获取当前时间所闻文件名，防止图片重复
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
//        NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"head.png"];
//        UIImage *savedImage =[[UIImage alloc]initWithContentsOfFile:fullPath];

        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSString * uploadfile = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"file" fileName:ApplicationDelegate.userSession mimeType:@"image/png"];
        
//        Error Domain=NSCocoaErrorDomain Code=3840 "JSON text did not start with array or object and option to allow fragments not set." UserInfo={NSDebugDescription=JSON text did not start with array or object and option to allow fragments not set.}
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil) {
            //[self refreshDB:responseObject[@"photourl"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error != nil) {
            //to do
        }
    }];
    
}



//-(ImagePickerViewController *)pickImage{
//    if(!_pickImage){
//        _pickImage=[[ImagePickerViewController alloc]init];
//    }
//    return _pickImage;
//}
//-(UIButton *)getImage{
//    if(!_getImage){
//        _getImage=[[UIButton alloc]init];
//        [_getImage addTarget:self action:@selector(getImageClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _getImage;
//}
//-(void)getImageClick{
//    [self.pickImage clickPickImage];
//    //[self.navigationController pushViewController:self.pickImage animated:YES];
//}
@end
