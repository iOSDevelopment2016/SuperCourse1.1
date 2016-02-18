//
//  ZQTagList.m
//  yousheng
//
//  Created by Zery on 15/2/2.
//  Copyright (c) 2015年 张洋. All rights reserved.
//

#import "ZQTagList.h"
#import "SCVideoLinkMode.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 0.0f
#define LABEL_MARGIN 7.0f
#define BOTTOM_MARGIN 14.0f
#define HORIZONTAL_PADDING 14.0f
#define VERTICAL_PADDING 8.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR UIColorFromRGB(0x666666)
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR UIColorFromRGB(0xcccccc).CGColor
#define BORDER_WIDTH 0.5f

@interface ZQTagList ()
@property (nonatomic, strong) NSMutableArray *linkArr;
@end

@implementation ZQTagList
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:_view];
    }
    return self;
}

- (void)setTags:(NSMutableArray *)linkArr
{
    sizeFit = CGSizeZero;
    self.linkArr = linkArr;
    [self displayWithLinkArr:linkArr];
}

- (void)setLabelBackgroundColor:(UIColor *)color AndLinkArr:(NSMutableArray *)linkArr
{
    lblBackgroundColor = color;
    self.linkArr = linkArr;
    [self displayWithLinkArr:linkArr];
}

- (void)displayWithLinkArr:(NSMutableArray *)linkArr
{
    for (UILabel *subview in [self subviews]) {
        
        [subview removeFromSuperview];
        
    }
    
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    CGSize boundSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);

    for (int i=0; i<linkArr.count; i++) {
        
        SCVideoLinkMode *m = linkArr[i];
        
        NSString *text = m.hot_title;
        CGSize textSize =  [text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:45],NSFontAttributeName, nil] context:nil].size;
        
        textSize.width += HORIZONTAL_PADDING * 2;
        textSize.height += VERTICAL_PADDING * 2;

        UIButton *button = nil;
        [button.layer setBorderWidth:3];
        button.selected = NO;
        if (!gotPreviousFrame) {
            
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
            
        } else {
            
            CGRect newRect = CGRectZero;
            
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
                
            } else {
                
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                
            }
            
            newRect.size = textSize;
            button = [[UIButton alloc] initWithFrame:newRect];
        }
       
        previousFrame = button.frame;
        gotPreviousFrame = YES;

        button.titleLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        button.titleLabel.backgroundColor = [UIColor whiteColor];
        
        if (!lblBackgroundColor) {

            [button setBackgroundColor:[UIColor whiteColor]];
            
        } else {
            
            [button setBackgroundColor:lblBackgroundColor];
            
        }
        
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button.layer setMasksToBounds:YES];
        
        [button.layer setCornerRadius:CORNER_RADIUS];
        [button.layer setBorderColor:[UIColor clearColor].CGColor];
        [button.layer setBorderWidth: 2];
        
        [button addTarget:self action:@selector(searchButtonClicke:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);

}
- (void)changeBtnLookingWithTime:(NSTimeInterval)beginTime{
    
    for (UIButton *btn in self.subviews) {
        SCVideoLinkMode *currentLink = self.linkArr[btn.tag];
        int linkBeginTime = currentLink.bg_time;
        if (linkBeginTime == (int)beginTime) {
            if (btn.titleLabel.textColor == [UIColor blackColor]) {
                [self clearBtnLooking];
                btn.titleLabel.textColor = UIThemeColor;
                [btn.layer setBorderColor:UIThemeColor.CGColor];
            }
        }
    }
}

- (void)clearBtnLooking{
    
    for (UIButton *btn in self.subviews) {
        btn.titleLabel.textColor = [UIColor blackColor];
        [btn.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}


- (void)searchButtonClicke:(UIButton *)sender {
    
    [self clearBtnLooking];
    sender.selected = YES;
    [sender setTitleColor:UIThemeColor forState:UIControlStateSelected];
    sender.layer.borderColor = UIThemeColor.CGColor;
    
    SCVideoLinkMode *link = self.linkArr[sender.tag];
    [self.delegate searchThis:link];
    
}

- (CGSize)fittedSize {
    
    return sizeFit;
    
}

@end
