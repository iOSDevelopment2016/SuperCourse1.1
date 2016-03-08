//
//  SCCourseTableViewCell.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/1/25.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCircularProgressView.h"

@protocol SCCourseTableViewDelegate <NSObject>

- (IBAction)contendFieldDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
- (IBAction)imageBtnDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
- (IBAction)downloadClickWithWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
-(void)postDownload;
@end
@interface SCCourseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *contentField;

@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *courseLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UILabel *courseLabel;

@property (nonatomic ,weak) id<SCCourseTableViewDelegate> delegate;

@property (nonatomic,strong) THCircularProgressView *example2;
@property (strong, nonatomic) IBOutlet UILabel *beDownloadingLabel;


@end
