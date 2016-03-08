//
//  SCPointView.h
//  SuperCourse
//
//  Created by 孙锐 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCVideoSubTitleMode.h"
@protocol SCPointViewDelegate <NSObject>

-(void)turnToTime:(UIButton *)sender;

@end


@interface SCPointView : UIView

@property (nonatomic, strong) NSString *stuId;
@property (nonatomic, strong) NSString *stuPsw;
@property (nonatomic, strong) NSString *lessonId;

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *letterLabel;
@property (nonatomic, weak) id<SCPointViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame AndObject:(NSMutableArray *)subTitleArr AndStudentSubTitle:(NSMutableArray *)stuSubTitleArr;
- (void)changeSubTitleViewWithTime:(NSTimeInterval)elapsedTime;
- (NSString *)getCurrentSubTitle:(NSTimeInterval)elapsedTime;
- (void)createCellWithData:(NSMutableArray *)subTitleArr;
-(void)creatStudentSubTitleWithData:(NSMutableArray *)stuSubTitleArr;
- (UIView *)addCustomSubTitleWithData:(SCVideoSubTitleMode *)subTitle;
-(void)reloadSubTitlesWithObject:(NSMutableArray *)subTitleArr AndStudentSubTitle:(NSMutableArray *)stuSubTitleArr;
-(void)getCurrectOrder;
@end
