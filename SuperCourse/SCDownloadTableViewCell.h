//
//  SCDownloadTableViewCell.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/4.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDownloadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *videoName;
@property (strong, nonatomic) IBOutlet UILabel *videoSize;
@property (strong, nonatomic) IBOutlet UILabel *completeLabel;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)playBtnClick:(id)sender;
- (IBAction)deleteBtnClick:(id)sender;

@end
