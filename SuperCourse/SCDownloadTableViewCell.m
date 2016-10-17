//
//  SCDownloadTableViewCell.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/4.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCDownloadTableViewCell.h"

@implementation SCDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTime:) name:@"sendTime" object:nil];
    self.example2 = [[THCircularProgressView alloc] initWithFrame:CGRectMake(520, self.height/2-30*HeightScale, 60*HeightScale, 60*HeightScale)];
    self.example2.lineWidth = 8.0f;
    self.example2.progressColor = [UIColor greenColor];
    self.example2.centerLabel.font = [UIFont boldSystemFontOfSize:40];
    self.example2.centerLabelVisible = YES;
    self.example2.percentage=ApplicationDelegate.pram;
    self.example2.progressColor=UIThemeColor;
    [self addSubview:self.example2];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.leadingSpacingConstrants.constant = 0.02*UIScreenWidth;
//    self.trailingSpacingConstrants.constant = 0.03*UIScreenWidth;
    
    

    // [self.examples addObject:self.example2];
    
    //出界面了再完善
    //[self.example2 setHidden:YES];
}

-(void)play:(UIImageView *)sender{
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    //[self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate playClick:secIndex AndRowIndex:rowIndex];
}
-(void)delete:(UIImageView *)sender{
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    // [self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate deleteClick:secIndex AndRowIndex:rowIndex];
}

-(void)showTime:(NSNotification *)time{
    self.example2.percentage = [time.userInfo[@"time"]floatValue];
    //    if((self.example2.percentage=1)){
    //        [self.example2 setHidden:YES];
    //        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(1000*WidthScale, 20*HeightScale, 50*HeightScale, 50*HeightScale)];
    //        label.text=@"下载完成";
    //        [self addSubview:label];
    //    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendTime" object:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playBtnClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    //[self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate playClick:secIndex AndRowIndex:rowIndex];
    
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
   // [self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate deleteClick:secIndex AndRowIndex:rowIndex];
    
}

- (IBAction)pauseBtnClick:(id)sender {
//    if(_pauseBtn.selected==NO){
//        [_pauseBtn setTitle:@"继续下载" forState:UIControlStateNormal];
//        _pauseBtn.selected=YES;
//        [self.delegate pause];
//    }else{
//        [_pauseBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
//        _pauseBtn.selected=NO;
//        [self.delegate continueToDownload];
//        
//    }
    if([[_pauseBtn titleForState:UIControlStateNormal] isEqualToString:@"继续下载"]){
        [_pauseBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
        
        [self.delegate continueToDownload];
    }else if([[_pauseBtn titleForState:UIControlStateNormal] isEqualToString:@"暂停下载"]){
        [_pauseBtn setTitle:@"继续下载" forState:UIControlStateNormal];
        
        [self.delegate pause];
    }
}

- (IBAction)playImageClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    //[self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate playClick:secIndex AndRowIndex:rowIndex];
}

- (IBAction)deleteImageBtnClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    // [self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
    [self.delegate deleteClick:secIndex AndRowIndex:rowIndex];

}

//-(UIButton *)pauseBtn{
//    if(_pauseBtn.selected==NO){
//        [_pauseBtn setTitle:@"暂停下载" forState:UIControlStateNormal];
//    }else{
//        [_pauseBtn setTitle:@"继续下载" forState:UIControlStateNormal];
//    }
//    return _pauseBtn;
//}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (IS_IPHONE) {
        self.videoName.frame = CGRectMake(0.0306*UIScreenWidth, 0.021*UIScreenHeight, 0.43*UIScreenWidth, 0.02*UIScreenWidth);
        self.videoName.font = FONT_21;
        self.videoSize.frame = CGRectMake(0.7*UIScreenWidth, 0.021*UIScreenHeight, 0.1*UIScreenWidth, 0.02*UIScreenWidth);
        self.videoSize.font = FONT_21;
        self.completeLabel.frame = CGRectMake(UIScreenWidth/2-100*HeightScale, 0.021*UIScreenHeight, 0.1*UIScreenWidth, 0.02*UIScreenWidth);
        self.completeLabel.font = FONT_21;
        self.circle1.frame = CGRectMake(UIScreenWidth/2-250*HeightScale, 0.0246*UIScreenHeight, 0.0228*UIScreenWidth, 0.0228*UIScreenWidth);
        self.pauseBtn.frame = CGRectMake(UIScreenWidth/2+170*HeightScale, 0.021*UIScreenHeight, 0.1*UIScreenWidth, 0.02*UIScreenWidth);
        self.pauseBtn.titleLabel.font = FONT_21;
        self.videoSize.textAlignment = NSTextAlignmentLeft;
        self.playImageBtn.frame = CGRectMake(UIScreenWidth-520*HeightScale, 0.0296*UIScreenHeight, 0.0128*UIScreenWidth, 0.0128*UIScreenWidth);
        self.deleteImageBtn.frame =CGRectMake(UIScreenWidth-280*HeightScale, 0.0296*UIScreenHeight, 0.0128*UIScreenWidth, 0.0128*UIScreenWidth);
        self.playBtn.frame = CGRectMake(UIScreenWidth-470*HeightScale, 0.0296*UIScreenHeight, 150*HeightScale, 0.0128*UIScreenWidth);
        self.playBtn.titleLabel.font = FONT_21;
        self.deleteBtn.frame = CGRectMake(UIScreenWidth-230*HeightScale, 0.0296*UIScreenHeight, 150*HeightScale, 0.0128*UIScreenWidth);
        self.deleteBtn.titleLabel.font = FONT_21;
        self.program.frame = CGRectMake(UIScreenWidth/2-250*HeightScale, 0.021*UIScreenHeight, 0.1*UIScreenWidth, 0.02*UIScreenWidth);
        self.program.font = FONT_21;
        self.example2.frame = CGRectMake(UIScreenWidth/2+50*HeightScale,  0.021*UIScreenHeight, 60*HeightScale, 60*HeightScale);
        

    }
}

//-(UIImageView *)circle2{
//    if(!_circle2){
//        _circle2=[[UIImageView alloc]init];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuesture)];
//        [_circle2 addGestureRecognizer:tap];
//    }
//    return _circle2;
//}
//-(UIImageView *)circle2{
//    if(!_circle2){
//        _circle2=[[UIImageView alloc]init];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuesture)];
//        [_circle2 addGestureRecognizer:tap];
//    }
//    return _circle2;
//}
@end
