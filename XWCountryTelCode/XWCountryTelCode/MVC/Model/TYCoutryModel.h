//
//  TYCoutryModel.h
//  tianyanAR
//
//  Created by Edwin on 15/12/16.
//  Copyright © 2015年 Steven2761. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCoutryModel : NSObject
/**
 *  国家名称
 */
@property (nonatomic,copy)NSString *countryName;
/**
 *  国家名称的拼音
 */
@property (nonatomic,copy)NSString *countryAlph;
/**
 *  国家电话号码区号
 */
@property (nonatomic,copy)NSString *countryTelNum;
@end
