#version 330

in vec2 texcoord;
uniform sampler2D tex;
uniform float opacity;
uniform float time;

vec3 hex2rgb(int hex) {
    return vec3(
        float((hex >> 16) & 0xFF) / 255.0,
        float((hex >> 8) & 0xFF) / 255.0,
        float(hex & 0xFF) / 255.0
    );
}

vec4 hex2rgba(int hex) {
    return vec4(
        float((hex >> 16) & 0xFF) / 255.0,
        float((hex >> 8) & 0xFF) / 255.0,
        float(hex & 0xFF) / 255.0,
        float((hex >> 24) & 0xFF) / 255.0
    );
}

#ifdef GRAIN_ENABLED
#ifdef GRAIN_PALETTE
vec4 grain_palette[] = vec4[]( GRAIN_PALETTE );
#else
vec4 grain_palette[] = vec4[](
    //vec4(0.000, 0.000, 0.000, 0.000),
    hex2rgba(0x00000000),
    vec4(0.161, 0.271, 0.341, 1.000),
    vec4(0.239, 0.400, 0.498, 1.000),
    vec4(0.404, 0.529, 0.600, 1.000),
    vec4(0.745, 0.631, 0.694, 1.000),
    vec4(0.851, 0.647, 0.753, 1.000),
    vec4(0.929, 0.749, 0.839, 1.000)
);
#endif

// interval = change X times per second
#ifndef GRAIN_INTERVAL
#define GRAIN_INTERVAL 15.0
#endif
#ifndef GRAIN_OPACITY
#define GRAIN_OPACITY 0.035
#endif

