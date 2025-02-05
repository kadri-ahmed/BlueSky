//
//  ImmersiveView.swift
//  VisionOS_VR
//
//  Created by Ahmed Kadri on 1/19/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Skybox entity
            guard let skyBoxEntity = self.createSkybox() else {
                print("Error: Failed to create skybox entity.")
                return
            }
            
            // Get Earth Model
            let earthEntity = await createEarthModel()!
            
            // Add to Reality View
            content.add(skyBoxEntity)
            content.add(earthEntity)
        }
    }
    
    private func createSkybox() -> Entity? {
        // Mesh
        let largeSphere = MeshResource.generateSphere(radius: 1000.0)
        
        // Material
        var skyboxMaterial = UnlitMaterial()
        do {
            let texture = try TextureResource.load(named: "StarryNight")
            skyboxMaterial.color = .init(texture: .init(texture))
            
        } catch {
            print("Error loading texture: \(error)")
        }
        
        // SkyBox Entity
        let skyBoxEntity = Entity()
        skyBoxEntity.components.set(ModelComponent(
            mesh: largeSphere, materials: [skyboxMaterial]
        ))
        
        // Map texture to inner surface
        skyBoxEntity.scale *= .init(x: -1, y: 1, z: 1)
        
        return skyBoxEntity
    }
    
    private func createEarthModel() async -> Entity? {
        guard let entity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
            fatalError("Error: failed to load entity")
        }
        return entity
    }
}

#Preview {
    ImmersiveView()
}
