import MetalKit
import PlaygroundSupport

// **********************************************************************
// Step 1: Setting up things
// **********************************************************************
guard let device = MTLCreateSystemDefaultDevice() else { fatalError("No GPU found") }// Get default GPU
guard let commandQueue = device.makeCommandQueue() else { fatalError("No CommandQueue found") } // Create CommandQueue

let frame = CGRect(x: 0, y: 0, width: 600, height: 400) // Create the canvas (screen size)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
let allocator = MTKMeshBufferAllocator(device: device)


// **********************************************************************
// Step 2: Create/Load the model
// **********************************************************************

// Create the Sphere Mesh Object
let mdlMesh = MDLMesh(
    sphereWithExtent: [0.75, 0.75, 0.75],
    segments: [100, 100],
    inwardNormals: false,
    geometryType: .triangles,
    allocator:  allocator)
let mesh = try MTKMesh(mesh: mdlMesh, device: device)


// **********************************************************************
// Step 3: Setup the pipeline (Vertex & Fragment Shaders)
// **********************************************************************

let shader = """
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
  return vertex_in.position;
}

fragment float4 fragment_main() {
  return float4(1, 0.4, 0, 1);
}
"""

let defaultLibrary = try device.makeLibrary(source: shader, options: nil)
let vertexFunction = defaultLibrary.makeFunction(name: "vertex_main")
let fragmentFunction = defaultLibrary.makeFunction(name: "fragment_main")


// **********************************************************************
// Step 4: Setup the pipeline state
// **********************************************************************

// This descriptor holds everything the pipeline needs to know
let pipelineDescriptor = MTLRenderPipelineDescriptor()
pipelineDescriptor.vertexFunction = vertexFunction
pipelineDescriptor.fragmentFunction = fragmentFunction
pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

// Necessary to describe how the vertices are laid out in memory
pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)

let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)


// **********************************************************************
// Step 5: Create the command buffer
// **********************************************************************

guard let commandBuffer = commandQueue.makeCommandBuffer(), // Holds the operations to be performed by the GPU
      let renderPassDescriptor = view.currentRenderPassDescriptor, // Tells GPU what to render
      let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) // Tells the GPU how to render
else { fatalError("Couldn't create command buffer") }

// **********************************************************************
// Step 6: Define the render command encoder by populating its attributes
// **********************************************************************

renderEncoder.setRenderPipelineState(pipelineState)
renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
guard let submesh = mesh.submeshes.first else { fatalError("Couldn't find submesh") }
renderEncoder.drawIndexedPrimitives(
    type: .triangle,
    indexCount: submesh.indexCount,
    indexType: submesh.indexType,
    indexBuffer: submesh.indexBuffer.buffer,
    indexBufferOffset: 0)

renderEncoder.endEncoding()


// **********************************************************************
// Step 7: Commit everything to the GPU
// **********************************************************************

guard let drawable = view.currentDrawable else { fatalError("Couldn't get drawable") }
commandBuffer.present(drawable)
commandBuffer.commit()

PlaygroundPage.current.liveView = view
