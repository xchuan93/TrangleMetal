//
//  XCShaderTypes.h
//  TrangleMetal
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#ifndef XCShaderTypes_h
#define XCShaderTypes_h

#include <simd/simd.h>

//typedef struct {
//    vector_float2 position;
//    vector_float4 color;
//}XCShaderType;

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
}XCShaderType;

typedef enum XCVertexImputIndex {
    XCVertexInputIndexVertices = 0,
    XCVertexInputCount         = 1,
}XCVertexInputIndex;

typedef enum XCZTextureIndex {
    XCZTextureIndexBaseColor = 0,
} XCZTextureIndex;

#endif /* XCShaderTypes_h */
