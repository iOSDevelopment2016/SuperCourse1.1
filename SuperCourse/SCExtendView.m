//
//  SCExtendView.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/2.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCExtendView.h"
//#import "SCExtendView.xib"

@interface SCExtendView ()
@property (strong, nonatomic)  UILabel       *headLabel;

//@property (strong, nonatomic)  UILabel       *firseLabel;
@property (strong, nonatomic)  UILabel       *secondLabel;
//@property (strong, nonatomic)  UILabel       *thirdLabel;

@property (strong, nonatomic)  UILabel       *firseLabelText;
@property (strong, nonatomic)  UILabel       *secondLabelText;
@property (strong, nonatomic)  UILabel       *thirdLabelText;

@property (strong, nonatomic)  UIButton *backBtn;
@property (strong, nonatomic)  UIImageView *firstCircle;
@property (strong, nonatomic)  UIImageView *secondCircle;
@property (strong, nonatomic)  UIImageView *thirdCircle;
@property (strong, nonatomic)  UILabel *firstTitle;
@property (strong, nonatomic)  UILabel *secondTitle;
@property (strong, nonatomic)  UILabel *thirdeTitle;
@property (nonatomic, strong)  UIView  *scorllViewHead;
@property (nonatomic, strong)  UIView  *scorllViewBottom;

@end


@implementation SCExtendView



- (instancetype)initWithString:(NSString *)title AndDataSource:(SCIntroductionDataSource *)datasource AndWidth:(float)width AndHeight:(float)height
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        //self.title=title;
       // self.frame= CGRectMake(0, 0, width, height);
//        self = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SCExtendView class]) owner:nil options:nil].lastObject;
        [self setTitleFont:self.headLabel];
        self.headLabel.text=[NSString stringWithFormat:@"       %@",title];;
        NSString *firstText=@"";
        for(int i=0; i<datasource.har_des.count;i++){
            SCIntroduction *introduct=datasource.har_des[i];
            firstText=[firstText stringByAppendingFormat:@"%@\n",introduct.les_intrdoc];
        }
        self.firseLabelText.text=firstText;
        //datasource.har_des.count
        self.firseLabelText.font=[UIFont systemFontOfSize:28*HeightScale];
        
        
        NSString *secondText=@"";
        for(int i=0; i<datasource.knowledge.count;i++){
            SCKnowledge *knoledge=datasource.knowledge[i];
            secondText=[secondText stringByAppendingFormat:@"%@\n",knoledge.preknowledge_des];
        }
        self.secondLabelText.text=secondText;
        self.secondLabelText.font=[UIFont systemFontOfSize:28*HeightScale];

        
        NSString *thirdText=@"";
        for(int i=0; i<datasource.willknow.count;i++){
            SCWillLearn *willLearn=datasource.willknow[i];
            thirdText=[thirdText stringByAppendingFormat:@"%@\n",willLearn.har_des];
        }
        self.thirdLabelText.text=thirdText;
        self.thirdLabelText.font=[UIFont systemFontOfSize:28*HeightScale];

        self.headLabel.font=[UIFont systemFontOfSize:55*HeightScale];
       // self.firseLabel.font=[UIFont systemFontOfSize:25*HeightScale];
        self.secondLabel.font=[UIFont systemFontOfSize:25*HeightScale];
        //self.thirdLabel.font=[UIFont systemFontOfSize:25*HeightScale];
        self.backBtn.font=[UIFont systemFontOfSize:50*HeightScale];
        
        
        [self addSubview:self.headLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:self.firseLabelText];
        [self addSubview:self.secondLabelText];
        [self addSubview:self.thirdLabelText];
        [self addSubview:self.backBtn];
        [self addSubview:self.firstCircle];
        [self addSubview:self.secondCircle];
        [self addSubview:self.thirdCircle];
        [self addSubview:self.firstTitle];
        [self addSubview:self.secondTitle];
        [self addSubview:self.thirdeTitle];
        [self addSubview:self.scorllViewBottom];
        [self addSubview:self.scorllViewHead];
        
      
        


    }
    return self;
}



