//
//  SCSearchView.h
//  SuperCourse
//
//  Created by Develop on 16/1/23.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SClesson_list.h"
#import "SCCourse.h"
@protocol SCSearchViewDelegate <NSObject>
-(void)searchDidClick:(NSString *)les_id ;
-(void)viewmove:(CGFloat) variety andUIView:(UIView *)scrollSearchView;
-(void)videoPlayClickWithCourse:(SCCourse *)SCcourse;
@end


@interface SCSearchView : UIView

@property (nonatomic ,weak) id<SCSearchViewDelegate> delegate;
@property (nonatomic,strong)NSString *keyWord;
@property (nonatomic,strong)UIViewController *viewController;

-(void)loadCourseListFromNetwork;

@end
