//
//  NSObject+CXAAutoRemovalNotification.m
//
//  Created by CHEN Xian’an on 12/22/14.
//  Copyright (c) 2014 CHEN Xian’an <xianan.chen@gmail.com>. All rights reserved.
//

#import "NSObject+CXAAutoRemovalNotification.h"
#import <objc/runtime.h>

typedef void (^CXADeallocBlock)();

@interface NSObject (CXAAutoRemovalNotificationHelper)

@property (nonatomic, strong, setter=cxa_setDeallocContext:) id cxa_deallocContext;

- (void)cxa_setDeallocBlock:(CXADeallocBlock)block;

@end


@implementation NSObject (CXAAutoRemovalNotification)

- (void)cxa_addObserverForName:(NSString *)name
                        object:(id)obj
                         queue:(NSOperationQueue *)queue
                    usingBlock:(void (^)(NSNotification *))block
{
  id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:obj queue:queue usingBlock:block];
  NSMutableArray *observers = [self cxa_deallocContext];
  if (!observers) {
    observers = [[NSMutableArray alloc] init];
    [self cxa_setDeallocContext:observers];
    __weak typeof(self) weakSelf = self;
    [self cxa_setDeallocBlock:^{
      for (id o in weakSelf.cxa_deallocContext)
        [[NSNotificationCenter defaultCenter] removeObserver:o];
    }];
  }
  
  [observers addObject:observer];
}

- (void)cxa_addObserverForName:(NSString *)name
                    usingBlock:(void (^)(NSNotification *))block
{
  [self cxa_addObserverForName:name object:nil queue:nil usingBlock:block];
}

@end

@interface CXADeallocBlockBox : NSObject

@property (nonatomic, retain) id context;
@property (nonatomic, copy) CXADeallocBlock block;

@end

static char kBlockBoxKey;

@implementation NSObject (CXAAutoRemovalNotificationHelper)

- (id)cxa_deallocContext
{
  return [self cxa_box].context;
}

- (void)cxa_setDeallocContext:(id)context
{
  [self cxa_box].context = context;
}

- (void)cxa_setDeallocBlock:(CXADeallocBlock)block
{
  [self cxa_box].block = block;
}

- (CXADeallocBlockBox *)cxa_box
{
  CXADeallocBlockBox *box = objc_getAssociatedObject(self, &kBlockBoxKey);
  if (!box) {
    box = [[CXADeallocBlockBox alloc] init];
    objc_setAssociatedObject(self, &kBlockBoxKey, box, OBJC_ASSOCIATION_RETAIN);
  }
  
  return box;
}

@end

@implementation CXADeallocBlockBox

- (void)dealloc
{
  if (self.block)
    self.block();
}

@end