//-(void)awakeFromNib{
//
//    self.headLabel.frame=CGRectMake(0, 0, self.width,self.height*0.172);
//    self.firstCircle.frame=CGRectMake(self.width*0.04, self.height*0.19, self.width*0.28, self.width*0.28);
//    
//    self.firseLabelText.frame=CGRectMake(self.width*0.025, self.height*0.185, self.width*0.948, self.height*0.13);
//    self.firstTitle.frame=CGRectMake(self.width*0.1, self.height*0.193, self.width*0.05, self.height*0.042);
//    
//    self.secondCircle.frame=CGRectMake(self.width*0.04, self.height*0.364, self.width*0.28, self.width*0.28);
//    self.secondTitle.frame=CGRectMake(self.width*0.1, self.height*0.364, self.width*0.2, self.width*0.28);
//    self.secondLabelText.frame=CGRectMake(self.width*0.025, self.height*0.4, self.width*0.95, self.height*0.148);
//    self.secondLabel.frame=CGRectMake(0, self.height*0.35, self.width, self.height*0.18);
//    
//    self.thirdCircle.frame=CGRectMake(self.width*0.04, self.height*0.555, self.width*0.28, self.width*0.28);
//    self.thirdeTitle.frame=CGRectMake(self.width*0.1, self.height*0.555, self.width*0.543, self.width*0.28);
//    self.thirdLabelText.frame=CGRectMake(self.width*0.025, self.height*0.636, self.width*0.935, self.height*0.187);
//    
//    self.backBtn.frame=CGRectMake(self.width*0.313, self.height*0.837, self.width*0.374, self.height*0.1);
//
//       //[self setBoarder:self.secondLabel];
//    //[self setBoarder:self.thirdLabel];
//    _backBtn.layer.masksToBounds = YES;
//    _backBtn.layer.cornerRadius = 31;
//    _backBtn.backgroundColor=UIColorFromRGB(0x6fccdb);
//    //self.headLabel.text=self.title;
////    SCIntroduction *introduction=self.datasource.har_des;
////    for (NSObject a in introduction) {
////
////    }
////    self.firseLabelText
//}

-(void)setTitleFont:(UILabel *)label{
    label.font=[UIFont systemFontOfSize:30];
}


- (void)backBtnClick {
    [self.delegate returnToMainView];
}



-(void)setBoarder:(UILabel *)label{
    [label.layer setBorderWidth:1];//设置边界的宽度
    [label.layer setBorderColor:UIColorFromRGB(0xeeeeee).CGColor];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.headLabel.frame=CGRectMake(0, 0, self.width,self.height*0.172);
    self.firstCircle.frame=CGRectMake(self.width*0.04, self.height*0.19, self.width*0.028, self.width*0.028);
    
    self.firseLabelText.frame=CGRectMake(self.width*0.025, self.height*0.23, self.width*0.948, self.height*0.13);
    self.firstTitle.frame=CGRectMake(self.width*0.1, self.height*0.193, self.width*0.1, self.height*0.042);
    
    self.secondCircle.frame=CGRectMake(self.width*0.04, self.height*0.364, self.width*0.028, self.width*0.028);
    self.secondTitle.frame=CGRectMake(self.width*0.1, self.height*0.364, self.width*0.3, self.width*0.028);
    self.secondLabelText.frame=CGRectMake(self.width*0.025, self.height*0.4, self.width*0.95, self.height*0.148);
    self.secondLabel.frame=CGRectMake(0, self.height*0.35, self.width, self.height*0.18);
    
    self.thirdCircle.frame=CGRectMake(self.width*0.04, self.height*0.555, self.width*0.028, self.width*0.028);
    self.thirdeTitle.frame=CGRectMake(self.width*0.1, self.height*0.555, self.width*0.543, self.width*0.028);
    self.thirdLabelText.frame=CGRectMake(self.width*0.025, self.height*0.636, self.width*0.935, self.height*0.187);
    
    self.backBtn.frame=CGRectMake(self.width*0.313, self.height*0.837, self.width*0.374, self.height*0.1);
    
    self.scorllViewHead.frame=CGRectMake(0, self.height*0.35, self.width, 1);
    self.scorllViewBottom.frame=CGRectMake(0, self.height*0.53, self.width, 1);
    //[self setBoarder:self.secondLabel];
    //[self setBoarder:self.thirdLabel];
    _backBtn.layer.masksToBounds = YES;
    _backBtn.layer.cornerRadius = 50*HeightScale;
    _backBtn.backgroundColor=UIColorFromRGB(0x6fccdb);
    
    
    
}



