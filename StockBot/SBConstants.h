//
//  SBConstants.h
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//


//http://colorschemedesigner.com/#3w52bw0w0w0w0
//better one
//http://colorschemedesigner.com/#3j31M.....7w0

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BLUE_0 UIColorFromRGB(0x65A5D1)
#define BLUE_1 UIColorFromRGB(0x3E94D1)
#define BLUE_2 UIColorFromRGB(0x0A64A4)
#define BLUE_3 UIColorFromRGB(0x24577B)
#define BLUE_4 UIColorFromRGB(0x03406A)

#define PURPLE_0 UIColorFromRGB(0x8B6ED7)
#define PURPLE_1 UIColorFromRGB(0x6F47D7)
#define PURPLE_2 UIColorFromRGB(0x3E13AF)
#define PURPLE_3 UIColorFromRGB(0x442B83)
#define PURPLE_4 UIColorFromRGB(0x240672)

#define GREEN_0 UIColorFromRGB(0x85EB6A)
#define GREEN_1 UIColorFromRGB(0x5FEB3B)
#define GREEN_2 UIColorFromRGB(0x2DD700)
#define GREEN_3 UIColorFromRGB(0x41A128)
#define GREEN_4 UIColorFromRGB(0x1D8B00)

#define WHITE UIColorFromRGB(0xb6bac4)
#define YELLOW UIColorFromRGB(0xFFFF00)

#define GREY_LIGHT UIColorFromRGB(0x8B8F99)
#define GREY_DARK UIColorFromRGB(0x252932)
#define BLACK_BG UIColorFromRGB(0x16191E)

#define BLUE UIColorFromRGB(0x317D85)
#define RED UIColorFromRGB(0xF66D6A)

#define TINT_COLOR_ANIMATION_DURATION 0.25

#define IMAGE_DAILY_K_URL @"http://image.sinajs.cn/newchart/daily/n/"
#define IMAGE_MACD_URL @"http://image.sinajs.cn/newchart/macd/n/"
#define CURRENT_INFO_URL @"http://hq.sinajs.cn/"
#define SERVER_URL @"http://stockup-dev.cloudapp.net:9990/"
//#define SERVER_URL @"http://localhost:9990/"
#define STOCK_CELL_HEIGHT 80
#define ALGO_ROW_HEIGHT 72

#define STOCK_CELL_WIDTH 320
#define CONFIRM_BUTTON_HEIGHT 80 // same as stock cell height per #8

#define ALGO_LIST_WIDTH 320
#define USER_ALGO_LIST_HEIGHT 80

#define DEBUG_MODE_USER 3
#define DEBUG_MODE_STOCK 2
#define DEBUG_MODE_ALGO 1
#define DEBUG_MODE_NONE 0

#define MACD_DIRECTION_POS 0
#define MACD_DIRECTION_NEG 1

#define MACD_TIME_5MIN 0
#define MACD_TIME_1HOUR 1
#define MACD_TIME_1DAY 2

#define BUY_CONDITION 0
#define SELL_CONDITION 1

