//
//  SCMyNotesView.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCMyNotesView.h"
#import "HttpTool.h"
#import "UIAlertController+SZYKit.h"

@interface SCMyNotesView ()<UITextViewDelegate>
@property (nonatomic ,strong) UITextView *notesTextView;
//@property (nonatomic ,strong) UIButton *createBtn;
@property (nonatomic, strong) UIView *scrollView;
//@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *operationBtn;
@property (nonatomic,strong) UIView  *bottomView;
@property (nonatomic ,strong) UIView *borderView;


@property (nonatomic, assign) BOOL allowEdit;

//- (IBAction)usertextClick:(id)sender;
////设置观察者模式
//-(void)regNotifacation;
//-(void)dealloc;
//
@end



@implementation SCMyNotesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allowEdit = NO;
        self.backgroundColor = UIBackgroundColor;
        
        [self addSubview:self.bottomView];
        [self addSubview:self.borderView];
        [self.borderView addSubview:self.notesTextView];
        [self addSubview:self.scrollView];
//        [self addSubview:self.createBtn];
//        [self addSubview:self.saveBtn];
        [self addSubview:self.operationBtn];
        [self loadData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"UserDidLogin" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearNotes) name:@"UserDidLogout" object:nil];

    }
    return self;
}

-(void)clearNotes{
    
    self.notesTextView.text = @"";
}

