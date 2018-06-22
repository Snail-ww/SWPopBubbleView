//
//  SWPopBubbleView.m
//  SWPopBubbleView
//
//  Created by Snail on 2018/6/12.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import "SWPopBubbleView.h"

#define SWPopBubbleArrowWidth             8.f
#define SWPopBubbleArrowHeight            10.f
#define SWPopBubbleBGLayerRadius          4.f

#define scale(Long, ContentLong, SuperLong) (Long -SWPopBubbleBGLayerRadius -SWPopBubbleArrowWidth)*(ContentLong-2 *(SWPopBubbleBGLayerRadius +SWPopBubbleArrowWidth))/(SuperLong -2 *(SWPopBubbleBGLayerRadius +SWPopBubbleArrowWidth))



//typedef NS_ENUM(NSUInteger, SWPopBubbleArrowStyle) {
//    SWPopBubbleArrowStyleNormal,    // 正常箭头
//    SWPopBubbleArrowStyleLeftHalf, // 左半箭头
//    SWPopBubbleArrowStyleRightHalf,
//    SWPopBubbleArrowStyleTopHalf,
//    SWPopBubbleArrowStyleBottomHalf,
//};


@interface SWPopBubbleView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) SWPopBubbleArrowDirection arrowDirection;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIView *contentView;
//@property (nonatomic, assign) BOOL allowRoundedArrow;

@end
@implementation SWPopBubbleView


- (instancetype) initWithSuperView:(UIView *)superView
                       contentView:(UIView *)contentView{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _superView = superView;
        _contentView = contentView;
        self.bounds = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
        contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
        [superView addSubview:self];
        [self addSubview:contentView];
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
    }
    return self;
}


