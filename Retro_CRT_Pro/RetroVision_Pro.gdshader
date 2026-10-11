/*
    NTSC Master Pro: The Ultimate Retro System
    Developed by Node3D Studio (YouTube: @Node3D)
    Copyright © 2026 Node3D Studio. All rights reserved.
    
    Features: 
    - Physical Chroma Bleed (Chroma Artifacting)
    - Barrel Screen Curvature
    - Dynamic Analog Noise
    - Realistic Adaptive Scanlines
    - Brightness & Contrast Control
*/

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

group_uniforms Signal_Processing;
uniform float bleed_amount : hint_range(0.0, 10.0) = 1.7;
uniform float brightness : hint_range(0.0, 2.0) = 1.1;
uniform float contrast : hint_range(0.0, 2.0) = 1.5;

group_uniforms Screen_Physical;
uniform float curvature : hint_range(0.0, 0.3) = 0.0; 
uniform float noise_strength : hint_range(0.0, 0.5) = 0.0;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.0;
uniform float scanline_count : hint_range(100.0, 1000.0) = 100.0; 

// Pseudo-random noise generator
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // 1. Barrel Distortion (Screen Curvature)
    vec2 uv = SCREEN_UV;
    vec2 centered_uv = uv * 2.0 - 1.0;
    centered_uv *= 1.0 + pow(length(centered_uv) * curvature, 2.0);
    uv = centered_uv * 0.5 + 0.5;
    
    // Check bounds for curvature clipping
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // 2. Derivative-based local pixel size
        vec2 local_ps = vec2(length(vec2(dFdx(UV.x), dFdx(UV.y))), 
                             length(vec2(dFdy(UV.x), dFdy(UV.y))));
        vec2 offset = vec2(local_ps.x * bleed_amount, 0.0);
        
        // 3. Time-based Dynamic Noise
        float n = (random(uv + TIME) - 0.5) * noise_strength;
        
        // 4. Chroma Bleed Sampling (L-C-R Mix)
        vec3 c = texture(screen_texture, uv).rgb + n;
        vec3 l = texture(screen_texture, uv - offset).rgb + n;
        vec3 r = texture(screen_texture, uv + offset).rgb + n;
        
        vec3 chroma = (c * 0.4) + (l * 0.3) + (r * 0.3);
        
        // 5. Adaptive Scanline Generation
        float scanline = sin(uv.y * scanline_count * PI * 2.0);
        scanline = pow((scanline * 0.5 + 0.5), 0.1); 
        
        // Mix scanlines with chroma signal
        vec3 final = mix(chroma, chroma * scanline, scanline_strength);
        
        // 6. Gamma Correction & Color Grading
        final = pow(max(vec3(0.0), final), vec3(1.05));
        final = (final - 0.5) * contrast + 0.5 + (brightness - 1.0);
        
        COLOR = vec4(clamp(final, 0.0, 1.0), 1.0);
    }
}