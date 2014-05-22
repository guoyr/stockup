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

#define BLACK UIColorFromRGB(0x000000)
#define WHITE UIColorFromRGB(0xFFFFFF)

#define IMAGE_DAILY_K_URL @"http://image.sinajs.cn/newchart/daily/n/"
#define IMAGE_MACD_URL @"http://image.sinajs.cn/newchart/macd/n/"
#define CURRENT_INFO_URL @"http://hq.sinajs.cn/"

#define STOCK_CELL_HEIGHT 80
#define ALGO_ROW_HEIGHT 92
#define ALGO_EXPANDED_ROW_HEIGHT 282

#define STOCK_CELL_WIDTH 320
#define CONFIRM_BUTTON_HEIGHT 48

#define ALGO_LIST_WIDTH 384
#define BUY_BUTTON_HEIGHT 48
#define SELL_BUTTON_HEIGHT 48

#define USER_ALGO_LIST_HEIGHT 80

#define DEBUG_MODE_USER 3
#define DEBUG_MODE_STOCK 2
#define DEBUG_MODE_ALGO 1
#define DEBUG_MODE_NONE 0

#define MACD_DIRECTION_POS 0
#define MACD_DIRECTION_NEG 1




