import MetalKit

struct Vertex {
    var x: Float
    var y: Float
    var z: Float
}

struct Quad {
    var oldVertices: [Vertex] = [
        Vertex(x: -1, y: 1, z: 0), // Triangle 1
        Vertex(x: 1, y: -1, z: 0),
        Vertex(x: -1, y: -1, z: 0),
        Vertex(x: -1, y: 1, z: 0), // Triangle 2
        Vertex(x: 1, y: 1, z: 0),
        Vertex(x: 1, y: -1, z: 0),
    ]
    
    
    var vertices: [Vertex] = [
        Vertex(x: -1,  y:  1,  z: 0), // top left
        Vertex(x:  1,  y:  1,  z: 0), // top right
        Vertex(x: -1,  y: -1,  z: 0), // bottom left
        Vertex(x:  1,  y: -1,  z: 0), // bottom right
    ]
    
    var indices: [UInt16] = [
        0, 1, 3,
        0, 3, 2,
    ]
    
    var colors: [simd_float3] = [
        [1, 0, 0], // red
        [0, 1, 0], // green
        [0, 0, 1], // blue
        [1, 1, 0]  // yellow
    ]
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let colorBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1){
        vertices = vertices.map {
            Vertex(x: $0.x * scale, y: $0.y * scale, z: $0.z * scale)
        }
        guard let vertexBuffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<Vertex>.stride * vertices.count,
            options: []
        ) else {
            fatalError("Failed to create vertex buffer")
        }
        self.vertexBuffer = vertexBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []
        ) else {
            fatalError("Failed to create quad index buffer")
        }
        self.indexBuffer = indexBuffer
        
        guard let colorBuffer = device.makeBuffer(
          bytes: &colors,
          length: MemoryLayout<simd_float3>.stride * colors.count,
          options: []) else {
            fatalError("Unable to create quad color buffer")
          }
        self.colorBuffer = colorBuffer
    }
    
}
