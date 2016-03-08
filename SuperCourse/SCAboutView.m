//
//  SCAboutView.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/20.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCAboutView.h"

@interface SCAboutView()

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UILabel *lesIntroductionLabel;
@property (nonatomic, strong) IBOutlet UILabel *memberLabel;
@property (nonatomic, strong) IBOutlet UILabel *thankmemberLabel;

@end

@implementation SCAboutView


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor whiteColor];
        self.frame = frame;
        [self addSubview:self.topView];
        [self addSubview:self.topLabel];
        [self addSubview:self.lesIntroductionLabel];
        [self addSubview:self.memberLabel];
        [self addSubview:self.thankmemberLabel];

    }
    return self;
}

#pragma mark - getters
-(UIView *)topView{

    if (!_topView) {
        _topView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width,self.height*0.172)];
        [_topView setBackgroundColor:UIBackgroundColor];
    }
    return _topView;
}

-(UILabel *)topLabel{

    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width,self.height*0.172)];
        [_topLabel setTextColor:UIThemeColor];
        [_topLabel setBackgroundColor:[UIColor clearColor]];
        [_topLabel setText:@"    关于超课"];
        _topLabel.font = [UIFont systemFontOfSize:70*WidthScale];
    }
    return _topLabel;
}

-(UILabel *)lesIntroductionLabel{

    if (!_lesIntroductionLabel) {
        _lesIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*WidthScale, self.height*0.172, self.width-40*WidthScale, self.height*0.528)];
        [_lesIntroductionLabel setTextColor:[UIColor grayColor]];

        [_lesIntroductionLabel setBackgroundColor:[UIColor clearColor]];
//        _lesIntroductionLabel.layer.borderColor = UIBackgroundColor.CGColor;
//        _lesIntroductionLabel.layer.borderWidth = 2;
        _lesIntroductionLabel.text = [NSString stringWithFormat:@"          这是一款神奇的视频课程播放器。它支持视频超级链接。您可以像浏览网页一样观看视频课程，随时点击跳转到您关注的内容。它特别适合您自学视频课程时使用。预先组织好的知识链接，可以为您节省大量的查找资料的时间。"];
        _lesIntroductionLabel.font = [UIFont systemFontOfSize:55*WidthScale];
        _lesIntroductionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _lesIntroductionLabel.numberOfLines = 0;
    }
    
    return _lesIntroductionLabel;
}

-(UILabel *)memberLabel{

    if (!_memberLabel) {
        _memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height*0.7, self.width-20*WidthScale, self.height*0.15)];
        [_memberLabel setTextColor:[UIColor grayColor]];
        
        [_memberLabel setBackgroundColor:[UIColor clearColor]];
//        _memberLabel.layer.borderColor = UIBackgroundColor.CGColor;
//        _memberLabel.layer.borderWidth = 2;
        _memberLabel.text = [NSString stringWithFormat:@"制作成员：孙锐、刘芮东、李昶辰                             "];
        _memberLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        _memberLabel.lineBreakMode = UILineBreakModeWordWrap;
        _memberLabel.textAlignment = UITextAlignmentRight;
        _memberLabel.numberOfLines = 0;
    }
    
    return _memberLabel;

}
-(UILabel *)thankmemberLabel{
    
    if (!_thankmemberLabel) {
        _thankmemberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height*0.85, self.width-20*WidthScale, self.height*0.15)];
        [_thankmemberLabel setTextColor:[UIColor grayColor]];
        
        [_thankmemberLabel setBackgroundColor:[UIColor clearColor]];
//        _thankmemberLabel.layer.borderColor = UIBackgroundColor.CGColor;
//        _thankmemberLabel.layer.borderWidth = 2;
        _thankmemberLabel.text = [NSString stringWithFormat:@"特别感谢：金钟、孙中原、李斌、刘祥丰、肖晓青                             "];
        _thankmemberLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        _thankmemberLabel.lineBreakMode = UILineBreakModeWordWrap;
        _thankmemberLabel.textAlignment = UITextAlignmentRight;
        _thankmemberLabel.numberOfLines = 0;
    }
    
    return _thankmemberLabel;
    
}

@end
