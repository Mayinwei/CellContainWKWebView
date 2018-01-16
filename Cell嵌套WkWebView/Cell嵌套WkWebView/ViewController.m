//
//  ViewController.m
//  Cell嵌套WkWebView
//
//  Created by Admin on 2018/1/12.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MaTableViewCell.h"
#import <WebKit/WebKit.h>
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *arrayData;//数据组
@property(nonatomic,strong)NSMutableArray *arrayEditingData;//隐藏和显示组
@property(nonatomic,strong)NSMutableArray *arrayWebViewHeightData;//webView高度缓存
@property(nonatomic,strong)WKWebView *webKitView;//计算高度浏览器控件
@property(nonatomic,assign)NSInteger selectIndex;//目前选择的Section
@end

@implementation ViewController
-(NSMutableArray *)arrayEditingData
{
    if (_arrayEditingData==nil) {
        _arrayEditingData=[NSMutableArray array];
    }
    return _arrayEditingData;
}

-(NSMutableArray *)arrayData
{
    if (_arrayData==nil) {
        _arrayData=[NSMutableArray array];
    }
    return _arrayData;
}

-(NSMutableArray *)arrayWebViewHeightData
{
    if (_arrayWebViewHeightData==nil) {
        _arrayWebViewHeightData=[NSMutableArray array];
    }
    return _arrayWebViewHeightData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"列表";
    
    //界面
    [self setUpUI];
    
    [self setUpWkView];
    //数据
    [self loadData];
    
    
}

-(void)setUpUI{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView=tableView;
    
    [self.view addSubview:tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 20;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor=[UIColor colorWithRed:218/ 255.0 green:218/ 255.0 blue:218/ 255.0 alpha:1.0];
}

-(void)loadData{
    NSString *str1=@"<div>第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行第一行</div>";
    
    NSString *str2=@"<div>第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行</div>";
    
    NSString *str3=@"<div>第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行第三行</div>";
    
     NSString *str4=@"<div>第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行第四行</div>";
    [self.arrayData addObject:str1];
    [self.arrayData addObject:str2];
    [self.arrayData addObject:str3];
    [self.arrayData addObject:str4];
    for (int i=0; i<self.arrayData.count; i++) {
        //保持加载页面打开最后一个
        if (i==self.arrayData.count-1) {
            [self.arrayEditingData addObject:@(YES)];
        }else{
            [self.arrayEditingData addObject:@(NO)];
        }
        
        //高度缓存
        [self.arrayWebViewHeightData addObject:@(0)];
    }
    self.selectIndex=self.arrayData.count-1;
    [self.webKitView loadHTMLString:[self.arrayData lastObject] baseURL:nil];
    [self.tableView reloadData];
}

-(void)setUpWkView{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    
    WKWebView *webKitView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1) configuration:wkWebConfig];
    webKitView.navigationDelegate=self;
    webKitView.scrollView.scrollEnabled=NO;
    self.webKitView=webKitView;
    webKitView.hidden=YES;
}

#pragma mark -浏览器代理
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight"
              completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                  if (!error) {
                      NSString *heightStr = [NSString stringWithFormat:@"%@",result];
                      CGFloat height=[heightStr floatValue];
                      NSLog(@"height=%f",height);
                      //缓存高度刷新
                      [self.arrayWebViewHeightData replaceObjectAtIndex:self.selectIndex withObject:@(height)];
                      NSIndexSet * index = [NSIndexSet indexSetWithIndex:self.selectIndex];
                      
                      [UIView performWithoutAnimation:^{
                          [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
                      }];
                      
                  }
                  
              }];
}

#pragma mark -tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayEditingData.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
    if ([self.arrayEditingData[section] boolValue]) {
        count=1;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaTableViewCell *cell=[MaTableViewCell cellWithTableView:tableView];
    CGFloat weHeight=[self.arrayWebViewHeightData[indexPath.section] floatValue];
    if (weHeight>0) {
        cell.webHeight= weHeight;
        cell.contentHtml=self.arrayData[indexPath.section];
    }
    return cell;
}

//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UILabel *lab=[[UILabel alloc]init];
    lab.text=[NSString stringWithFormat:@"第%ld行的头部",(long)section+1];
    [headerView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(10);
        make.centerY.equalTo(headerView);
    }];
    headerView.backgroundColor=[UIColor colorWithRed:87/ 255.0 green:174/ 255.0 blue:247/ 255.0 alpha:1.0];;
    headerView.tag=section;
    //添加手势，折叠/打开
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

//头部点击事件
-(void)headerClick:(UITapGestureRecognizer *)tap
{
    
    UIView *view=tap.view;
    self.selectIndex=view.tag;
    BOOL close=[self.arrayEditingData[view.tag] boolValue];
    close=!close;
    [self.arrayEditingData replaceObjectAtIndex:view.tag withObject:@(close)];
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:view.tag];
    NSString *contentHtml=self.arrayData[view.tag];
    //判断是否缓存了高度
    CGFloat height=[self.arrayWebViewHeightData[view.tag] floatValue];
    //关闭时直接刷新
    if(!close){
        [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        //打开状态
        if (height==0) {
            //获取高度缓存
            [self.webKitView loadHTMLString:contentHtml baseURL:nil];
        }
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