vec4 grain_old(vec4 color, vec2 uv) {
    float seconds = time / 1000.0;
    // .36593 is a random number, just to ensure the offset isn't stuck on whole-number multiples
    vec2 offset = fract(vec2(floor(seconds * GRAIN_INTERVAL)) * .36593);
    vec2 seed = fract(uv + offset);
    float grain = (fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    //color.rgb *= max(luma + grain * abs(luma * 2.0 - 1.0) * GRAIN_OPACITY, 0.0) / max(luma, 1e-5);
    float grain_strength = 1.0 - abs(luma * 2.0 - 1.0);
    grain_strength = pow(grain_strength, 0.75);
    float exposure_curve = smoothstep(0.05, 0.95, luma);
    float noisy_luma = clamp(luma + grain * 0.08, 0.0, 1.0);
    //float log_luma = log2(luma);
    //float noisy_luma = exp2(log_luma + grain * GRAIN_OPACITY);
    //float noisy_luma = luma * (1.0 + grain * GRAIN_OPACITY);
    //float noisy_luma = luma + (grain * 0.02) + (grain * GRAIN_OPACITY * luma);
    //color.rgb *= min(noisy_luma / luma, 2.0);
    //color.rgb *= noisy_luma / luma;
    //color.rgb = vec3(grain_strength * exposure_curve);
    //color.rgb = vec3(noisy_luma);

    float palette_sample = grain * (grain_palette.length() - 1);
    float grain_first = floor(palette_sample);
    float grain_second = ceil(palette_sample);
    float grain_mix = palette_sample - grain_first;
    vec4 grain_color = mix(grain_palette[uint(grain_first)],
                           grain_palette[uint(grain_second)],
                           grain_mix);

    color.rgb = mix(color.rgb, grain_color.rgb, GRAIN_OPACITY * grain_color.a);

    //uint palette_index = uint(round(grain * (grain_palette.length() - 1)));
    //vec4 grain_pixel = grain_palette[palette_index];
    //color.rgb = mix(color.rgb, grain_pixel.rgb, grain_pixel.a * GRAIN_OPACITY);
    return color;
}

vec4 grain(vec4 color, vec2 uv) {
    float seconds = time / 1000.0;
    // .36593 is a random number, just to ensure the offset isn't stuck on whole-number multiples
    vec2 offset = fract(vec2(floor(seconds * GRAIN_INTERVAL)) * .36593);
    vec2 seed = fract(uv + offset);
    // grain between -1 and 1
    float grain = (fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    float luma = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    vec3 chroma = color.rgb - luma;
    //float gain = mix(1.25, 0.9, smoothstep(0.15, 0.85, luma));
    //gain = 1.0 + 1.35 * abs(luma * 2.0 - 1.0);

    // how close to either full black or full white are we?
    // change luma to a range of [-1, 1] instead of [0, 1] then get the absolute value
    float luma_extremes_weight = abs(luma * 2.0 - 1.0);
    // filter the weights to lower the influence of midtones
    float gain_filter = smoothstep(0.85, 0.95, luma_extremes_weight);
    float gain = 1.0 + (gain_filter * 1.10);

    //vec3 chroma_dir = (luma > 0.005) ? color.rgb / luma : vec3(1.0);
    //color.rgb = chroma_dir * (luma + grain * 0.04);
    //color.rgb = (color.rgb / luma) * (luma + grain * 0.04);
    color.rgb = chroma + (luma + grain * GRAIN_OPACITY * gain) * color.a;
    //color.rgb = vec3(gain_filter);
    //color.rgb /= (1.0 + max(0.0, max(max(color.r, color.g), color.b) - 1.0));

    //color.rgb = mix(color.rgb, vec3(grain), GRAIN_OPACITY);
    return color;
}
#endif

#ifdef RECOLOR_ENABLED
#ifdef RECOLOR_PALETTE
vec4 recolor_palette[] = vec4[]( RECOLOR_PALETTE );
#else
vec4 recolor_palette[] = vec4[](
    vec4(0.027, 0.047, 0.059, 1.000),
    //vec4(0.035, 0.059, 0.071, 1.000),
    vec4(0.043, 0.075, 0.090, 1.000),
    hex2rgba(0xff294557),
    hex2rgba(0xff3d667f),
    hex2rgba(0xff678799),
    hex2rgba(0xff678799),
    hex2rgba(0xff678799),
    hex2rgba(0xffbea1b1),
    hex2rgba(0xffd9a5c0),
    hex2rgba(0xffedc0d7),
    //hex2rgba(0xffffcfe8),
    //hex2rgba(0xffffebf5)
    hex2rgba(0xffffffff)
);
#endif

float pixel_is_greyscale(vec3 color) {
    //float d = max(max(abs(color.r - color.g), abs(color.g - color.b)), abs(color.r - color.b));
    float d = max(abs(color.r - color.g), abs(color.r - color.b));
    return step(d, 0.0);
}

float image_is_greyscale(sampler2D tex, vec2 texsize) {
    const uint vertical_sample_count = 50u;
    float step_size = texsize.y / vertical_sample_count;
    float result = 1.0;
    for (uint y = 0u; y < vertical_sample_count; ++y) {
        vec2 uv_1 = vec2(0.25, float(y) * step_size);
        vec2 uv_2 = vec2(0.50, float(y) * step_size);
        vec2 uv_3 = vec2(0.75, float(y) * step_size);
        vec3 color_1 = texture2D(tex, uv_1, 0).rgb;
        vec3 color_2 = texture2D(tex, uv_2, 0).rgb;
        vec3 color_3 = texture2D(tex, uv_3, 0).rgb;
        result *= pixel_is_greyscale(color_1);
        result *= pixel_is_greyscale(color_2);
        result *= pixel_is_greyscale(color_3);
    }
    return result;
}

vec4 recolor(vec4 color, vec2 texsize) {
#ifdef RECOLOR_GREYSCALE
    color = vec4(vec3(0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b) * opacity, color.a * opacity);
#endif
    float palette_sample = color.r * (recolor_palette.length() - 1);
    float recolor_first = floor(palette_sample);
    float recolor_second = ceil(palette_sample);
    float recolor_mix = palette_sample - recolor_first;
    vec4 recolor = mix(recolor_palette[uint(recolor_first)],
                       recolor_palette[uint(recolor_second)],
                       recolor_mix);
#ifdef RECOLOR_GREYSCALE_AWARE
    float is_greyscale = image_is_greyscale(tex, texsize);
    return mix(color, recolor, is_greyscale);
#else
    return recolor;
#endif
}
#endif

vec4 default_post_processing(vec4 c);

vec4 window_shader() {
    vec2 texsize = textureSize(tex, 0);
    vec2 uv = texcoord / texsize;
    vec4 color = texture2D(tex, texcoord / texsize, 0);

#ifdef RECOLOR_ENABLED
    color = recolor(color, texsize);
#endif

#ifdef GRAIN_ENABLED
    color = grain(color, uv);
#endif

    return default_post_processing(color);
}
