//
//  SCRightView.m
//  SuperCourse
//
//  Created by Develop on 16/1/24.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCRightView.h"
#import "SCPointView.h"
#import "ZQTagList.h"
#import "SCVideoSubTitleMode.h"

#import "SCVideoInfoModel.h"




@implementation SCRightView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundView];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.topView];
        [self.topView addSubview:self.extendBtn];
        [self.topView addSubview:self.pointBtn];
        [self.topView addSubview:self.blueBottom];
        self.extendBtn.selected = YES;
        [self addSubview:self.tagList];
    }
    return self;
}


#pragma mark - 响应事件

-(void)extendBtnClick{
    
    self.extendBtn.selected = YES;
    self.pointBtn.selected = NO;
    if (self.blueBottom.bounds.origin.x != 108*WidthScale) {
        [UIView animateWithDuration:0.3 animations:^{
            self.blueBottom.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    [self.pointView removeFromSuperview];
    [self addSubview:self.tagList];
}

-(void)pointBtnClick{
    
    self.extendBtn.selected = NO;
    self.pointBtn.selected = YES;
    if (self.blueBottom.bounds.origin.x != 338*WidthScale) {
        [UIView animateWithDuration:0.3 animations:^{
            self.blueBottom.transform = CGAffineTransformMakeTranslation(230*WidthScale, 0);
        }];
    }
    [self.tagList removeFromSuperview];
    [self addSubview:self.pointView];

    
}

-(void)searchThis:(SCVideoLinkMode *)link{
    
//    
//    [self clearBtnLooking];
//    sender.selected = YES;
//    [self changeBtnLooking:sender];

    [self.delegate openLink:link];
}

//-(void)changeBtnLooking:(UIButton *)sender{
//
//    [sender setTitleColor:UIThemeColor forState:UIControlStateSelected];
//    sender.layer.borderColor = UIThemeColor.CGColor;
//}

//-(void)clearBtnLooking{
//    
//    for (UIButton *btn in self.tagList.subviews) {
//        
//       btn.titleLabel.textColor = [UIColor blackColor];
//       btn.layer.borderColor = [UIColor clearColor].CGColor;
//       btn.selected = NO;
//        
//    }
//}



#pragma mark - getters

-(UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.frame = CGRectMake(12*WidthScale, 0, self.bounds.size.width, 100*HeightScale);
        [_topView setBackgroundColor:[UIColor whiteColor]];
    }
    return _topView;
}

-(UIButton *)extendBtn{
    
    if (!_extendBtn) {
        _extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extendBtn setTitle:@"拓展" forState:UIControlStateNormal];
        _extendBtn.titleLabel.font = [UIFont systemFontOfSize:40*WidthScale];
        [_extendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_extendBtn setTitleColor:UIThemeColor forState:UIControlStateSelected];
        _extendBtn.frame = CGRectMake(108*WidthScale, 10, 200*WidthScale, 90*HeightScale);
        [_extendBtn addTarget:self action:@selector(extendBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.extendView addSubview:self.tagList];
    }
    return _extendBtn;
}

-(UIButton *)pointBtn{
    
    if (!_pointBtn) {
        _pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointBtn setTitle:@"节点" forState:UIControlStateNormal];
        _pointBtn.titleLabel.font = [UIFont systemFontOfSize:40*WidthScale];
        [_pointBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pointBtn setTitleColor:UIThemeColor forState:UIControlStateSelected];
        _pointBtn.frame = CGRectMake(338*WidthScale, 10, 200*WidthScale, 90*HeightScale);
        [_pointBtn addTarget:self action:@selector(pointBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pointBtn;
}

-(UIView *)blueBottom{

    if (!_blueBottom) {
        _blueBottom = [[UIView alloc]initWithFrame:CGRectMake(108*WidthScale, 90*HeightScale, 200*WidthScale, 10*HeightScale)];
        _blueBottom.backgroundColor = UIThemeColor;
    }
    return _blueBottom;
}


-(void)deleteDate:(NSString *)stuId And:(NSString *)stuPsw And:(NSString *)lessonId{
    
    self.pointView.stuId = stuId;
    self.pointView.stuPsw = stuPsw;
    self.pointView.lessonId = lessonId;
}

-(UIView *)extendView{
    
    if (!_extendView) {
        _extendView = [[UIView alloc]initWithFrame:CGRectMake(12*WidthScale, 100*HeightScale, 647*WidthScale, 1282*HeightScale)];
        _extendView.backgroundColor = UIBackgroundColor;
       
        
    }
    return _extendView;
}

-(UIView *)backgroundView{

    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(12*WidthScale, 100*HeightScale, 647*WidthScale, 1282*HeightScale)];
        _backgroundView.backgroundColor = UIBackgroundColor;
    }
    return _backgroundView;
}

-(SCPointView *)pointView{

    if (!_pointView) {
        _pointView = [[SCPointView alloc]initWithFrame:CGRectMake(0, 100*HeightScale, 659*WidthScale, 1282*HeightScale) AndObject:self.subTitleArr AndStudentSubTitle:self.stuSubTitleArr];
        _pointView.delegate = self.pointViewDelegate;
    }
    return _pointView;
}

-(ZQTagList *)tagList{

    if (!_tagList) {
        _tagList = [[ZQTagList alloc]initWithFrame:CGRectMake(22*WidthScale, 110*HeightScale, 637*WidthScale, 1272*HeightScale)];
//        [_tagList setTags:self.linkArr];
        _tagList.delegate = self;

    }
    return _tagList;
}



@end