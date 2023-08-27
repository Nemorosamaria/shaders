
/*
    first shader, playing with impulses, palettes and fractions.
    little bit excessive, maybe I should add some fading towards edges..? 
    
    inspiration from 
*/

#define MAX_ITERATIONS 4.
#define UV_FRACTIONS 2.

// https://iquilezles.org/articles/palettes/
vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

// https://iquilezles.org/
float expImpulse( float x, float k )
{
    float h = k*x;
    return h*exp(1.0-h);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord*2.0 - iResolution.xy)/iResolution.y;
    vec2 uv0 = uv;
    vec3 color = vec3(0.0);
    
    for(float i = 0.0; i<MAX_ITERATIONS; i++) {
        uv = fract(uv * UV_FRACTIONS) - .5;
        
        float d = expImpulse(length(uv)* exp(-length(uv0)), 1.);

        vec3 col = palette(length(uv0) +i*.3 +iTime*.3,
            vec3(0.5, 0.5, 0.5), 
            vec3(0.5, 0.5, 0.5), 
            vec3(1.0, 1.0, 1.0), 
            vec3(0.30, 0.20, 0.20));

        d = sin(d*9. + iTime)/9.;
        d = abs(d);
        d = pow(0.01 / d, 1.1);

        color += col*d;
    }

    fragColor = vec4(color,1.0);
}