-(UILabel *)headLabel{
    if(!_headLabel){
        _headLabel=[[UILabel alloc]init];
        _headLabel.backgroundColor=UIColorFromRGB(0xeeeeee);
//        _headLabel.backgroundColor = [UIColor orangeColor];
    }
    return _headLabel;

}
-(UILabel*)secondLabel{
    if(!_secondLabel){
        _secondLabel=[[UILabel alloc]init];
        
        //[self setBoarder:_secondLabel];
    }
    return _secondLabel;

}
-(UILabel*)firseLabelText{
    if(!_firseLabelText){
        _firseLabelText=[[UILabel alloc]init];
        _firseLabelText.lineBreakMode = UILineBreakModeWordWrap;
        _firseLabelText.numberOfLines = 0;
    }
    return _firseLabelText;
}


-(UILabel*)secondLabelText{
    if(!_secondLabelText){
        _secondLabelText=[[UILabel alloc]init];
        _secondLabelText.lineBreakMode = UILineBreakModeWordWrap;
        _secondLabelText.numberOfLines = 0;
    }
    return _secondLabelText;
}

-(UILabel*)thirdLabelText{
    if(!_thirdLabelText){
        _thirdLabelText=[[UILabel alloc]init];
        _thirdLabelText.lineBreakMode = UILineBreakModeWordWrap;
        _thirdLabelText.numberOfLines = 0;
    }
    return _thirdLabelText;
}
-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn setTitle:@"确     定" forState:UIControlStateNormal];
        _backBtn.backgroundColor=UIThemeColor;
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(UIImageView*)firstCircle{
    if(!_firstCircle){
        _firstCircle=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小圆"]];
    }
    return _firstCircle;
}
-(UIImageView*)secondCircle{
    if(!_secondCircle){
        _secondCircle=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小圆"]];
    }
    return _secondCircle;

}
-(UIImageView*)thirdCircle{
    if(!_thirdCircle){
        _thirdCircle=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小圆"]];
    }
    return _thirdCircle;

}
-(UILabel*)firstTitle{
    if(!_firstTitle){
        _firstTitle=[[UILabel alloc]init];
        _firstTitle.text=@"简介";
        _firstTitle.font=[UIFont systemFontOfSize:23.5];
    }
    return _firstTitle;
}
-(UILabel*)secondTitle{
    if(!_secondTitle){
        _secondTitle=[[UILabel alloc]init];
        _secondTitle.text=@"本节需掌握的知识";
        _secondTitle.font=[UIFont systemFontOfSize:23.5];
    }
    return _secondTitle;
}
-(UILabel*)thirdeTitle{
    if(!_thirdeTitle){
        _thirdeTitle=[[UILabel alloc]init];
        _thirdeTitle.text=@"本节将学习的知识";
        _thirdeTitle.font=[UIFont systemFontOfSize:23.5];
    }
    return _thirdeTitle;
}
-(UIView*)scorllViewHead{
    if(!_scorllViewHead){
        _scorllViewHead=[[UIView alloc]init];
        _scorllViewHead.backgroundColor=UIColorFromRGB(0xeeeeee);
    }
    return _scorllViewHead;
}
-(UIView *)scorllViewBottom{
    if(!_scorllViewBottom){
        _scorllViewBottom=[[UIView alloc]init];
        _scorllViewBottom.backgroundColor=UIColorFromRGB(0xeeeeee);
    }
    return _scorllViewBottom;
}

@end
