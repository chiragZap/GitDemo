//
//  JGExampleScrollableTableViewCell.h
//  JGScrollableTableViewCell Basic
//
//  Created by Jonas Gessner on 21.12.13.
//  Copyright (c) 2013 Jonas Gessner. All rights reserved.
//

#import "JGScrollableTableViewCell.h"
#import "JGScrollableTableViewCellAccessoryButton.h"

@interface JGExampleScrollableTableViewCell : JGScrollableTableViewCell

- (void)setGrabberVisible:(BOOL)visible;
@property (nonatomic, retain) JGScrollableTableViewCellAccessoryButton *actionView;
@property (nonatomic, retain) JGScrollableTableViewCellAccessoryButton *moreView;
@end
