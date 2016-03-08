//
//  SCHistoryTableViewCell.h
//  SuperCourse
//
//  Created by 李昶辰 on 16/1/29.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol SCHistoryTableViewDelegate <NSObject>

- (IBAction)historyBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;


@end

@interface SCHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *historyBtn;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (nonatomic ,weak) id<SCHistoryTableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heighthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heighthBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heighthLabel;


@end
