//
//  SCLoginView.h
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCLoginViewDelegate <NSObject>

//-(void)regBtnDidClick:(UIButton *)sender;
-(void)getuser:(NSString *)userphone;
-(void)removeHub;
-(void)changeImage;
-(void)sendAlert;
@end

@interface SCLoginView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *sendPsw;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *usertext;
@property (weak, nonatomic) IBOutlet UILabel *textlogin;
- (IBAction)sendPswClick:(id)sender;
- (IBAction)loginClick:(id)sender;
- (IBAction)usertextClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyteldic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginkeydic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texttelleftdic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textteltop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texttelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texttelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendpswWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendpswHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendpswTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendpswrightdic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswleftdic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pswtextphonedic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelloginWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelloginHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelbottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelleftdic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sclabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sclabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sclabelbottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sclabelrightdic;


//设置观察者模式
-(void)regNotifacation;
-(void)dealloc;

@property (nonatomic ,weak) id<SCLoginViewDelegate> delegate;
@end
