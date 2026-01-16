uniform vec2 center; 
uniform vec2 resolution;
uniform float time;
uniform vec2 mouse; 
uniform float pulse1;
uniform float pulse2;
uniform float pulse3; 


#define PI 3.14159265359


mat2 rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}


vec3 palette(float t) {
        vec3 a = vec3(4.5, 1, 6.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557) * 0.4104 + vec3(0.3, 0.2, 0.1) * (1.0 - 0.4104);
    return a + b * cos(6.28318 * (c * t + d));
}


float sdOctahedron(vec3 p, float s) {
    p = abs(p);
    return (p.x + p.y + p.z - s) * 0.57735027;
}


float map(vec3 p, float time) {
    
    p.xy *= rot(p.z * (0.1 * 1.3618) + time * 0.1 * 0.1257);

    
    vec3 q = p;
    float repSize = 2.0 / 0.6964;
    q = mod(q, repSize) - repSize * 0.5;

    
    q.xy *= rot(time * 1.6628);
    q.xz *= rot(time * 0.5 * 1.6628);

    
    float shapeSize = 0.7 * 0.6964;
    float d = sdOctahedron(q, shapeSize);
    float thickness = 0.05 + 0.5886 * 0.1;
    d = abs(d) - thickness;

    
    float box = length(max(abs(q) - 0.2, 0.0));
    d = min(d, box);

    return d;
}

void main(){
    vec2 uv = (gl_FragCoord.xy * 2.0 - resolution.xy.xy) / resolution.xy.y;
    vec2 uv0 = uv;

    
    if (0.0000 > 0.0) {
        float angle = atan(uv.y, uv.x);
        float radius = length(uv);
        float segments = floor(4.0 + 0.0000 * 12.0);
        float segmentAngle = 6.28318 / segments;
        angle = mod(angle + PI, segmentAngle) - segmentAngle * 0.5;
        uv = vec2(cos(angle), sin(angle)) * radius;
    }

    float time = time * 0.3548;

    vec3 ro = vec3(0.0, 0.0, -3.0 + time * 2.0);
    vec3 rd = normalize(vec3(uv, 1.0));
    vec3 col = vec3(0.0);

    float t = 0.0;

    
    for (int i = 0; i < 40; i++) {
        vec3 p = ro + rd * t;

        float d = map(p, time);

        t += d;

        if (d < 0.01 || t > 20.0) break;

        
        float glowBase = 0.002 * 1.6965;
        float glow = glowBase / (abs(d) + 0.001);

        float fade = exp(-t * 0.15 * (2.0 - 0.0859));

        vec3 shapeColor = palette(length(uv0) + time * 0.4 + float(i) * 0.04);

        col += shapeColor * glow * fade;
    }

    
    col = 1.0 - exp(-col * 1.0);

    
    col = pow(col, vec3(0.4545));

    gl_FragColor = vec4(col, 1.0);
}
