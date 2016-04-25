//
//  YYSentinel.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/4/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

static dispatch_queue_t getRadiusDisplayQueue() {
    static dispatch_queue_t renderRadiusQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                renderRadiusQueue = dispatch_queue_create("renderRadiusQueue", attr);
        } else {
                renderRadiusQueue = dispatch_queue_create("renderRadiusQueue", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(renderRadiusQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        }
    });
    return renderRadiusQueue;
}

/**
 YYSentinel is a thread safe incrementing counter. 
 It may be used in some multi-threaded situation.
 */
@interface YYSentinel : NSObject

/// Returns the current value of the counter.
@property (readonly) int32_t value;

/// Increase the value atomically.
/// @return The new value.
- (int32_t)increase;
@end
