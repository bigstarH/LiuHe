//
//  NetworkUrl.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#ifndef NetworkUrl_h
#define NetworkUrl_h

#define BASE_URL    @""

// 首页
#define GET_INDEXAD_AD_URL  @"http://ad.jizhou56.com:8090/appad/lhcbtad/index.json"  // 首页广告
#define GET_TREASURE_URL    @"http://ad.jizhou56.com:8090/appad/lhcbt_xb/index.json" // 六合寻宝
#define GET_KAIJIANG_AD_URL @"http://ad.jizhou56.com:8090/appad/spkjad/index.json"   // 视频开奖广告
#define LOTTERY_HISTORY_URL @"http://wap.jizhou56.com:8090/json/2016.json" // 历史记录

// 我的
// 用户相关
#define USER_RELATION_URL   @"http://wap.jizhou56.com:8090/e/member/doaction.php"
// 设置相关
#define USER_SETTING_URL    @"http://wap.jizhou56.com:8090/e/enews/index.php"
#define POST_RELEASE_URL    @"http://wap.jizhou56.com:8090/e/DoInfo/ecms.php"  // 发布帖子
#define USER_POST_URL       @"http://wap.jizhou56.com:8090/e/extend/json/json.php"  // 我的帖子

// 网页
#define LOTTERY_KJ_URL      @"http://ad.jizhou56.com:8090/kaijiang.php"     // 视频开奖网页
#define TREND_ANALYZE_URL   @"http://wap.jizhou56.com:8090/e/extend/trend/" // 走势分析网页
#define DATE_LOTTERY_URL    @"http://wap.jizhou56.com:8090/appdate.php"     // 开奖日期网页

#endif /* NetworkUrl_h */
