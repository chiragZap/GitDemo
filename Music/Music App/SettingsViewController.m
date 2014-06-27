//
//  SettingsViewController.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, retain) NSMutableArray *arrOptions;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrOptions = [[NSMutableArray alloc] initWithObjects:@"Share App",@"Feedback/Support", nil];
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anyCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"anyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [self.arrOptions objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Email", nil];
        [actSheet showInView:self.view];
        
    }
    else if(indexPath.row == 1) {
        MFMailComposeViewController *picker=[[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate=self;
        [picker setSubject:@""];
        [picker setToRecipients:[NSArray arrayWithObject:@""]];
        [picker setMessageBody:@"" isHTML:NO];
        [self presentViewController:picker animated:YES completion:nil];

    }
}

#pragma mark - Share

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    if(buttonIndex == 0) { // Facebook
        [self ShareMessageON:SLServiceTypeFacebook With:@"" URL:APP_URL image:[UIImage imageNamed:@"go_midimg_btn"] on:self];
    }
    else if(buttonIndex == 1) { // Twitter
         [self ShareMessageON:SLServiceTypeTwitter With:@"" URL:APP_URL image:[UIImage imageNamed:@"go_midimg_btn"] on:self];
    }
    else { // Email
        UIImage *image = [UIImage imageNamed:@"go_midimg_btn"];
        MFMailComposeViewController *picker=[[MFMailComposeViewController alloc] init];
        NSData *imgData=UIImageJPEGRepresentation(image, 1.0);
        [picker addAttachmentData:imgData mimeType:@"image/jpeg" fileName:@"yodeme.jpeg"];
        picker.mailComposeDelegate=self;
        
        [picker setMessageBody:@"" isHTML:NO];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)ShareMessageON:(NSString*)service With:(NSString*)messsage URL:(NSString*)url image:(UIImage*)image on:(id)controller {
    SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:service];
    
    //if([SLComposeViewController isAvailableForServiceType:service])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=
        ^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default: {
                     break;
                }
                case SLComposeViewControllerResultDone: {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Posted" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    break;
                }
            }};
        
        [fbController addImage:image];
        [fbController setInitialText:messsage];
        [fbController addURL:[NSURL URLWithString:url]];
        [fbController setCompletionHandler:completionHandler];
        [controller presentViewController:fbController animated:YES completion:nil];
    }
    //    else{
    //        UIAlertView *alrView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Set Credentials in Settings" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
    //        [alrView show];
    //    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end