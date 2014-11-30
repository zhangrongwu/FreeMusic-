//
//  FMMainViewController.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-27.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMMainViewController.h"
#import "FMMainTableViewCell.h"
#import "FMSingerSongListViewController.h"
#import "FMMusicViewController.h"
@interface FMMainViewController ()
{
    NSMutableArray * array;
}
@end

@implementation FMMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigation.leftImage  =nil;// [UIImage imageNamed:@"nav_backbtn.png"];
    self.navigation.rightImage = [UIImage imageNamed:@"nav_music.png"];
//    self.navigation.headerImage = [UIImage imageNamed:@"nav_canadaicon.png"];
    self.navigation.title = @"FreeMusic";
    self.navigation.navigaionBackColor = [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];


    array = [NSMutableArray new];
    
    FMSingerModel * model = [FMSingerModel new];
    array = [model itemTop100];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,self.navigation.size.height+self.navigation.origin.y, self.view.size.width, 44.0f)];
    _searchBar.delegate =self;
    _searchBar.placeholder = @"搜索:歌手";
//	_searchBar.tintColor = [UIColor lightGrayColor];
    _searchBar.showsCancelButton = YES;
	_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	// Create the search display controller
    
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.size.height+_searchBar.origin.y, self.view.size.width, self.view.size.height-self.navigation.size.height-self.searchBar.size.height-48.5f)];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];
	// Do any additional setup after loading the view.
    [self.view addSubview:_searchBar];

    // Do any additional setup after loading the view.
}
-(void)rightButtonClickEvent
{
    if (globle.isPlaying) {
        FMMusicViewController * pushController = [FMMusicViewController shareMusicViewController];
        [self.navigationController pushViewController:pushController animated:YES];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // called when keyboard search button pressed
    [_searchBar resignFirstResponder];
    
    if ([array count]!=0) {
        [array removeAllObjects];
    }
    [ProgressHUD show:nil];
    [self getSingerData];
}
-(void)getSingerData
{
    FMSingerModel * model = [FMSingerModel new];
    array = [model itemWith:_searchBar.text];
    [_tableView reloadData];
    [ProgressHUD dismiss];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [array count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSString * dentifier = @"cell";
        FMMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
     if (cell == nil) {
         cell = [[FMMainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dentifier];
     }
     FMSingerModel * model = [array objectAtIndex:indexPath.row];
     cell.model = model;
 return cell;
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMSingerModel * model = [array objectAtIndex:indexPath.row];
    FMSingerSongListViewController * pushController = [[FMSingerSongListViewController alloc] init];
    pushController.singerModel = model;
    [self.navigationController pushViewController:pushController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
