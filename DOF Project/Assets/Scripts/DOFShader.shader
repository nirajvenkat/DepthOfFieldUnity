Shader "GLSL DOF shader" { // defines the name of the shader 
	SubShader { // Unity chooses the subshader that fits the GPU best
		Pass { // some shaders require multiple passes
			GLSLPROGRAM // here begins the part in Unity's GLSL

			#ifdef VERTEX 

			void main(){
			
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
			}

			#endif 


			#ifdef FRAGMENT 
			
			//FRAGMENT SHADER FOR POST-PROCESSING DEPTH OF FIELD EFFECT
			//THIS FRAGMENT SHADER IS UNTESTED

			#define PI 3.14159265

			uniform sampler2D renderedTexture; //Unity camera output will be stored to a texture 
			uniform sampler2D depthTexture; //Another texture that contains depth information to be sampled. Kind of like z-buffer
			uniform float renderedTextureWidth;
			uniform float renderedTextureHeight;
			


			float width = renderedTextureWidth; //texture width
			float height = renderedTextureHeight; //texture height

			//------------------------------------------
			//camera near and far plane

			float znear = 1.0; //camera clipping start
			float zfar = 100.0; //camera clipping end

			//user variables to be available in Unity editor
			
			uniform	float blurstart = 6.0; //blur starting distance defined in Unity, taken from Unity raycast
			uniform int samples = 16; //blur sample count 
			uniform float range = 4.0; //blur fading distance
			uniform float maxblur = 4.0; //maximum radius of blur
			uniform bool noise = true; //use noise instead of pattern dithering?
			uniform float namount = 0.0002; //sample dithering amount

			//------------------------------------------

			//generating noise/pattern texture for dithering
			vec2 rand(in vec2 coord){

				float noiseX = ((fract(1.0-coord.s*(width/2.0))*0.25)+(fract(coord.t*(height/2.0))*0.75))*2.0-1.0;
				float noiseY = ((fract(1.0-coord.s*(width/2.0))*0.75)+(fract(coord.t*(height/2.0))*0.25))*2.0-1.0;
				
				if (noise)
				{
					noiseX = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233))) * 43758.5453),0.0,1.0)*2.0-1.0;
					noiseY = clamp(fract(sin(dot(coord ,vec2(12.9898,78.233)*2.0)) * 43758.5453),0.0,1.0)*2.0-1.0;
				}
				return vec2(noiseX,noiseY);
			}

			void main(){

				vec3 col = vec3(0.0);
				
				float zdepth = texture2D(depthTexture,gl_TexCoord[0].xy).x;
				float depth = -zfar * znear / (zdepth * (zfar - znear) - zfar);
				float blur = (depth-blurstart)/range*0.5;
				blur = clamp(blur*maxblur,0.0,maxblur);
				
				
				vec2 noise = rand(gl_TexCoord[0].xy)*namount*blur;
				
				float w = (1.0/width)*blur+noise.x;
				float h = (1.0/height)*blur+noise.y;
				
				float ss = 3.6/sqrt(float(samples));
				float dz = 2.0/float(samples);
				float l = 0.0;
				float z = 1.0 - dz/2.0;
				float s = 1.0;
				
				for (int k = 0; k <= samples; k += 1){
					float r = sqrt(1.0-z);
					vec2 wh = vec2(cos(l)*r, sin(l)*r);
					col += texture2D(renderedTexture,gl_TexCoord[0].xy+vec2(wh.x*w, wh.y*h)).rgb;
					z -= dz;
					l += ss/r;
				}
				
				gl_FragColor.rgb = col/float(samples);
				gl_FragColor.a = 1.0;
			}

			#endif // here ends the definition of the fragment shader

			ENDGLSL // here ends the part in GLSL 
      }
   }
}