//
//  FMTudouViewController.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/9.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMTudouViewController.h"
#import "FMLoadMoreFooterView.h"
#import "FMSongListTableViewCell.h"
#import "FMMusicViewController.h"
#import "FMTDMovieModel.h"
#import "FMTDMovieViewController.h"
#import "DropDownListView.h"
#import "FMTDTableViewCell.h"
#import "FMTDSearchViewController.h"

@interface FMTudouViewController ()<UIScrollViewDelegate>
{
    BOOL isLoadingMore;
    BOOL isCanLoadMore;
    FMLoadMoreFooterView * footerView;
    NSMutableArray * array ;
    int list_total;
    int channelId;
    int pageNum;
    NSString * sort;
    NSMutableArray *chooseArray ;

}
@end

@implementation FMTudouViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.navigation.leftImage = nil;
    self.navigation.rightImage = [UIImage imageNamed:@"nav_search"];
    self.navigation.navigaionBackColor =  [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    self.navigation.title = @"土豆视频列表";
    //1,3,5,9,10,12,14,,15,18,19,21,,22,,23,24,25,26,27,,28,29,30,31,32,33,34,35,36,37,38,39,40,99,100,104,
    chooseArray = [NSMutableArray arrayWithArray:@[
@[@"原创",@"电视剧",@"动漫",@"电影",@"综艺",@"音乐",@"纪实",@"搞笑",@"游戏",@"娱乐",@"资讯",@"汽车",@"科技",@"体育",@"时尚",@"生活",@"健康",@"教育",@"曲艺",@"旅游",@"美容",@"母婴",@"财经",@"网络剧",@"微电影",@"女性",@"其他1",@"其他2",@"其他3",@"其他4",@"其他5",],
@[@"人气最旺",@"最新发布",@"收藏最多",@"打分最高",@"评论最狠",@"土豆推荐",@"清晰视频序",],
                                                   ]];
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,self.navigation.size.height+self.navigation.origin.y, self.view.size.width, 40) dataSource:self delegate:self];
    dropDownView.mSuperView = self.view;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, dropDownView.size.height+dropDownView.origin.y, self.view.size.width, self.view.size.height-dropDownView.size.height-dropDownView.origin.y-48.5f)];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    list_total = 20;
    channelId = 99;
    pageNum = 1;
    sort = @"v";
    [self loadMoreData];
    [self.view addSubview:dropDownView];
    
    isLoadingMore = YES;
    

    footerView = [[FMLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, _tableView.size.width, 70)];
    _tableView.tableFooterView = footerView;
    [ProgressHUD show:nil];
    // Do any additional setup after loading the view.
}

