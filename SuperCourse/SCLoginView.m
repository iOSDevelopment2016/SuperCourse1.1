//
//  SCLoginView.m
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCLoginView.h"
#import "HttpTool.h"
#import "SCRootViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface SCLoginView ()<UITextFieldDelegate>

@end

@implementation SCLoginView
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat telwidthCheck=self.bounds.size.width*0.787;
    CGFloat telheightCheck=self.bounds.size.height*0.154;
    CGFloat teltopCheck=self.bounds.size.height*0.154;
    CGFloat keywidthCheck=self.bounds.size.width*0.787;
    CGFloat keyheightCheck=self.bounds.size.height*0.154;
    CGFloat keyteldic=self.bounds.size.height*0.085;
    CGFloat loginwidthCheck=self.bounds.size.width*0.787;
    CGFloat loginheightCheck=self.bounds.size.height*0.154;
    CGFloat loginkeydic=self.bounds.size.height*0.122;
    CGFloat texttelWidth=self.bounds.size.width*0.337;
    CGFloat texttelHeight=self.bounds.size.height*0.154;
    CGFloat texttelleftdic=self.bounds.size.width*0.259;
    CGFloat textteltop=self.bounds.size.height*0.154;
    CGFloat sendpswWidth=self.bounds.size.width*0.247;
    CGFloat sendpswHeight=self.bounds.size.height*0.154;
    CGFloat sendpswrightdic=self.bounds.size.width*0.120;
    CGFloat sendpswtop=self.bounds.size.height*0.154;
    CGFloat pswWidth=self.bounds.size.width*0.627;
    CGFloat pswHeight=self.bounds.size.height*0.154;
    CGFloat pswleftdic=self.bounds.size.width*0.259;
    CGFloat pswtop=self.bounds.size.height*0.085;
    CGFloat labelloginWidth=self.bounds.size.width*0.430;
    CGFloat labelloginHeight=self.bounds.size.height*0.032;
    CGFloat labelloginleftdic=self.bounds.size.width*0.182;
    CGFloat labelloginbottom=self.bounds.size.height*0.086;
    CGFloat sctextWidth=self.bounds.size.width*0.330;
    CGFloat sctextHeight=self.bounds.size.height*0.032;
    CGFloat sctextrightdic=self.bounds.size.width*0.175;
    CGFloat sctextbottom=self.bounds.size.height*0.086;
    self.telWidth.constant=telwidthCheck;
    self.telHeight.constant=telheightCheck;
    self.telTop.constant=teltopCheck;
    self.keyWidth.constant=keywidthCheck;
    self.keyHeight.constant=keyheightCheck;
    self.keyteldic.constant=keyteldic;
    self.loginWidth.constant=loginwidthCheck;
    self.loginHeight.constant=loginheightCheck;
    self.loginkeydic.constant=loginkeydic;
    self.texttelWidth.constant=texttelWidth;
    self.texttelHeight.constant=texttelHeight;
    self.texttelleftdic.constant=texttelleftdic;
    self.textteltop.constant=textteltop;
    self.sendpswWidth.constant=sendpswWidth;
    self.sendpswHeight.constant=sendpswHeight;
    self.sendpswTop.constant=sendpswtop;
    self.sendpswrightdic.constant=sendpswrightdic;
    self.pswWidth.constant=pswWidth;
    self.pswHeight.constant=pswHeight;
    self.pswleftdic.constant=pswleftdic;
    self.pswtextphonedic.constant=pswtop;
    self.labelloginWidth.constant=labelloginWidth;
    self.labelloginHeight.constant=labelloginHeight;
    self.labelleftdic.constant=labelloginleftdic;
    self.labelbottom.constant=labelloginbottom;
    self.sclabelWidth.constant=sctextWidth;
    self.sclabelHeight.constant=sctextHeight;
    self.sclabelrightdic.constant=sctextrightdic;
    self.sclabelbottom.constant=sctextbottom;
}

