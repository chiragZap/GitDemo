//
//  JGExampleScrollableTableViewCell.m
//  JGScrollableTableViewCell Basic
//
//  Created by Jonas Gessner on 21.12.13.
//  Copyright (c) 2013 Jonas Gessner. All rights reserved.
//

#import "JGExampleScrollableTableViewCell.h"

@implementation JGExampleScrollableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setScrollViewBackgroundColor:[UIColor whiteColor]];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _actionView = [JGScrollableTableViewCellAccessoryButton button];
        
        self.actionView.frame = CGRectMake(0.0f, 0.0f,96.0f, 0.0f);
        
        self.actionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.actionView setImage:[UIImage imageNamed:@"delete_btn.png"] forState:UIControlStateNormal];
        
        _moreView = [JGScrollableTableViewCellAccessoryButton button];
        
       // [self.moreView setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
        
        self.moreView.frame = CGRectMake(56.0f, 0.0f, 0, 0.0f);
        self.moreView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     
        UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 96.0f, 0.0f)];
        [optionView addSubview:self.moreView];
        [optionView addSubview:self.actionView];
        
        [self setOptionView:optionView side:JGScrollableTableViewCellSideRight];
    }
    return self;
}

- (void)setGrabberVisible:(BOOL)visible {
    if (visible) {
        UIView *grabber = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {0.0f, 0.0f}}];
        
//        UIButton *btnDots = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnDots setImage:[UIImage imageNamed:@"cell_dots.png"] forState:UIControlStateNormal];
//        btnDots.frame = grabber.frame;
//        [grabber addSubview:btnDots];
        [self setGrabberView:grabber];
    }
    else {
        [self setGrabberView:nil];
    }
  
}



@end
