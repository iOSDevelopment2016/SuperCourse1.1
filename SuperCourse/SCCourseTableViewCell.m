//
//  SCCourseTableViewCell.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCCourseTableViewCell.h"
#import "SCPlayerViewController.h"
@interface SCCourseTableViewCell ()

- (IBAction)contendFieldClick:(id)sender;
- (IBAction)imageBtnClick:(id)sender;
- (IBAction)downloadBtnClick:(id)sender;


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *examples;
@property (nonatomic) CGFloat percentage;
@property (nonatomic ,strong) THCircularProgressView *example;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *circleHeightConstraint;


@end
@implementation SCCourseTableViewCell



- (void)awakeFromNib {
    // Initialization code
    
    //    self.fileSizeLabel.backgroundColor = [UIColor orangeColor];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTime:) name:@"sendTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(toRefresh)
                                                 name: @"releaseClick"
                                               object: nil];
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
    //                                                  target:self
    //                                                selector:@selector(timerFired:)
    //                                                userInfo:nil
    //                                                 repeats:YES];
    //    self.examples = [[NSMutableArray alloc] init];
    
    
    self.courseLabel.font = FONT_25;
    self.contentField.titleLabel.font = FONT_27;
    
    self.example2 = [[THCircularProgressView alloc] initWithFrame:CGRectMake(1000*WidthScale, 20*HeightScale, 50*HeightScale, 50*HeightScale)];
    self.example2.lineWidth = 8.0f;
    self.example2.progressColor = [UIColor greenColor];
    self.example2.centerLabel.font = [UIFont boldSystemFontOfSize:40];
    self.example2.centerLabelVisible = YES;
    
    //[self addSubview:self.example2];
    // [self.examples addObject:self.example2];
    [self.example2 setHidden:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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

//- (void)timerFired:(NSTimer *)timer
//{
//    self.percentage += 0.005;
//    if (self.percentage >= 1) {
//        self.percentage = 0;
//    }
//
////    for (THCircularProgressView* progressView in self.examples) {
//        self.example2.percentage = self.percentage;
//  //  }
//}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // tap to change size
    
    //    static BOOL originalSize = YES;
    //    CGFloat multiplier = 0.5f;
    //    if (!originalSize) {
    //        multiplier = 2.0f;
    //    }
    //    originalSize = !originalSize;
    //
    //
    //    for (THCircularProgressView *view in self.examples) {
    //        CGRect frame = view.frame;
    //        frame.size.width = CGRectGetWidth(view.frame) * multiplier;
    //        frame.size.height = CGRectGetHeight(view.frame) * multiplier;
    //        view.frame = frame;
    //    }
}

#pragma - mark getters
-(UIButton *)contentField{
    return _contentField;
}
-(UIButton *)imageBtn{
    
    return _imageBtn;
}
-(UILabel *)courseLabel{
    return _courseLabel;
}

-(UIButton *)downloadBtn{
    return _downloadBtn;
}
-(UILabel *)beDownloadingLabel{
    return _beDownloadingLabel;
}
#pragma - mark click

// 点击课程名称
- (IBAction)contendFieldClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    [self.delegate contendFieldDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex ];
}

// 点击课程详情
- (IBAction)imageBtnClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    NSInteger secIndex = tag / 1000;
    NSInteger rowIndex = tag - secIndex * 1000;
    if(self.imageBtn.selected==NO){
        self.imageBtn.selected=YES;
        [self.delegate imageBtnDidClickWithSectionIndex:secIndex AndRowIndex:rowIndex];
        
        //self.imageBtn.selected=NO;
    }
    
    
}

// 点击下载
- (IBAction)downloadBtnClick:(UIButton *)sender {
    
//    if(_downloadBtn.selected==0){
//        _downloadBtn.selected=YES;
        NSInteger tag = sender.tag;
        NSInteger secIndex = tag / 1000;
        NSInteger rowIndex = tag - secIndex * 1000;
        [self.example2 setHidden:NO];
        [self.delegate downloadClickWithWithSectionIndex:secIndex AndRowIndex:rowIndex];
//    }else{
//        [self.delegate postDownload];
//    }
}
-(void)toRefresh{
    self.imageBtn.selected=NO;
}
@end
