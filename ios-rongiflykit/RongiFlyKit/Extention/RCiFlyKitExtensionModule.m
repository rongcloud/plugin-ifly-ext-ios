//
//  RCiFlyKitExtensionModule.m
//  RongiFlyKit
//
//  Created by Sin on 16/11/15.
//  Copyright © 2016年 Sin. All rights reserved.
//

#pragma clang diagnostic ignored "-Wincomplete-umbrella"
#import "RCiFlyKitExtensionModule.h"
#import "RCiFlyInputView.h"
#import <iflyMSC/iflyMSC.h>

//默认的讯飞输入sdk的appKey
#define iFlyKey @"5a3cf660"

@interface RCiFlyKitExtensionModule ()<RCiFlyInputViewDelegate>
@property (nonatomic, strong) RCiFlyInputView *iflyInputView;
@property (nonatomic, strong) RCChatSessionInputBarControl *chatBarControl;
@property (nonatomic, assign) RCConversationType conversationType;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, assign) KBottomBarStatus currentStatus;
@property (nonatomic, copy) NSString *iflyAppKey;
@end

@implementation RCiFlyKitExtensionModule
+ (instancetype)loadRongExtensionModule {
    return [self sharedRCiFlyKitExtensionModule];
}

+ (instancetype)sharedRCiFlyKitExtensionModule {
  static RCiFlyKitExtensionModule *module = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    module = [[self alloc] init];
    module.iflyAppKey = iFlyKey;
  });
  return module;
}

- (void)destroyModule {

}
- (void)setiFlyAppkey:(NSString *)key {
  _iflyAppKey = key;
}

- (void)inputBarStatusDidChange:(KBottomBarStatus)status
                     inInputBar:(RCChatSessionInputBarControl *)inputBarControl {
  if(KBottomBarPluginStatus == _currentStatus && KBottomBarPluginStatus != status){
    if(!_iflyInputView) {
      return;
    }
    [_iflyInputView stopListening];
  }
  _currentStatus = status;
  
}
- (void)didTapMessageCell:(RCMessageModel *)messageModel {
    
}


- (NSArray<RCExtensionPluginItemInfo *> *)getPluginBoardItemInfoList:(RCConversationType)conversationType
                                                            targetId:(NSString *)targetId {
  
  __weak typeof(self) ws = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建语音配置,appid必须要传入，仅执行一次则可
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",ws.iflyAppKey];
        //所有服务启动前，需要确保执行createUtility
        [IFlySpeechUtility createUtility:initString];
    });
    if (conversationType != ConversationType_Encrypted) {
        self.conversationType = conversationType;
        self.targetId = targetId;
    }
    
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    
    RCExtensionPluginItemInfo *item = [[RCExtensionPluginItemInfo alloc] init];
    item.image = [self imageFromiFlyBundle:@"actionbar_voice_input_icon"];
    item.title = NSLocalizedStringFromTable(@"VoiceInput", @"RongCloudKit", nil);
    item.tapBlock = ^(RCChatSessionInputBarControl *chatSessionInputBar){
        [ws checkPermissionIfSuccess:chatSessionInputBar];
    };
    item.tag = PLUGIN_BOARD_ITEM_VOICE_INPUT_TAG;
    [itemList addObject:item];
    return [itemList copy];
}

- (void)checkPermissionIfSuccess:(RCChatSessionInputBarControl *)chatSessionInputBar {
    __weak typeof(self) ws = self;
    [self checkRecordPermission:^{
        ws.chatBarControl = chatSessionInputBar;
        [chatSessionInputBar.pluginBoardView.extensionView setHidden:NO];
        [chatSessionInputBar.pluginBoardView.extensionView addSubview:ws.iflyInputView];
        [ws.iflyInputView show:YES];
        NSString *text = chatSessionInputBar.inputTextView.text;
        if(text.length > 0){
            [ws.iflyInputView showBottom:YES];
        }
    }];
}

- (UIImage *)imageFromiFlyBundle:(NSString *)imageName {
    NSString *imagePath =
    [[[NSBundle mainBundle] pathForResource:@"RongCloudiFly" ofType:@"bundle"]
     stringByAppendingPathComponent:imageName];
    
    UIImage *bundleImage = [UIImage imageWithContentsOfFile:imagePath];
    return bundleImage;
}

- (RCiFlyInputView *)iflyInputView {
    if(!_iflyInputView){
        _iflyInputView = [RCiFlyInputView iFlyInputViewWithFrame:self.chatBarControl.pluginBoardView.extensionView.bounds];
        _iflyInputView.backgroundColor = [UIColor clearColor];
        _iflyInputView.delegate = self;
    }
    return _iflyInputView;
}

#pragma mark - RCiFlyInputViewDelegate
//清空按钮的点击回调
- (void)clearText {
    self.chatBarControl.inputTextView.text = @"";
}

//发送按钮的点击回调
- (void)sendText {
    NSString *text = self.chatBarControl.inputTextView.text;
    if([text isEqualToString:@""] || text.length < 1){
        self.chatBarControl.inputTextView.text = @"";
        return;
    }
    RCTextMessage *txtMsg = [RCTextMessage messageWithContent:text];
    [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:txtMsg pushContent:nil pushData:nil success:nil error:nil];
    //发送完成清空输入框内容
    self.chatBarControl.inputTextView.text = @"";
}

//正常解析到文本的回调
- (void)voiceTransferToText:(NSString *)text {
    NSString *txt = self.chatBarControl.inputTextView.text;
    self.chatBarControl.inputTextView.text = [NSString stringWithFormat:@"%@%@",txt,text];
}

//发生错误的回调
- (void)onError:(NSString *)errDesc {
    
}

- (void)checkRecordPermission:(void (^)(void))successBlock {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        BOOL firstTime = NO;
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(recordPermission)]) {
            firstTime = [AVAudioSession sharedInstance].recordPermission == AVAudioSessionRecordPermissionUndetermined;
        }
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (!firstTime) {
                        successBlock();
                    }
                } else {
                    UIAlertView *alertView =
                    [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"AccessRightTitle", @"RongCloudKit", nil)
                                               message:NSLocalizedStringFromTable(@"speakerAccessRight", @"RongCloudKit", nil)
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"RongCloudKit", nil)
                                     otherButtonTitles:nil, nil];
                    [alertView show];
                }
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock();
        });
    }
}

@end
