//
//  SongListViewController.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "SongListViewController.h"
#import "PlayListViewController.h"
#import "CountDownViewController.h"

@interface SongListViewController ()
@property (nonatomic, retain) NSMutableArray *arrSongs;
@end

@implementation SongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedDelegate];
  // self.arrSongs = [[NSMutableArray alloc] initWithArray:[self.selectedPlayList items]];
    
    NSArray *itemsFromGenericQuery = [self.selectedPlayList items];
    self.arrSongs = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    
    if(self.isFromFav) {
        [self.btnCenter setTitle:@"SELECT SONG" forState:UIControlStateNormal];
        self.btnCenter.userInteractionEnabled = YES;
        [self.btnGo setHidden:YES];
    }
}

- (IBAction)btnBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnAddPressed {

    NSString *playlistID = [self.selectedPlayList valueForProperty: MPMediaPlaylistPropertyPersistentID];
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

- (void)btnGOPressed {
    NSString *playlistID = [self.selectedPlayList valueForProperty: MPMediaPlaylistPropertyPersistentID];
    [appDelegate playPlayListByID:playlistID at:0];
    sleep(1);
    [appDelegate.musicPlayer play];
    CountDownViewController *viewController = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - TalbeView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrSongs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anyCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"anyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgArtWork = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 44, 44)];
        imgArtWork.tag = 1;
        imgArtWork.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgArtWork];
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:16.0];
        
        if(self.isFromFav) {
            UIButton *btnGO = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnGO addTarget:self action:@selector(didSelectGOAt:event:) forControlEvents:UIControlEventTouchUpInside];
            [btnGO setImage:[UIImage imageNamed:@"go_small_btn"] forState:UIControlStateNormal];
            btnGO.frame = CGRectMake(0, 0, 32, 32);
            
            cell.accessoryView = btnGO;
        }
        
    }
    UIImageView *imgArtWork = (UIImageView *)[cell.contentView viewWithTag:1];

    
    MPMediaItem *song = [self.arrSongs objectAtIndex:indexPath.row];
    
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
    NSString *album = [song valueForProperty: MPMediaItemPropertyAlbumTitle];
    
    MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize: CGSizeZero];
 
    if(artworkImage) {
        imgArtWork.image = artworkImage;
    }
    else {
        imgArtWork.image = [UIImage imageNamed:@"default_thumb"];
    }
    
    NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",artist,album]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,artist.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(artist.length+1,album.length)];
    
    cell.textLabel.text = songTitle;
    cell.detailTextLabel.attributedText = attributedString;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didSelectGOAt:(UIButton*)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint: currentTouchPosition];
    if(indexPath != nil) {
        NSString *playlistID = [self.selectedPlayList valueForProperty: MPMediaPlaylistPropertyPersistentID];
        [appDelegate playPlayListByID:playlistID at:indexPath.row];
        sleep(1);
        [appDelegate.musicPlayer play];
        CountDownViewController *viewController = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end