-(void)loadData{
//    NSString *student_id = ApplicationDelegate.userSession;
    NSString *student_id = ApplicationDelegate.userSession;
    NSString *student_password = ApplicationDelegate.userPsw;
    if (!student_password) {
        student_password = @"";
    }
    NSDictionary *para = @{@"method":@"GetStudentNote",
                           @"param":@{@"Data":@{@"student_id":student_id,@"student_password":student_password}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSString *note=[dic objectForKey:@"data"];
        self.notesTextView.text = note;
        
        } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)loadDataSave{
    NSString *student_id = ApplicationDelegate.userSession;
    NSString *student_password = ApplicationDelegate.userPsw;
    NSString *temp=self.notesTextView.text;
    if (!student_password) {
        student_password = @"";
    }
    NSDictionary *para = @{@"method":@"SaveStudentNote",
                           @"param":@{@"Data":@{@"student_id":student_id,@"student_password":student_password,@"save":temp}}};
   
    [HttpTool postWithparams:para success:^(id responseObject){
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"");
     } failure:^(NSError *error) {
        NSLog(@"%@",error);
     }];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return self.allowEdit;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bottomView.frame = CGRectMake(0, 100, self.width, 1217*HeightScale);
    
    self.borderView.frame = CGRectMake(20, 120, self.width-40, 1217*HeightScale-70);
    self.notesTextView.frame = CGRectMake(10, 10, self.borderView.width-20, self.borderView.height-20);
    self.backgroundColor = UIBackgroundColor;
    self.scrollView.frame = CGRectMake(0, 0, self.width, 100*HeightScale);
    self.operationBtn.frame = CGRectMake(0.873*self.width-45, 0, 0.127*self.width, 100*HeightScale);
    
//    self.saveBtn.frame = CGRectMake(850-0.127*self.width, 0, 0.127*self.width, 100*HeightScale);
    
//    //注册通知,监听键盘弹出事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    //注册通知,监听键盘消失事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
}
-(UIButton *)operationBtn{
    if(!_operationBtn){
        _operationBtn=[[UIButton alloc]initWithFrame:CGRectMake(850, 0, 0.127*self.width, 100*HeightScale)];
        
        [_operationBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_operationBtn setTitleColor:UIThemeColor forState:UIControlStateNormal];
        _operationBtn.titleLabel.font = [UIFont systemFontOfSize:25];

        [_operationBtn setTitle:@"保存" forState:UIControlStateSelected];
        [_operationBtn setTitleColor:UIThemeColor forState:UIControlStateSelected];
        [_operationBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationBtn;
    
}
//-(UIButton *)saveBtn{
//    if(!_saveBtn){
//        _saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(300+0.127*self.width, 0, 0.127*self.width, 100*HeightScale)];
//        
//        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//        [_saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _saveBtn;
//    
//}

//-(void)btnClicked:(UIButton *)sender{
//    self.allowEdit = YES;
//    [_notesTextView becomeFirstResponder];
//    _notesTextView.delegate=self;
//
//}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIView *)borderView{
    if (!_borderView){
        _borderView = [[UIView alloc]init];
        _borderView.backgroundColor = [UIColor whiteColor];
        _borderView.layer.masksToBounds = YES;
        _borderView.layer.borderColor = [UIBackgroundColor CGColor];
        _borderView.layer.borderWidth = 1.5f;
        _borderView.layer.cornerRadius = 8.0;
    }
    return _borderView;
}


-(UITextView *)notesTextView{
    if (!_notesTextView) {
        _notesTextView=[[UITextView alloc]init];
        _notesTextView.delegate = self;
        _notesTextView.font = [UIFont systemFontOfSize:25];
        _notesTextView.scrollEnabled = YES;
        //返回键的类型
        _notesTextView.returnKeyType = UIReturnKeyDefault;
        //键盘类型
        _notesTextView.keyboardType = UIKeyboardTypeDefault;
        _notesTextView.delegate=self;
//        [_notesTextView setContentInset:UIEdgeInsetsMake(30, 30, 30, 30)];
//        _notesTextView.backgroundColor  = [UIColor orangeColor];
        
    }
    return _notesTextView;

}

-(UIView *)scrollView{
    if(!_scrollView){
        _scrollView=[[UIView alloc]initWithFrame:CGRectMake(520*WidthScale, 780*HeightScale, 200*HeightScale, 9*HeightScale)];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
    }
    return _scrollView;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [_notesTextView resignFirstResponder];
}

#pragma 响应事件




//- (IBAction)usertextClick:(id)sender {
//}
////观察者模式
////设置观察者模式
//-(void)regNotifacation{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
////销毁观察者模式
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
-(void)saveBtnClick{
    
//    [self loadDataSave];
   
//    self.searchView.keyWord = self.searchTextField.text;
}
-(void)btnClicked{
    if (!self.operationBtn.selected) {
        // 进入编辑状态
        
        if ([ApplicationDelegate.userSession isEqualToString:UnLoginUserSession]) {
          [UIAlertController showAlertAtViewController:self.viewContrller withMessage:@"您还没有登录哦" cancelTitle:@"取消"confirmTitle:@"我知道了" cancelHandler:^(UIAlertAction *action) {
              return ;
          } confirmHandler:^(UIAlertAction *action) {
              return ;
          }];
        }else{
         
            self.allowEdit = YES;
            [self.notesTextView becomeFirstResponder];
       
             self.operationBtn.selected = !self.operationBtn.selected;

//        self.allowEdit = YES;
//        [self.notesTextView becomeFirstResponder];
        }}else{
        // 保存
        [self saveNote];
        [self loadDataSave];
            self.operationBtn.selected = !self.operationBtn.selected;

    }
//    self.operationBtn.selected = !self.operationBtn.selected;
}

// 保存备注
-(void)saveNote{
    // 如果保存成功，取消编辑状态
    self.allowEdit = NO;
    [self.notesTextView resignFirstResponder];
}


//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    return NO;
//}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"])
//    {
//        //Lost Focus
//        [textView resignFirstResponder];
//    }
//    return YES;
//    
//}
#pragma mark - keyboard events -
/////键盘显示事件
//- (void) keyboardWillShow:(NSNotification *)notification {
//    //获取键盘高度，在不同设备上，以及中英文下是不同的
//    //CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //将视图上移计算好的偏移
//    if(kyd > 0) {
//        CGFloat h=self.frame.size.height;
//        CGFloat w=self.frame.size.width;
//        [UIView animateWithDuration:duration animations:^{
//            self.frame = CGRectMake(579*WidthScale, 241*HeightScale, w, h);
//        }];
//    }
//}
//键盘消失事件
//- (void) keyboardWillHide:(NSNotification *)notify {
//    // 键盘动画时间
//    CGFloat h=self.frame.size.height;
//    CGFloat w=self.frame.size.width;
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        self.frame = CGRectMake(579*WidthScale, 441*HeightScale,w, h);
//    }];
//}
//
@end