- (void)showWithAnglePoint:(CGPoint )anglePoint
                 direction:(SWPopBubbleArrowDirection)arrowDirection
{
    
    if (!_superView) {
        return;
    }
    if (!_contentView) {
        return;
    }
    _arrowDirection = arrowDirection;
    switch (_arrowDirection) {
        case SWPopBubbleArrowDirectionUp:
            if (anglePoint.x<SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius) {
                self.frame = CGRectMake(anglePoint.x, anglePoint.y, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            } else if (anglePoint.x>_superView.frame.size.width -(SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius)) {
                self.frame = CGRectMake(anglePoint.x -_contentView.frame.size.width, anglePoint.y, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            } else {
                self.frame = CGRectMake(anglePoint.x-scale(anglePoint.x, _contentView.frame.size.width, _superView.frame.size.width) -SWPopBubbleArrowWidth - SWPopBubbleBGLayerRadius, anglePoint.y, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            }
            break;
        case SWPopBubbleArrowDirectionDown:
            if (anglePoint.x<SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius) {
                self.frame = CGRectMake(anglePoint.x, anglePoint.y -_contentView.frame.size.height -SWPopBubbleArrowHeight, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            } else if (anglePoint.x>_superView.frame.size.width -(SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius)) {
                self.frame = CGRectMake(anglePoint.x -_contentView.frame.size.width, anglePoint.y -_contentView.frame.size.height -SWPopBubbleArrowHeight, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            } else {
                self.frame = CGRectMake(anglePoint.x-scale(anglePoint.x, _contentView.frame.size.width, _superView.frame.size.width) -SWPopBubbleArrowWidth - SWPopBubbleBGLayerRadius, anglePoint.y -_contentView.frame.size.height -SWPopBubbleArrowHeight, _contentView.frame.size.width, _contentView.frame.size.height +SWPopBubbleArrowHeight);
            }
            break;
//        case SWPopBubbleArrowDirectionLeft:
//            if (anglePoint.y<SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius) {
//                self.frame = CGRectMake(anglePoint.x -contentView.frame.size.width -SWPopBubbleArrowHeight, anglePoint.y, contentView.frame.size.width +SWPopBubbleArrowHeight, contentView.frame.size.height);
//            } else if (anglePoint.y>superView.frame.size.width -(SWPopBubbleArrowWidth +SWPopBubbleBGLayerRadius)) {
//                self.frame = CGRectMake(anglePoint.x -contentView.frame.size.width, anglePoint.y -contentView.frame.size.height, contentView.frame.size.width, contentView.frame.size.height +SWPopBubbleArrowHeight);
//            } else {
//                self.frame = CGRectMake(anglePoint.x-scale(anglePoint.x, contentView.frame.size.width, superView.frame.size.width) -SWPopBubbleArrowWidth - SWPopBubbleBGLayerRadius, anglePoint.y -contentView.frame.size.height -SWPopBubbleArrowHeight, contentView.frame.size.width, contentView.frame.size.height +SWPopBubbleArrowHeight);
//            }
//            break;
        default:
            break;
    }
    
    
    CGPoint arrawPoint = CGPointMake(anglePoint.x -self.frame.origin.x, anglePoint.y -self.frame.origin.y);        // 相对本视图的焦点
    
    [self drawBackgroundLayerWithArrowPoint:arrawPoint];
    [UIView animateWithDuration:3
                     animations:^{
                         self.alpha = 1;
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}


-(void)drawBackgroundLayerWithArrowPoint:(CGPoint)arrowPoint
{
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }
    CGPoint anglePoint = arrowPoint;
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (_arrowDirection) {
        case SWPopBubbleArrowDirectionUp:{
            [path moveToPoint:anglePoint];
            if (anglePoint.x == 0) {
                
            } else {
                [path addLineToPoint:CGPointMake(anglePoint.x - SWPopBubbleArrowWidth, SWPopBubbleArrowHeight)];
                [path addLineToPoint:CGPointMake(SWPopBubbleBGLayerRadius, SWPopBubbleArrowHeight)];
                [path addArcWithCenter:CGPointMake(SWPopBubbleBGLayerRadius, SWPopBubbleArrowHeight +SWPopBubbleBGLayerRadius) radius:SWPopBubbleBGLayerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            }
            [path addLineToPoint:CGPointMake(0, self.frame.size.height -SWPopBubbleBGLayerRadius)];
            [path addArcWithCenter:CGPointMake(SWPopBubbleBGLayerRadius, self.bounds.size.height - SWPopBubbleBGLayerRadius) radius:SWPopBubbleBGLayerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - SWPopBubbleBGLayerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - SWPopBubbleBGLayerRadius, self.bounds.size.height - SWPopBubbleBGLayerRadius) radius:SWPopBubbleBGLayerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            if (anglePoint.x != self.frame.size.width) {
                [path addLineToPoint:CGPointMake(self.bounds.size.width , SWPopBubbleBGLayerRadius + SWPopBubbleArrowHeight)];
                [path addArcWithCenter:CGPointMake(self.bounds.size.width - SWPopBubbleBGLayerRadius, SWPopBubbleBGLayerRadius + SWPopBubbleArrowHeight) radius:SWPopBubbleBGLayerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x +SWPopBubbleArrowWidth , SWPopBubbleArrowHeight)];
            }
            [path closePath];
            
        }break;
        case SWPopBubbleArrowDirectionDown:{
            [path moveToPoint:anglePoint];
            if (anglePoint.x != 0) {
                [path addLineToPoint:CGPointMake(anglePoint.x - SWPopBubbleArrowWidth, self.frame.size.height -SWPopBubbleArrowHeight)];
                [path addLineToPoint:CGPointMake(SWPopBubbleBGLayerRadius, self.frame.size.height -SWPopBubbleArrowHeight)];
                [path addArcWithCenter:CGPointMake(SWPopBubbleBGLayerRadius, self.frame.size.height -(SWPopBubbleArrowHeight +SWPopBubbleBGLayerRadius)) radius:SWPopBubbleBGLayerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            }
            [path addLineToPoint:CGPointMake(0, SWPopBubbleBGLayerRadius)];
            [path addArcWithCenter:CGPointMake(SWPopBubbleBGLayerRadius, SWPopBubbleBGLayerRadius) radius:SWPopBubbleBGLayerRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - SWPopBubbleBGLayerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - SWPopBubbleBGLayerRadius, SWPopBubbleBGLayerRadius) radius:SWPopBubbleBGLayerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            if (anglePoint.x != self.frame.size.width) {
                [path addLineToPoint:CGPointMake(self.bounds.size.width , self.frame.size.height -(SWPopBubbleBGLayerRadius + SWPopBubbleArrowHeight))];
                [path addArcWithCenter:CGPointMake(self.bounds.size.width - SWPopBubbleBGLayerRadius, self.frame.size.height -(SWPopBubbleBGLayerRadius + SWPopBubbleArrowHeight)) radius:SWPopBubbleBGLayerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x +SWPopBubbleArrowWidth , self.frame.size.height -SWPopBubbleArrowHeight)];
            }
            [path closePath];
            
        }break;
//        case FTPopOverMenuArrowDirectionDown:{
//            
//            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);
//            
//            if (allowRoundedArrow) {
//                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*FTDefaultMenuArrowRoundRadius) radius:2.f*FTDefaultMenuArrowRoundRadius startAngle:M_PI_2*3 endAngle:M_PI_4*5.f clockwise:NO];
//                [path addLineToPoint:CGPointMake(anglePoint.x + FTDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y + FTDefaultMenuArrowRoundRadius/sqrtf(2.f))];
//                [path addArcWithCenter:roundcenterPoint radius:FTDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_4*3.f clockwise:YES];
//                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), anglePoint.y - self.menuArrowHeight + offset/sqrtf(2.f))];
//                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*FTDefaultMenuArrowRoundRadius) radius:2.f*FTDefaultMenuArrowRoundRadius startAngle:M_PI_4*7 endAngle:M_PI_2*3 clockwise:NO];
//            } else {
//                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
//                [path addLineToPoint:anglePoint];
//                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
//            }
//            
//            [path addLineToPoint:CGPointMake( FTDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight)];
//            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight - FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
//            [path addLineToPoint:CGPointMake( 0, FTDefaultMenuCornerRadius)];
//            [path addArcWithCenter:CGPointMake(FTDefaultMenuCornerRadius, FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
//            [path addLineToPoint:CGPointMake( self.bounds.size.width - FTDefaultMenuCornerRadius, 0)];
//            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, FTDefaultMenuCornerRadius) radius:FTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
//            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (FTDefaultMenuCornerRadius + self.menuArrowHeight))];
//            [path addArcWithCenter:CGPointMake(self.bounds.size.width - FTDefaultMenuCornerRadius, anglePoint.y - (FTDefaultMenuCornerRadius + self.menuArrowHeight)) radius:FTDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
//            [path closePath];
//            
//        }break;
        default:
            break;
    }
    self.backgroundLayer.path = path.CGPath;
    [self.layer insertSublayer:self.backgroundLayer atIndex:0];
}

- (CAShapeLayer *)backgroundLayer {
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.lineWidth = 1;
        _backgroundLayer.fillColor = [UIColor redColor].CGColor;
        _backgroundLayer.strokeColor = [UIColor cyanColor].CGColor;
    }
    return _backgroundLayer;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundLayer.fillColor = backgroundColor.CGColor;
    [super setBackgroundColor:[UIColor clearColor]];
}

@end
