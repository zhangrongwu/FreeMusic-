//
//  FMTDMovieViewController.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14/6/9.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMTDMovieViewController.h"

@interface FMTDMovieViewController ()
{
    UIScrollView * _scrollView;
}
@end

@implementation FMTDMovieViewController

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
    self.navigation.leftImage  = [UIImage imageNamed:@"nav_backbtn.png"];
    self.navigation.title = @"视频详情";
    self.navigation.navigaionBackColor =  [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,self.navigation.size.height+self.navigation.origin.y, self.view.size.width, 179)];
//    self.webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.webView];
    NSString * url = self.model.html5Url;
    if ([self.model.html5Url length]==0) {
        url = self.model.outerGPlayerUrl;
    }
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.webView.origin.y+self.webView.size.height, self.view.size.width, self.view.size.height-self.webView.origin.y-self.webView.size.height-48.5f)];
//    _scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_scrollView];
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _scrollView.size.width-20, 50)];
    nameLabel.numberOfLines = 2;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = self.model.title;
    [_scrollView addSubview:nameLabel];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.origin.x, nameLabel.size.height+nameLabel.origin.y, nameLabel.size.width, 25)];
    titleLabel.text = [NSString stringWithFormat:@"上传于:%@",self.model.pubDate];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_scrollView addSubview:titleLabel];
    
    UILabel * playTimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.origin.x, titleLabel.size.height+titleLabel.origin.y, titleLabel.size.width, 25)];
    playTimesLabel.font = [UIFont systemFontOfSize:14.0f];
    playTimesLabel.text = [NSString stringWithFormat:@"播放:%d",self.model.playTimes];
    [_scrollView addSubview:playTimesLabel];
    
      CGSize size = [self.model.description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(_scrollView.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(playTimesLabel.origin.x, playTimesLabel.size.height+playTimesLabel.origin.y, playTimesLabel.size.width, size.height)];
    textLabel.font = [UIFont systemFontOfSize:14.0f];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.text = self.model.description;
    textLabel.numberOfLines = 0;
    [_scrollView addSubview:textLabel];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.size.width, textLabel.size.height+textLabel.origin.y+10);
    
    // Do any additional setup after loading the view.
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
