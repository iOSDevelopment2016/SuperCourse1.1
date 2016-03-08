//
//  SCVideoHistoryView.h
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCHistoryViewDelegate <NSObject>
//contendFieldDidClickWithSectionIndex:(NSInteger)secIndex AndRowIndex:(NSInteger)rowIndex

-(void)historyDidClick:(NSString *)les_id;

@end

@interface SCVideoHistoryView : UIView
@property (nonatomic ,weak) id<SCHistoryViewDelegate> delegate;
@property (nonatomic ,strong) UIViewController *viewController;


@end
