//
//  SCExtendView.h
//  SuperCourse
//
//  Created by 刘芮东 on 16/2/2.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCIntroductionDataSource.h"
#import "SCIntroduction.h"
#import "SCKnowledge.h"
#import "SCWillLearn.h"


@protocol SCExtendViewDelegate <NSObject>

-(void)returnToMainView;
//-(NSString *)getTitle;

@end

@interface SCExtendView : UIView
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic,strong) id<SCExtendViewDelegate> delegate;

//@property (nonatomic ,strong)NSString *title;
//@property (nonatomic ,strong) SCIntroductionDataSource *datasource;
- (instancetype)initWithString:(NSString *)title AndDataSource:(SCIntroductionDataSource *)datasource AndWidth:(float)width AndHeight:(float)height;
@end
