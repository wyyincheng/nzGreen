//
//  YZBalanceLogModel.h
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZBalanceLogModel : YZBaseModel

@property (nonatomic, copy) NSString *amount; //": "-3171.00",
@property (nonatomic, copy) NSString *avatar;//": "",
@property (nonatomic, strong) NSNumber *createTime;//": 1526119226000,
@property (nonatomic, strong) NSNumber *logId;//": 43,
@property (nonatomic, copy) NSString *nickname;//": "",
@property (nonatomic, copy) NSString *triggerUserId;//": 0,

/**
 _CHARGE(1,"充值"), _ORDER_REBATE(2,"订单返佣"), _ORDER(3,"下单"), _REFUND(4,"退款"), _MONTH_REBATE(5,"月返佣"), _WITHDRAW(6,"提现"), _ORDER_REFUSED(7,"订单驳回")
 */
@property (nonatomic, assign) NSInteger type;//": 3

@end

NS_ASSUME_NONNULL_END
