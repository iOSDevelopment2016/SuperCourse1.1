//
//  SCHistoryTableViewCell.m
//  SuperCourse
//
//  Created by 李昶辰 on 16/1/29.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCHistoryTableViewCell.h"
#import "SCPlayerViewController.h"


@interface SCHistoryTableViewCell()
- (IBAction)historyBtnClick:(id)sender;


@end




@implementation SCHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.historyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGFloat topImage=self.bounds.size.height*0.362;
//    CGFloat leftImage=self.bounds.size.width*0.027;
//    CGFloat widthImage=self.bounds.size.width*0.026;
//    CGFloat heighthImage=self.bounds.size.height*0.275;
//    CGFloat leftBtn=self.bounds.size.width*0.041;
//    CGFloat topBtn=self.bounds.size.height*0.275;
//    CGFloat widthBtn=self.bounds.size.width*0.359;
//    CGFloat heighthBtn=self.bounds.size.width*0.449;
//    CGFloat toplabel=self.bounds.size.width*0.275;
//    CGFloat leftLabel=self.bounds.size.width*0.209;
//    CGFloat widthLabel=self.bounds.size.width*0.312;
//    CGFloat heighthLabel=self.bounds.size.width*0.420;
//    self.topImage.constant=topImage;
//    self.leftImage.constant=leftImage;
//    self.widthImage.constant=widthImage;
//    self.heighthImage.constant=heighthImage;
//    self.leftBtn.constant=leftBtn;
//    self.topBtn.constant=topBtn;
//    self.widthBtn.constant=widthBtn;
//    self.heighthBtn.constant=heighthBtn;
//    self.leftLabel.constant=leftLabel;
//    self.topLabel.constant=toplabel;
//    self.widthLabel.constant=widthLabel;
//    self.heighthLabel.constant=heighthLabel;
}
#pragma - mark getters
-(UIButton *)historyBtn{
    _historyBtn.enabled = NO;
    return _historyBtn;
    
}
-(UILabel *)state{
    return _state;
}
#pragma  - mark click
- (IBAction)historyBtnClick:(UIButton *)sender {
//    NSInteger tag = sender.tag;
//    NSInteger secIndex = tag / 1000;
//    NSInteger rowIndex = tag - secIndex * 1000;
//    [self.delegate historyBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex ];
}






@end
