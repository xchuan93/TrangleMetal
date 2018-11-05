//
//  TrangleMetalView.swift
//  TrangleMetal
//
//  Created by Apple on 2018/9/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class TrangleMetalView: UIView {

    var device: MTLDevice!
    var piplineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var texture: MTLTexture!
    
    var metalLayer: CAMetalLayer {
        return self.layer as! CAMetalLayer
    }
    
    override class var layerClass:AnyClass {
        return CAMetalLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comonInit()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        render()
    }
    
    func comonInit() {
        device = MTLCreateSystemDefaultDevice()
        setupBuffer()
        setuptexture()
        setupPipLine()
    }
    
    func setupBuffer() {
//        let vertices = [XCShaderType(position: [0.5,-0.5], color: [1,0,0,1]),
//                        XCShaderType(position: [-0.5,-0.5], color: [0,1,0,1]),
//                        XCShaderType(position: [0.0,0.5], color: [0,0,1,1]),
//                        XCShaderType(position: [0.5,0.9], color: [0,1,0,1])]
        let vertices = [XCShaderType(position: [-1.0, -1.0], textureCoordinate: [0, 1]),
                        XCShaderType(position: [-1.0,  1.0], textureCoordinate: [0, 0]),
                        XCShaderType(position: [ 1.0, -1.0], textureCoordinate: [1, 1]),
                        XCShaderType(position: [ 1.0,  1.0], textureCoordinate: [1, 0])]
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<XCShaderType>.size * vertices.count, options: .cpuCacheModeWriteCombined)
    }
    
    func setuptexture() {
        let image = UIImage.init(named: "lena")
        texture = newTexture(image: image)
    }
    
    func setupPipLine() {
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "verticesShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let piplineDiscriptor = MTLRenderPipelineDescriptor()
        piplineDiscriptor.vertexFunction = vertexFunction
        piplineDiscriptor.fragmentFunction = fragmentFunction
        piplineDiscriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        
        piplineState = try! device.makeRenderPipelineState(descriptor: piplineDiscriptor)
    }
    
    func render() {
        guard let drawable = metalLayer.nextDrawable() else {
            print("获取显示资源失败")
            return
        }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        let commandQueue = device.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        commandEncoder?.setRenderPipelineState(piplineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setFragmentTexture(texture, index: 0)
        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
    }
    
    func newTexture(image: UIImage?) -> MTLTexture?{
        let imageref = (image?.cgImage)!
        let width = imageref.width
        let height = imageref.width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let bitContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitContext?.draw(imageref, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let texturedescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        let texture: MTLTexture? = device.makeTexture(descriptor: texturedescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
    }
}
