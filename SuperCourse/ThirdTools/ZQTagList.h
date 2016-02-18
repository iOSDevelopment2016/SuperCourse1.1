//
//  ZQTagList.h
//  yousheng
//
//  Created by Zery on 15/2/2.
//  Copyright (c) 2015年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQTagListDelegate <NSObject>

- (void)searchThis:(id)sender;

@end

@interface ZQTagList : UIView
{
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic, strong) UIView                    *view;
@property (nonatomic, assign) id <ZQTagListDelegate>    delegate;

- (void)setTags:(NSArray *)array;
- (void)displayWithLinkArr:(NSMutableArray *)linkArr;
- (CGSize)fittedSize;
- (void)changeBtnLookingWithTime:(NSTimeInterval)beginTime;

@end
