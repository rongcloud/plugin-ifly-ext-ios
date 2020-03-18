融云 IM 讯飞语音输入 sdk-RongiFlyKit 集成说明文档

### 一、sdk-RongiFlyKit 需要的文件 ：

| 文件 | 说明 |
|:------------------:|:------------------|
| RongiFlyKit.framework | 融云 IM 讯飞输入法插件库 |
| RongCloudiFly.bundle | 图片资源包 |
| iflyMSC.framework | 讯飞 SDK（参考二获取） |

### 二、获取 appkey 和 讯飞 SDK
讯飞的 appkey 和 sdk 是绑定的，所以请先参考[讯飞官网](https://www.xfyun.cn/doc/asr/voicedictation/iOS-SDK.html#_2、sdk集成指南)注册账号，在讯飞开放平台申请应用获得 appkey, 下载与 appkey 绑定的 iflyMSC.framework 库

### 三、copy 库
参考步骤一 把所需文件导入项目工程，
如果使用项目 RongiFlyKit 源码，只需要把源码中的  iflyMSC.framework 库替换成步骤二中获取的 iflyMSC.framework 库

### 四、Build Settings
 Build Settings 中 Other Linker Flags 添加 -ObjC 。


### 五、依赖库
融云的讯飞输入法插件依赖于 IMKit，添加 IMKit 参考 <https://docs.rongcloud.cn/im/imkit/ios/quick-start/import/#_1> ,
除了IMKit所需的依赖库，还需要添加

Foundation.framework   <br/>
AddressBook.framework

### 六、注册
RongiFlyKit  注册 appkey:

```
[RCiFlyKit setiFlyAppKey:@"12345678"];
```
