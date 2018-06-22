//
//  ViewController.m
//  SWPopBubbleView
//
//  Created by Snail on 2018/6/12.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import "ViewController.h"
#import "SWPopBubbleView.h"


@interface ViewController ()

@end

@implementation ViewController {
    SWPopBubbleView *ss;
    UIView *view1 ;
    UILabel *ll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
    ll = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 100)];
    ll.numberOfLines = 2;
    ll.text = @"2222";
    [view1 addSubview:ll];
    ss = [[SWPopBubbleView alloc] initWithSuperView:self.view contentView:view1];
    ss.borderColor = [UIColor orangeColor];
    ss.backgroundColor = [UIColor yellowColor];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    CGPoint tapPoint = [touche locationInView:self.view];
    ll.text = [NSString stringWithFormat:@"x:%.2f\ny:%.2f",tapPoint.x,tapPoint.y];
    [ss showWithAnglePoint:CGPointMake(tapPoint.x, tapPoint.y -80) direction:SWPopBubbleArrowDirectionDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
