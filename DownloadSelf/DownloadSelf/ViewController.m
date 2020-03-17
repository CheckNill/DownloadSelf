//
//  ViewController.m
//  DownloadSelf
//
//  Created by Thomas on 2020/3/16.
//  Copyright © 2020 Thomas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSOutputStream *stream;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) NSInteger totalLength;

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *downPath;
@property (nonatomic, strong) NSString *downloadUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initpath];
}

- (void)initpath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _fileManager = fileManager;
    NSArray *libraryDirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [libraryDirs objectAtIndex:0];
    //Game文件夹
    NSString *gameFilePath = [cachesDir stringByAppendingPathComponent:@"/Game"];
    if (![fileManager fileExistsAtPath:gameFilePath]) {//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        [fileManager createDirectoryAtPath:gameFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    _downPath = [gameFilePath stringByAppendingPathComponent:@"asda.ipa"];
    //ipa下载地址，可以放到博客或者git上，我这里使用的本地nginx，ipa只测试过企业签的包
    _urlString = @"http://192.168.254.100:8082/ipa/test.ipa";
    //远程plist文件地址，可以放到博客上，方便
    _downloadUrl = @"itms-services://?action=download-manifest&url=https://ptcode.online/test.plist";
}

- (IBAction)download:(id)sender {
    // 创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    // 创建流
    // 设置流存储路径
    self.stream = [NSOutputStream outputStreamToFileAtPath:_downPath append:YES];

    // 创建请求
    // 这里的url是你的网络视频URL字符串
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]];

    // 创建一个Data任务
    self.task = [session dataTaskWithRequest:request];
    // 利用KVC修改taskIdentifier的值，这是任务的标识
    [_task setValue:@(11111) forKeyPath:@"taskIdentifier"];

    [self.task resume];
}

- (void)installApp {
    NSURL *url = [NSURL URLWithString:_downloadUrl];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"打开成功...");
        }
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 打开流
    [self.stream open];

    // 获得服务器这次请求 返回数据的总长度
    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue];

    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到服务器返回的数据，一直回调，直到下载完成,暂停时会停止调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 写入数据
    [self.stream write:data.bytes maxLength:data.length];

    // 下载进度
    NSUInteger receivedSize = [self getSizeOfDataBaseName:_downPath];
    CGFloat progress = 1.0 * receivedSize / self.totalLength;
    _progressLb.text = [NSString stringWithFormat:@"%.lf%%", progress * 100];
    NSLog(@"%.f%%", progress * 100);
}

// 当任务下载完成或失败会调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error == nil) {
        // 下载成功 关闭流，取消任务
        [self.stream close];
        self.stream = nil;
        [self.task cancel];
        self.task = nil;
        [self installApp];
    }
}

#pragma mark-----获取单个文件大小

- (float)getSizeOfDataBaseName:(NSString *)path {
//获取单个文件大小
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:path]) {
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}

@end
