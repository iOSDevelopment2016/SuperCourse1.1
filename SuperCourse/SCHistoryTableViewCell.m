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
    [super layoutSubviews];
    [self measureTheFrameOfScreen];
}
#pragma - mark getters
-(UIButton *)historyBtn{
    _historyBtn.enabled = NO;
    return _historyBtn;
    
}

-(UIImageView *)roundImg{

    return _roundImg;
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


-(void)measureTheFrameOfScreen{
    
    if (IS_IPHONE) {
        //getIphoneFrame
        NSLog(@"iphone");
        [self getIphoneFrame];
    }else{
        //getIpadFrame
        NSLog(@"ipad");
        [self getIpadFrame];
    }
}

-(void)getIphoneFrame{
    
    self.roundImg.frame = CGRectMake(0.0195*UIScreenWidth, 0.02*UIScreenWidth, 0.0228*UIScreenWidth, 0.0228*UIScreenWidth);
    self.historyBtn.frame = CGRectMake(0.0706*UIScreenWidth, 0.016*UIScreenWidth, 0.43*UIScreenWidth, 0.03*UIScreenWidth);
    self.historyBtn.titleLabel.font = [UIFont systemFontOfSize:0.0228*UIScreenWidth];
    self.state.frame = CGRectMake(0.5*UIScreenWidth, 0.016*UIScreenWidth, 0.2*UIScreenWidth, 0.03*UIScreenWidth);
    self.state.font =  [UIFont systemFontOfSize:0.0228*UIScreenWidth];
}

-(void)getIpadFrame{

    self.roundImg.frame = CGRectMake(0.0195*UIScreenWidth, 0.023*UIScreenWidth, 0.0228*UIScreenWidth, 0.0228*UIScreenWidth);
    self.historyBtn.frame = CGRectMake(0.0706*UIScreenWidth, 0.019*UIScreenWidth, 0.43*UIScreenWidth, 0.03*UIScreenWidth);
    self.historyBtn.titleLabel.font =[UIFont systemFontOfSize:0.0228*UIScreenWidth];
    self.state.frame = CGRectMake(0.599*UIScreenWidth, 0.019*UIScreenWidth, 0.104*UIScreenWidth, 0.03*UIScreenWidth);
    self.state.font =  [UIFont systemFontOfSize:0.0228*UIScreenWidth];
    
}

@end
