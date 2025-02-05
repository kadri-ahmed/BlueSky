//
//  AstraunautExperience.swift
//  VolumesProject
//
//  Created by Ahmed Kadri on 1/23/25.
//

import SwiftUI
import RealityKit

struct AstraunautExperience: View {
    var body: some View {
        RealityView { content in
            // Load the astraunaut model (an entity)
            if let astornautEntity = try? await Entity(named: "Cosmonaut") {
                
                // Change starting position
                astornautEntity.transform.translation = [0, -0.4, 0.3]
                
                // Start animation
                if let animation = astornautEntity.availableAnimations.first {
                    astornautEntity.playAnimation(animation)
                }
                
                // Add entity to RealityView
                content.add(astornautEntity)
            }
        }
    }
}


#Preview {
    AstraunautExperience()
}
