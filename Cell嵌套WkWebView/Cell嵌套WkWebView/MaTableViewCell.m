//
//  MaTableViewCell.m
//  Cell嵌套WkWebView
//
//  Created by Admin on 2018/1/12.
//  Copyright © 2018年 Admin. All rights reserved.
//  自定义cell

#import "MaTableViewCell.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
@interface MaTableViewCell()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webKitView;
@property(nonatomic,strong)UIActivityIndicatorView *loadingActivity;
@property(nonatomic,strong)UIView *loadingView;
@end

@implementation MaTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString *ID=@"maCell";
    MaTableViewCell *cell=[tableview dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[MaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        
        WKWebView *webKitView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        webKitView.navigationDelegate=self;
        webKitView.scrollView.scrollEnabled=NO;
        self.webKitView=webKitView;
        webKitView.hidden=YES;
        
        [self.contentView addSubview:webKitView];
        
        
        
        //加载等待
        UIView *loadingView=[[UIView alloc]init];
        loadingView.backgroundColor=[UIColor whiteColor];
        UIActivityIndicatorView *loadingActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView addSubview:loadingActivity];
        
        [self.contentView addSubview:loadingView];
        self.loadingActivity=loadingActivity;
        self.loadingView=loadingView;
        [self.loadingActivity startAnimating];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
    }];
    
    [self.loadingActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingView);
    }];
    if (self.webHeight==0) {
        [self.loadingActivity startAnimating];
    }
}

-(void)setContentHtml:(NSString *)contentHtml
{
    _contentHtml=contentHtml;
    
    [self.loadingView setHidden:NO];
    [self.loadingActivity startAnimating];
    [self.webKitView loadHTMLString:contentHtml baseURL:nil];
    
    [self.webKitView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(self.webHeight).priorityHigh();
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.webKitView.hidden=NO;
    [self.loadingView setHidden:YES];
    [self.loadingActivity stopAnimating];
}


@end
