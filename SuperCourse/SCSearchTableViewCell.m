//
//  SCSearchTableViewCell.m
//  SuperCourse
//
//  Created by 李昶辰 on 16/1/28.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCSearchTableViewCell.h"
#import "SCPlayerViewController.h"
@interface SCSearchTableViewCell()
//- (IBAction)searchBtnClick:(id)sender;


@end
@implementation SCSearchTableViewCell
-(void)layoutSubviews{
    CGFloat topImage=self.bounds.size.height*0.362;
    CGFloat leftImage=self.bounds.size.width*0.027;
    CGFloat widthImage=self.bounds.size.width*0.0232;
    CGFloat heighthImage=self.bounds.size.height*0.232;
    CGFloat topBtn=self.bounds.size.height*0.275;
    CGFloat leftBtn=self.bounds.size.width*0.047;
    CGFloat widthBtn=self.bounds.size.width*0.427;
    CGFloat heighthBtn=self.bounds.size.height*0.450;
    self.topImage.constant=topImage;
    self.leftImage.constant=leftImage;
//    self.widthImage.constant=widthImage;
//    self.heighthImage.constant=heighthImage;
    self.topBtn.constant=topBtn;
    self.leftBtn.constant=leftBtn;
    self.widthBtn.constant=widthBtn;
    self.heighthBtn.constant=heighthBtn;
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma - mark getters
-(UIButton *)searchBtn{
    return _searchBtn;
    
}
-(UILabel *)status{
    return _status;
}
#pragma  - mark click
//- (IBAction)searchBtnClick:(UIButton *)sender {
////    NSInteger tag = sender.tag;
////    NSInteger secIndex = tag / 1000;
////    NSInteger rowIndex = tag - secIndex * 1000;
////    [self.delegate searchBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex ];
//}





@end
