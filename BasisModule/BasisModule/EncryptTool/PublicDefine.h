//
//  PublicDefine.h
//  BasisModule
//
//  Created by huang on 2017/6/5.
//  Copyright © 2017年 huang. All rights reserved.
//

#ifndef PublicDefine_h
#define PublicDefine_h

/*
 ===============================================================================================
 =========================================APP版本================================================
 ===============================================================================================
 */
#define APP_SYSTEM_APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]  //App版本号 （build）

#define APP_SYSTEM_APP_VERSIONSTRING  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  //App版本号String
#define APP_SYSTEM_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]    //ios版本
/*
 ===============================================================================================
 =========================================密匙信息===============================================
 ===============================================================================================
 */
#define APP_ITUNES_APPID @"1146328202"
//请求编号
#define APP_SYSTEM_REQUEST_ID @"996891"
//密码密匙
#define APP_SYSTEM_REQUEST_PASSWORD_KEY @"FE605C9343A3A47764598FDC184EC66F"

//APIKey
#define APP_SYSTEM_NETWORK_REQUEST_PHONE_API_KEY @"B7302E121B6F4864226D8387A102A489"
//ChatApiKey
//#define APP_SYSTEM_NETWORK_REQUEST_CHAT_API_KEY @"D620334C84BFB1BD5F0867F243D0FF2E"

//#define APP_SYSTEM_NETWORK_REQUEST_AES_IV @"6A886854CD848434"
#define APP_SYSTEM_NETWORK_REQUEST_AES_KEY @"E6876647D98615ED662BEF60A26A524D"

/*
 ===============================================================================================
 =========================================常量信息===============================================
 ===============================================================================================
 */

#define APP_SYSTEM_CUSTOMER_SERVICE_TEL @"4000062199"
//用户编号和密码
#define APP_SYSTEM_USER_ID   @"0"  //用户编号//用户编号和密码
#define APP_SYSTEM_USER_IMUniqueId @"0" //通讯Id
#define APP_SYSTEM_USER_IMPASSWORD @"0" //通讯密码

#endif /* PublicDefine_h */
