//
//  SCSearchTableViewCell.h
//  SuperCourse
//
//  Created by 李昶辰 on 16/1/28.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SCSearchTableViewDelegate <NSObject>

- (IBAction)searchBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;


@end




@interface SCSearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (nonatomic ,weak) id<SCSearchTableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heighthImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heighthBtn;


@end
