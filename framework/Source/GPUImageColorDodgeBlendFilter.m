#import "GPUImageColorDodgeBlendFilter.h"

NSString *const kGPUImageColorDodgeBlendFragmentShaderString = SHADER_STRING
( 
 
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec4 base = texture2D(inputImageTexture, textureCoordinate);
     vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
     
     vec3 baseOverlayAlphaProduct = vec3(overlay.a * base.a);
     vec3 rightHandProduct = overlay.rgb * (1.0 - base.a) + base.rgb * (1.0 - overlay.a);
     
     vec3 firstBlendColor = baseOverlayAlphaProduct + rightHandProduct;
     vec3 overlayRGB = (overlay.rgb / overlay.a) * step(0.0, overlay.a);
     
     vec3 secondBlendColor = (base.rgb * overlay.a) / (1.0 - overlayRGB) + rightHandProduct;
     
     vec3 colorChoice = step((overlay.rgb * base.a + base.rgb * overlay.a), baseOverlayAlphaProduct);
     
     gl_FragColor = vec4(mix(firstBlendColor, secondBlendColor, colorChoice), 1.0);
 }
);

@implementation GPUImageColorDodgeBlendFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageColorDodgeBlendFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

