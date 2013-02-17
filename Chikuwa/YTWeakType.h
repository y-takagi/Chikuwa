//
//  YTWeakType.h
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#ifndef NSCWeakType_h
#define NSCWeakType_h

#define WEAK_TYPE(o) __weak __typeof__( ( __typeof__(o) )o )
#define DECLARE_WEAK(var) WEAK_TYPE(var) w_ ## var = var
#define DECLARE_W_SELF DECLARE_WEAK(self)

#endif