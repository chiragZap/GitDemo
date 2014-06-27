//
//  PlayListViewController.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "PlayListViewController.h"
#import "SongListViewController.h"
#import "CountDownViewController.h"

@interface PlayListViewController ()
@property (nonatomic, retain) NSMutableArray *arrPlayList;
@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedDelegate];
    
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    
    if(self.isFromFav) {
        self.arrPlayList = [[NSMutableArray alloc] init];
        self.imgCenter.image = [UIImage imageNamed:@"favorite_top_icon.png"];
        
        for (MPMediaPlaylist *playList in [myPlaylistsQuery collections]) {
            NSString *playlistID = [playList valueForProperty: MPMediaPlaylistPropertyPersistentID];
            if([appDelegate.arrFav containsObject:playlistID]) {
                [self.arrPlayList addObject:playList];
            }
        }
    }
    else {
        self.rightView.hidden = TRUE;
        self.arrPlayList = [[NSMutableArray alloc] initWithArray: [myPlaylistsQuery collections]];
    }
}

#pragma  mark - Button events
-(IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnClearAllPressed {
    UIAlertView *alrView = [[UIAlertView alloc] initWithTitle:@"Confrim" message:@"Are you sure you want to remove all playlist from Favourite ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    [alrView show];
}
#pragma mark - TalbeView Delegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isFromFav) {
        if([self.arrPlayList count] == 0) {
            self.lblNoData.hidden = FALSE;
            self.rightView.hidden = TRUE;
        }
        else {
            self.lblNoData.hidden = TRUE;
            self.rightView.hidden = FALSE;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrPlayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anyCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"anyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgArtWork = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 80)];
        imgArtWork.tag = 1;
        imgArtWork.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgArtWork];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd addTarget:self action:@selector(didSelectItemAt:event:) forControlEvents:UIControlEventTouchUpInside];
        btnAdd.tag = 2;
        if(self.isFromFav) {
            [btnAdd setImage:[UIImage imageNamed:@"go_midimg_btn"] forState:UIControlStateNormal];
            btnAdd.frame = CGRectMake(10, 5, 89, 82);
        }
        else {
            [btnAdd setImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
            btnAdd.frame = CGRectMake(5, 5, 100, 80);
        }
        [cell.contentView addSubview:btnAdd];
        
        UIButton *btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        btnArrow.frame = CGRectMake(0, 0, 16, 18);
        [btnArrow addTarget:self action:@selector(didSelectArrowAt:event:) forControlEvents:UIControlEventTouchUpInside];
        [btnArrow setImage:[UIImage imageNamed:@"arrow_green.png"] forState:UIControlStateNormal];
        cell.accessoryView = btnArrow;
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 180, 90)];
        lblName.numberOfLines = 0;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.tag = 3;
        lblName.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        [cell.contentView addSubview:lblName];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIImageView *imgArtWork = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:3];
    MPMediaPlaylist *playlist = [self.arrPlayList objectAtIndex:indexPath.row];
    MPMediaItem *song = [playlist representativeItem];
    MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize: CGSizeZero]              ;
    if(artworkImage) {
        imgArtWork.image = artworkImage;
    }
    else {
        imgArtWork.image = [UIImage imageNamed:@"default_thumb"];
    }
    
    lblName.text = [playlist valueForProperty: MPMediaPlaylistPropertyName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListViewController *viewController = [[SongListViewController alloc] initWithNibName:@"SongListViewController" bundle:nil];
    viewController.selectedPlayList =  [self.arrPlayList objectAtIndex:indexPath.row];
    viewController.isFromFav = self.isFromFav;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didSelectItemAt:(UIButton*)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint: currentTouchPosition];
    if(indexPath != nil) {
        if(self.isFromFav) {
            MPMediaPlaylist *playlist = [self.arrPlayList objectAtIndex:indexPath.row];
            NSString *playlistID = [playlist valueForProperty: MPMediaPlaylistPropertyPersistentID];
            [appDelegate playPlayListByID:playlistID at:0];
            sleep(1);
            [appDelegate.musicPlayer play];
            CountDownViewController *viewController = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            MPMediaPlaylist *playlist = [self.arrPlayList objectAtIndex:indexPath.row];
            NSString *playlistID = [playlist valueForProperty: MPMediaPlaylistPropertyPersistentID];
            NSLog(@"PlayListID:%@",playlistID);
            if([appDelegate.arrFav containsObject:playlistID]) { // Already Added
                [appDelegate playPlayListByID:playlistID at:0];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [appDelegate.arrFav addObject:playlistID];
                [appDelegate playPlayListByID:playlistID at:0];
                [appDelegate.arrFav writeToFile:[appDelegate filePath] atomically:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }
   }
}

- (void)didSelectArrowAt:(UIButton*)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint: currentTouchPosition];
    if(indexPath != nil) {
        SongListViewController *viewController = [[SongListViewController alloc] initWithNibName:@"SongListViewController" bundle:nil];
        viewController.selectedPlayList =  [self.arrPlayList objectAtIndex:indexPath.row];
        viewController.isFromFav = self.isFromFav;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isFromFav) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
      return  UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [appDelegate.arrFav removeObjectAtIndex:indexPath.row];
    [self.arrPlayList removeObjectAtIndex:indexPath.row];
    [appDelegate.arrFav writeToFile:[appDelegate filePath] atomically:YES];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.arrPlayList removeAllObjects];
        [appDelegate.arrFav removeAllObjects];
        [appDelegate.arrFav writeToFile:[appDelegate filePath] atomically:YES];
        [self.table reloadData];
    }
}

@end