-(NSString *)getSortString:(NSString *)string
{
    NSString* str = nil;
    if ([string isEqualToString:@"最新发布"]) {
        str = @"t";
    }else if ([string isEqualToString:@"人气最旺"]) {
         str = @"v";
    }else if ([string isEqualToString:@"收藏最多"]) {
         str = @"f";
    }else if ([string isEqualToString:@"打分最高"]) {
         str = @"r";
    }else if ([string isEqualToString:@"评论最狠"]) {
         str = @"c";
    }else if ([string isEqualToString:@"土豆推荐"]) {
         str = @"m";
    }else if ([string isEqualToString:@"清晰视频序"]) {
         str = @"h";
    }
    return str;
}
-(int)getChannelIDString:(NSString *)string
{
    int chId = 0;
    if ([string isEqualToString:@"娱乐"]) {
        chId = 1;
    }else if ([string isEqualToString:@"生活"]) {
        chId = 3;
    }else if ([string isEqualToString:@"搞笑"]) {
        chId = 5;
    }else if ([string isEqualToString:@"动漫"]) {
        chId = 9;
    }else if ([string isEqualToString:@"游戏"]) {
        chId = 10;
    }else if ([string isEqualToString:@"音乐"]) {
        chId = 14;
    }else if ([string isEqualToString:@"体育"]) {
        chId = 15;
    }else if ([string isEqualToString:@"科技"]) {
        chId = 21;
    }else if ([string isEqualToString:@"电影"]) {
        chId = 22;
    }else if ([string isEqualToString:@"电视剧"]) {
        chId = 30;
    }else if ([string isEqualToString:@"教育"]) {
        chId = 25;
    }else if ([string isEqualToString:@"汽车"]) {
        chId = 26;
    }else if ([string isEqualToString:@"纪实"]) {
        chId = 28;
    }else if ([string isEqualToString:@"资讯"]) {
        chId = 29;
    }else if ([string isEqualToString:@"综艺"]) {
        chId = 31;
    }else if ([string isEqualToString:@"时尚"]) {
        chId = 32;
    }else if ([string isEqualToString:@"健康"]) {
        chId = 33;
    }else if ([string isEqualToString:@"美容"]) {
        chId = 34;
    }else if ([string isEqualToString:@"旅游"]) {
        chId = 35;
    }else if ([string isEqualToString:@"曲艺"]) {
        chId = 40;
    }else if ([string isEqualToString:@"母婴"]) {
        chId = 37;
    }else if ([string isEqualToString:@"其他1"]) {
        chId = 12;
    }else if ([string isEqualToString:@"网络剧"]) {
        chId = 19;
    }else if ([string isEqualToString:@"财经"]) {
        chId = 24;
    }else if ([string isEqualToString:@"女性"]) {
        chId = 27;
    }else if ([string isEqualToString:@"其他2"]) {
        chId = 36;
    }else if ([string isEqualToString:@"其他3"]) {
        chId = 38;
    }else if ([string isEqualToString:@"微电影"]) {
        chId = 39;
    }else if ([string isEqualToString:@"原创"]) {
        chId = 99;
    }else if ([string isEqualToString:@"其他4"]) {
        chId = 100;
    }else if ([string isEqualToString:@"其他5"]) {
        chId = 104;
    }
    return chId;
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    if (section == 0) {
        NSString *  sub = [[chooseArray objectAtIndex:section] objectAtIndex:index];
        int number = [self getChannelIDString:sub];
        if (number != channelId) {
            pageNum = 1;
        }
        channelId = number;
    }else{
        NSString * sub = [[chooseArray objectAtIndex:section] objectAtIndex:index];
        sort = [self getSortString:sub];
    }
    list_total = 20;
    [ProgressHUD show:nil];
    [self loadMoreData];
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

-(void)rightButtonClickEvent
{
    if (globle.isPlaying) {
        FMTDSearchViewController * pushController = [[FMTDSearchViewController alloc] init];
        [self.navigationController pushViewController:pushController animated:YES];
    }
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
    FMTDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
    if (cell == nil) {
        cell = [[FMTDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dentifier];
    }
    FMTDMovieModel * model = [array objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMTDMovieModel* model = [array objectAtIndex:indexPath.row];
    FMTDMovieViewController * pushController = [[FMTDMovieViewController alloc] init];
    pushController.model = model;
    [self.navigationController pushViewController:pushController animated:YES];
}

#define DEFAULT_HEIGHT_OFFSET 44.0f

#pragma mark UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoadingMore && !isCanLoadMore) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        if (scrollPosition < DEFAULT_HEIGHT_OFFSET) {
            [self loadMore];
        }
    }
}
-(void)loadMore
{
    if (isLoadingMore) {
        [footerView.activeView startAnimating];
        list_total+=20;
        [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:0.1];
        isLoadingMore = NO;
        footerView.titleLabel.text = @"获取中...";
    }
}
-(void)loadMoreData
{
    if (list_total>100){
//        if (pageNum ==2) {
//            pageNum =1;
//            list_total =20;
//        }else{
//            list_total = 20;
//            pageNum =2;
//        }
        isCanLoadMore = YES; // signal that there won't be any more items to load
    }else{
        isCanLoadMore = NO;
    }

    if (isCanLoadMore) {
        [self loadMoreCompleted];
    }else{
        MCDataEngine * network = [MCDataEngine new];
        [network getTDMovieListWith:pageNum :list_total :channelId :sort WithCompletionHandler:^(FMTDMovieList *movieList) {
            [ProgressHUD dismiss];
            array = movieList.movieLists;
            [_tableView reloadData];
            [self loadMoreCompleted];
        } errorHandler:^(NSError *error) {
            [ProgressHUD showError:@"服务器错误"];
        }];
    }
}

-(void)loadMoreCompleted
{
    isLoadingMore = YES;
    if (isCanLoadMore) {
        _tableView.tableFooterView = nil;
    }else{
        [footerView.activeView stopAnimating];
    }
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
