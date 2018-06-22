//
//  SWPopBubbleView.h
//  SWPopBubbleView
//
//  Created by Snail on 2018/6/12.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SWPopBubbleArrowDirection) {
    /**
     *  Up
     */
    SWPopBubbleArrowDirectionUp,
    /**
     *  Down
     */
    SWPopBubbleArrowDirectionDown,
    /**
     *  Left
     */
    SWPopBubbleArrowDirectionLeft,
    /**
     *  Right
     */
    SWPopBubbleArrowDirectionRight,
};

@interface SWPopBubbleView : UIView
- (instancetype) initWithSuperView:(UIView *)superView
                       contentView:(UIView *)contentView;
- (void)showWithAnglePoint:(CGPoint )anglePoint
                 direction:(SWPopBubbleArrowDirection)arrowDirection;


@property (nonatomic, strong)UIColor *borderColor;

@end
