//
//  AppDelegate.m
//  DownloadSelf
//
//  Created by Thomas on 2020/3/16.
//  Copyright © 2020 Thomas. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"


@interface AppDelegate ()<UIApplicationDelegate> {
  GCDWebServer* _webServer;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
      _webServer = [[GCDWebServer alloc] init];
      
      [_webServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:true];
      [_webServer startWithPort:1234 bonjourName:@""];
;
    return YES;
}
//
//#pragma mark - <GCDWebUploaderDelegate>
////上传文件到目录
//- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
//    NSLog(@"上传音乐 %@", [self getMusicFileArray]);
//}
//
//- (NSString *)getFilePath:(NSString *)fileName {
//    return  [_documentsPath stringByAppendingPathComponent:fileName];
//}
//
////获取目录下的文件
//- (NSMutableArray *)getMusicFileArray {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    return [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:_documentsPath error:nil]];
//}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
