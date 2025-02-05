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

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    packed_float3 position;
};

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

struct Uniforms {
    float time;
};

vertex VertexOut basic_vertex(const device VertexIn* vertex_array [[ buffer(0) ]],
                            constant Uniforms &uniforms [[ buffer(1) ]],
                            unsigned int vid [[ vertex_id ]]) {
    VertexOut out;
    float3 pos = vertex_array[vid].position;
    out.position = float4(pos, 1.0);
    out.uv = pos.xy;
    return out;
}

fragment half4 basic_fragment(VertexOut in [[stage_in]],
                            constant Uniforms &uniforms [[ buffer(1) ]]) {
    float2 uv = in.uv;
    float time = uniforms.time;
    
    // Create a moving spiral pattern
    float angle = atan2(uv.y, uv.x);
    float radius = length(uv);
    
    float spiral = sin(20.0 * (angle + radius * 2.0 + time));
    float rings = sin(radius * 10.0 - time * 2.0);
    
    // Create smooth color transitions
    float3 color1 = float3(0.5 + 0.5 * sin(time), 
                          0.5 + 0.5 * sin(time + 2.094),
                          0.5 + 0.5 * sin(time + 4.189));
    float3 color2 = float3(0.5 + 0.5 * sin(time + 3.142),
                          0.5 + 0.5 * sin(time + 5.236),
                          0.5 + 0.5 * sin(time + 1.047));
    
    float pattern = (spiral + rings) * 0.5;
    float3 finalColor = mix(color1, color2, pattern);
    
    // Add a glow effect
    float glow = exp(-radius * 2.0) * 0.5;
    finalColor += float3(glow);
    
    return half4(half3(finalColor), 1.0);
}
