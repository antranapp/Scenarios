//
//  PDDebugWindow.h
//  
//
//  Created by Tran Binh An on 31/1/25.
//

#import <Foundation/Foundation.h>
#import "PDMovableWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDDebugWindow : PDMovableWindow

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
