//
//  SCCourseTableViewCell.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCourseTableViewDelegate <NSObject>

- (IBAction)contendFieldDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
- (IBAction)imageBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
- (IBAction)downloadClickWithWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;

@end
@interface SCCourseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *contentField;

@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *courseLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;

@property (nonatomic ,weak) id<SCCourseTableViewDelegate> delegate;


@end
