//
//  SettingsViewController.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>


@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *table;
}

- (IBAction)btnBackPressed:(id)sender;

@end
