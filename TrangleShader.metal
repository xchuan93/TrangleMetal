//
//  TrangleShader.metal
//  TrangleMetal
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "XCShaderTypes.h"

//typedef struct {
//    float4 position[[position]];
//    float4 color;
//}RansizeData;

typedef struct {
    float4 position[[position]];
    float2 texCoords;;
}RansizeData;

//vertex RansizeData verticesShader(constant XCShaderType *vertices[[buffer(XCVertexInputIndexVertices)]],uint vid[[vertex_id]]){
//
//    RansizeData outVertex;
//    outVertex.position = float4(vertices[vid].position,0.0,1.0);
//    outVertex.color = vertices[vid].color;
//    return outVertex;
//}
vertex RansizeData verticesShader(constant XCShaderType *vertices[[buffer(XCVertexInputIndexVertices)]],uint vid[[vertex_id]]){
    
    RansizeData outVertex;
    outVertex.position = float4(vertices[vid].position,0.0,1.0);
    outVertex.texCoords = vertices[vid].textureCoordinate;
    return outVertex;
}


//fragment float4 fragmentShader(RansizeData inVertex[[stage_in]]){
//    return inVertex.color;
//}

fragment float4 fragmentShader(RansizeData inVertex[[stage_in]],texture2d<float>text2d[[texture(XCZTextureIndexBaseColor)]]){
    
    constexpr sampler textureSample(mag_filter::linear,min_filter::linear);
    return float4(text2d.sample(textureSample,inVertex.texCoords));
}
