//
//  ProcessorFactory.h
//  spotted
//
//  Created by BoHuang on 6/1/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Processor.h"
@interface ProcessorFactory : NSObject

-(Processor*) createProcessor:(long) type;
@end
