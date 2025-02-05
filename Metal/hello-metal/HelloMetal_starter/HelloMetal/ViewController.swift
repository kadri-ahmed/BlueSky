/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Metal

/// - Attributes:
///   - device: default GPU
///   - metalLayer: CALayer to draw on the screen with Metal
@available(iOS 13.0, *)
class ViewController: UIViewController {
  
  var device: MTLDevice!
  var metalLayer: CAMetalLayer!
  var pipelineState: MTLRenderPipelineState! // This will keep track of the compiled render pipeline
  var commandQueue: MTLCommandQueue!
  var timer: CADisplayLink!
  
  
  let vertexData: [Float] = [
      0.0, 1.0, 0.0,
      -1.0, -1.0, 0.0,
      1.0, -1.0, 0.0
  ]
  var vertexBuffer: MTLBuffer! // needed to move vertexData from CPU to GPU
  
  /// Initialize GPU Device
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    device = MTLCreateSystemDefaultDevice() // Get Default GPU
    
    
    metalLayer = CAMetalLayer()           // 1. create CAMetalLayer
    metalLayer.device = device            // 2. Specify the MTLDevice the layer should use. You simply set this to the device you obtained earlier.
    metalLayer.pixelFormat = .bgra8Unorm  // 3. “8 bytes for Blue, Green, Red and Alpha  in that order — with normalized values between 0 and 1."
    metalLayer.framebufferOnly = true     // 4. Change to false if you need to sample from the textures generated for this layer, or if you need to enable compute kernels on the layer drawable                                            texture.
    metalLayer.frame = view.layer.frame   // 5. Set the frame of the layer to match the frame of the view
    view.layer.addSublayer(metalLayer)    // 6. Add the layer as a sublayer of the view’s main layer.
    
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: []) // empty option array for default configuration
    
    let defaultLibrary = device.makeDefaultLibrary()! // Through this you can access any of the precompiled shaders included in your project
    let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
    let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
    
    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm // it follows metalLayer.pixelFormat because I am rendering to that layer
    
    pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    commandQueue = device.makeCommandQueue()
    
    timer = CADisplayLink(target: self, selector: #selector(gameloop))
    timer.add(to: RunLoop.main, forMode: .default)
    
  }
  
  func render() {
    guard let drawable = metalLayer?.nextDrawable() else { return } // returns the texture in which you need to draw in order for something to appear on the screen
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear // set texture to the clear color before doing any drawing
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0)
    
    let commandBuffer = commandQueue.makeCommandBuffer()! // it contains one or more render commands
    
    let renderEncoder = commandBuffer
      .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
    renderEncoder.endEncoding()
    
    // Commit the CommandBuffer
    commandBuffer.present(drawable) // needed to make sure that the GPU presents the new texture as soon as the drawing completes
    commandBuffer.commit() // commit the transaction to send the task to the GPU
  }
  
  
  /// Calls render() each frame
  @objc func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
  
  
}
