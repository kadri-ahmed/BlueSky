//
//  Renderer.swift
//  Pipeline
//
//  Created by Ahmed Kadri on 12/24/24.
//

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    init(metalView: MTKView){
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue()
        else { fatalError("GPU not available") }
        
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        // create the mesh
        let allocator = MTKMeshBufferAllocator(device: device)
        let size: Float = 0.8
        
        guard let assetURL = Bundle.main.url(
            forResource: "train",
            withExtension: "usdz"
        ) else { fatalError("Couldn't find train.usdz") }
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset = MDLAsset(
            url: assetURL,
            vertexDescriptor: meshDescriptor,
            bufferAllocator: allocator
        )
        
        let mdlMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        
//        let mdlMesh = MDLMesh(
//            boxWithExtent: [size, size, size],
//            segments: [1, 1, 1],
//            inwardNormals: false,
//            geometryType: .triangles,
//            allocator: allocator
//        )
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch {
            print(error.localizedDescription)
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        // create the shader function library
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        // create the pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        super.init()
        
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1) // cream color
        metalView.delegate = self // set renderer as delegate for metalView
    }
}

extension Renderer: MTKViewDelegate {
    
    /// Called every time the size of the window changes
    /// - Parameters:
    ///   - view: <#view description#>
    ///   - size: <#size description#>
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    /// Called every frame. This where you write render code
    /// - Parameter view: <#view description#>
    func draw(in view: MTKView) {
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else {
            return
        }
        
        renderCommandEncoder.setRenderPipelineState(pipelineState)
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        renderCommandEncoder.setTriangleFillMode(.fill)
        
        for submesh in mesh.submeshes {
            renderCommandEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset
            )
        }
        
        renderCommandEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { // present the view's drawable texture to the GPU
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
}