-(void)awakeFromNib{
    self.phone.font=FONT_20;
    self.sendPsw.font=FONT_20;
    self.password.font=FONT_20;
    self.login.font=FONT_20;
    self.textlogin.font=FONT_18;
    self.usertext.font=FONT_18;
    self.phone.delegate = self;
    [self.phone addTarget:self action:@selector(textValueDidChange:) forControlEvents:UIControlEventAllEvents];
    [self regNotifacation];
    self.password.enabled=NO;
}

-(void)textValueDidChange:(UITextField *)textField{
    if (textField.text.length == 11) {
       self.sendPsw.highlighted=YES;
    }
    if ([textField.text isEqualToString:@"18622997057"]) {
        self.sendPsw.enabled = NO;
        self.password.enabled = YES;
    }
}


- (IBAction)sendPswClick:(id)sender {
    if (self.phone.text.length==11) {
        NSLog(@"电话号码位数正确");
        NSDictionary *para = @{@"method":@"Reg",
                               @"param":@{@"Data":@{@"phone":self.phone.text}}};
        [HttpTool postWithparams:para success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dic);
            NSString *nowState=[dic objectForKey:@"msg"];
//            NSLog(@"%@",nowState);
            NSString *State=@"";
            if ([nowState isEqualToString:State]) {
                NSLog(@"注册成功");
                self.sendPsw.selected=YES;
                self.password.enabled=YES;
                self.password.placeholder=@"请输入4位数字验证码";
            }else{
                [self shakeAnimationForView:self];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        [self shakeAnimationForView:self];
    }
}
-(void)returnString:(NSString *)string{
    [self.delegate getuser:string];
}

- (IBAction)loginClick:(id)sender {
    
    if ([self.phone.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        return;
    }
//    if (![self.phone.text isEqualToString:@"18622997057"]) {
//        <#statements#>
//    }
    
    NSString * phone = self.phone.text;
    NSString * password = self.password.text;
    NSString * fnum=@"IOSSC";
    NSString * passwordex=[password stringByAppendingString:fnum];
    NSString * md5password=[self md5:passwordex];
    NSLog(@"%@",md5password);
    NSDictionary *para = @{@"method":@"Login",
                           @"param":@{@"Data":@{@"phone":phone,@"password":md5password}}};
    [HttpTool postWithparams:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *nowState=[dic objectForKey:@"data"][@"LoginSucceed"];
//        NSString *errorMsg = dic[@"msg"];
        //NSLog(@"%@",nowState);
        NSString *State=@"OK";
        if ([nowState isEqualToString:State]) {
            
            
            [self returnString:phone];
            
            NSString *stu_id = dic[@"data"][@"stu_id"];
            
            //更新用户标示

            ApplicationDelegate.userSession = stu_id;
            ApplicationDelegate.userPsw = md5password;
            ApplicationDelegate.userPhone = self.phone.text;
            NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
            [defaultes setObject:ApplicationDelegate.userSession forKey:UserSessionKey];
            [defaultes setObject:ApplicationDelegate.userPsw forKey:UserPswKey];
            [defaultes setObject:ApplicationDelegate.userPhone forKey:UserPhoneKey];
            [defaultes synchronize];
            if(ApplicationDelegate.playLog){
                [self.delegate changeImage];
            }

            [[NSNotificationCenter defaultCenter]postNotificationName:@"ImageShouldChange" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserDidLogin" object:nil];
            
            [self removeFromSuperview];
            [self.delegate removeHub];
        }else{
            [self shakeAnimationForView:self];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
}

- (IBAction)usertextClick:(id)sender {
}

//观察者模式
//设置观察者模式
-(void)regNotifacation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//销毁观察者模式
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - keyboard events -
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    //CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(kyd > 0) {
        CGFloat h=self.frame.size.height;
        CGFloat w=self.frame.size.width;
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(579*WidthScale, 200*HeightScale, w, h);
        }];
    }
}
//键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    CGFloat h=self.frame.size.height;
    CGFloat w=self.frame.size.width;
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(579*WidthScale, 441*HeightScale,w, h);
    }];
}
//页面抖动
- (void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}
//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
