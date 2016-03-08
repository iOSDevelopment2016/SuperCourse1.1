//
//  SCDownloadTableViewCell.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/4.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCircularProgressView.h"

@protocol SCDownloadTableViewCellDelegate <NSObject>

-(void)pause;
-(void)continueToDownload;
- (IBAction)playClick:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
- (IBAction)deleteClick:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex;
@end



@interface SCDownloadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *videoName;
@property (strong, nonatomic) IBOutlet UILabel *videoSize;
@property (strong, nonatomic) IBOutlet UILabel *completeLabel;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *pauseBtn;
@property (strong, nonatomic) IBOutlet UIButton *playImageBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteImageBtn;
- (IBAction)playBtnClick:(id)sender;
- (IBAction)deleteBtnClick:(id)sender;
- (IBAction)pauseBtnClick:(id)sender;
- (IBAction)playImageClick:(id)sender;
- (IBAction)deleteImageBtnClick:(id)sender;
@property (nonatomic,strong) THCircularProgressView *example2;
@property (strong, nonatomic) IBOutlet UIImageView *circle1;
@property (strong, nonatomic) IBOutlet UILabel *program;
@property (nonatomic, weak) id<SCDownloadTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSString *lessonID;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingSpacingConstrants;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingSpacingConstrants;

@end
