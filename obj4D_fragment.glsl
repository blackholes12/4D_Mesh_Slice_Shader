#version 440

#define Max_4DPoint_Light_Amount 12

in vec4 vs_position;
in vec4 vs_normal;
in vec4 vs_cameraPos;
out vec4 fs_color;
vec3 diffuse_color,specular_color,color,ambient_color,direction_color;
const vec4 GRID_DIMS = vec4(0.5f, 0.5f, 0.5f, 0.5f);
vec4 a;
vec4 m;
bool isBright,isReflect;

vec4 pToL;
float diffuse2,direction2,transparency;
vec3 diffuseFinal2,directionFinal2;

struct PointLight4D
{
	vec4 position4D;
	float intensity;
	vec3 color;
	float constant;
	float linear;
	float quadratic;
	float cubic;
};
struct DirectionLight4D
{
	vec4 direction4D;
	float intensity;
	vec3 color;
};
uniform int D4_PointLightAmount;
uniform PointLight4D[Max_4DPoint_Light_Amount] pointLight4D;
uniform int colortype;
uniform vec4 cameraPos;
uniform sampler3D NoiseTex3D;
DirectionLight4D directionLight4D;
int i;
vec3[Max_4DPoint_Light_Amount] diffuseFinal;
vec3[Max_4DPoint_Light_Amount] specularFinal;
float[Max_4DPoint_Light_Amount] distance;
float[Max_4DPoint_Light_Amount] attenuation;
float viewDistance;

vec3 calculateDiffuse(vec4 vs_position, vec4 vs_normal, vec4 lightPos0,float intensity)
{
if(length(lightPos0 - vs_position)<30*intensity)
	{
	pToL = normalize(lightPos0 - vs_position);
	
	diffuse2 = dot(pToL,vs_normal);
	if(diffuse2>0){
	diffuseFinal2 = vec3(1.f)*max(diffuse2,0.f);
	return diffuseFinal2;
	}
	if(diffuse2<=0)
	{
	return vec3(0.f);
	}
	}
}
 vec4 lightToPosDirVec2;
	vec4 reflectDirVec2;
	vec4 posToViewDirVec2;
	float specularConstant2;
	vec3 specularFinal2;
vec3 calculateSpecular(vec4 vs_position, vec4 vs_normal, vec4 lightPos0, vec4 cameraPos,float intensity)
{
if(length(lightPos0 - vs_position)<30*intensity)
	{
	lightToPosDirVec2 = normalize(vs_position - lightPos0);
	if(dot(lightToPosDirVec2,vs_normal)<0){
	reflectDirVec2 = normalize(reflect(lightToPosDirVec2, normalize(vs_normal)));
	posToViewDirVec2 = normalize(cameraPos - vs_position);
	specularConstant2 = pow(max(dot(posToViewDirVec2, reflectDirVec2), 0), 35);
	specularFinal2 = vec3(1.f)*specularConstant2;
	return specularFinal2;
	}
	else{
	return vec3(0.f);
	}
	}
}
vec3 calculateDirection(vec4 vs_normal, vec4 direction)
{
	direction2 = -dot(normalize(direction),vs_normal);
	if(direction2>0){
	directionFinal2 = vec3(1.f)*direction2;
	return directionFinal2;
	}
}

vec3 lerp(vec3 A,vec3 B,float C){
return A*(1.f-C)+B*C;
}
float factorR,factorG,factorB;
vec3 fog(vec3 A,vec3 B,float far)
{
factorR=exp(-0.25*far);
factorG=exp(-0.51*far);
factorB=exp(-1.17*far);
return vec3(A.r*factorR+B.r*(1.f-factorR),
A.g*factorG+B.g*(1.f-factorG),
A.b*factorB+B.b*(1.f-factorB)
);
}
vec4 cross4d(vec4 a2, vec4 a3, vec4 a4) {
	return vec4(
		a2.y * a3.z * a4.w - a2.y * a3.w * a4.z - a2.z * a3.y * a4.w + a2.z * a3.w * a4.y + a2.w * a3.y * a4.z - a2.w * a3.z * a4.y,
		-a2.x * a3.z * a4.w + a2.x * a3.w * a4.z + a2.z * a3.x * a4.w - a2.z * a3.w * a4.x - a2.w * a3.x * a4.z + a2.w * a3.z * a4.x,
		a2.x * a3.y * a4.w - a2.x * a3.w * a4.y - a2.y * a3.x * a4.w + a2.y * a3.w * a4.x + a2.w * a3.x * a4.y - a2.w * a3.y * a4.x,
		-a2.x * a3.y * a4.z + a2.x * a3.z * a4.y + a2.y * a3.x * a4.z - a2.y * a3.z * a4.x - a2.z * a3.x * a4.y + a2.z * a3.y * a4.x
	);
}

vec4 randomVector,randomVector2,axisX,axisY,axisZ;

vec3 texcoord_position(vec4 normal4d,vec4 position4d)
{
randomVector=vec4(1.f,1.00001f,2.00001f,3.00001f);
randomVector2=vec4(3.00001f,2.f,1.00001f,1.00001f);
axisX=normalize(cross4d(normal4d,randomVector,randomVector2));
axisY=normalize(cross4d(normal4d,axisX,randomVector2));
axisZ=normalize(cross4d(normal4d,axisX,axisY));

return vec3(dot(axisX,position4d),dot(axisY,position4d),dot(axisZ,position4d));
}
//3d noise
/////////////////////////////////////////////////////////////////////
float simplex3d(vec3 p) {
	 return 2.337f*(0.61f-texture(NoiseTex3D,p/26.f).r);
}

//4d noise
/////////////////////////////////////////////////////////////////////

float noisexyw(vec4 v)
  {
  return 2.337f*(0.61f-texture(NoiseTex3D,v.xyw/26.f).r);
  }
  float noisexyz(vec4 v)
  {
  return 2.337f*(0.61f-texture(NoiseTex3D,v.xyz/26.f).r);
  }
  float noisexzw(vec4 v)
  {
  return 2.337f*(0.61f-texture(NoiseTex3D,v.xzw/26.f).r);
  }
  float value;
  vec3 texPos;
void main()
{
if(colortype!=22&&colortype!=23&&colortype!=24&&colortype!=25)
{
texPos=texcoord_position(vs_normal,vs_position);
}
isReflect=true;
transparency=1.f;
if(colortype==0){//GREEN
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.16f,0.36f,0.2125f);}
if(isBright==false){color = vec3(0.36f,0.5f,0.3f);}
	
value = 1.0f+0.15f*simplex3d(texPos*64.0);
color*=value;
}

if(colortype==1){//WHITE
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.44f,0.44f,0.4125f);}
if(isBright==false){color = vec3(0.55f,0.55f,0.5225f);}

value = 1.0f+0.15f*simplex3d(texPos*64.0);
color*=value;
}

if(colortype==2){//YELLOW
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;

if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.4185f,0.39525f,0.372f);}
if(isBright==false){color = vec3(0.5665f,0.5356f,0.4635f);}

value = 1.0f+0.15f*simplex3d(texPos*64.0);
color*=value;
}

if(colortype==3){//YELLOWGROUND
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=false;

if(m.x>0.97f){isBright=!isBright;}
if(m.y>0.97f){isBright=!isBright;}
if(m.z>0.97f){isBright=!isBright;}
if(m.w>0.97f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.4185f,0.39525f,0.372f);}
if(isBright==false){color = vec3(0.5665f,0.5356f,0.4635f);}

value = 1.0f+0.15f*simplex3d(texPos*64.0);
color*=value;
}

if(colortype>=4&&colortype<=11){//COLORS
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;

if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}

		if(colortype==4){//PURPLE
if(isBright==true){color = vec3(0.168f,0.168f,0.2625f);}
if(isBright==false){color = vec3(0.2925f,0.2025f,0.4275f);}
		}
		if(colortype==5){//BLUE
if(isBright==true){color = vec3(0.168f,0.168f,0.2625f);}
if(isBright==false){color = vec3(0.2025f,0.2925f,0.4275f);}
	    }
		if(colortype==6){//RED
if(isBright==true){color = vec3(0.2625f,0.168f,0.168f);}
if(isBright==false){color = vec3(0.4275f,0.2025f,0.2925f);}
	    }
		if(colortype==7){//GREEN2
if(isBright==true){color = vec3(0.168f,0.2625f,0.168f);}
if(isBright==false){color = vec3(0.2925f,0.4275f,0.2025f);}
	    }
		if(colortype==8){//ORANGE
if(isBright==true){color = vec3(0.2625f,0.168f,0.168f);}
if(isBright==false){color = vec3(0.4275f,0.2925f,0.2025f);}
		}
		if(colortype==9){//GREENBLUE
if(isBright==true){color = vec3(0.168f,0.2625f,0.168f);}
if(isBright==false){color = vec3(0.2025f,0.4275f,0.2925f);}
		}
		if(colortype==10){//CHESSBOARD
if(isBright==true){color = vec3(0.055f,0.055f,0.055f);}
if(isBright==false){color = vec3(0.55f,0.55f,0.55f);}
		}
		if(colortype==11){//WHITEMAIN
if(isBright==true){color = vec3(0.61f,0.61f,0.61f);}
if(isBright==false){color = vec3(0.69f,0.69f,0.69f);}
		}
		value = 1.0f+0.15f*simplex3d(texcoord_position(vs_normal,vs_position*64.0));
		color*=value;
}
if(colortype==12){//GREENMARBLE
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}

value = 1.0f+0.15f*simplex3d(texPos*64.0)+0.15f*simplex3d(texPos*64.0/exp(1))+0.15f*simplex3d(texPos*64.0/exp(2));	
if(isBright==true){color = vec3(0.2f,0.6f,0.25f)*vec3(0.8f,0.6f,0.85f);}
if(isBright==false){color = vec3(0.4f,1.f,0.4f)*vec3(0.9f,0.5f,0.75f);}
		color*=value;
}

if(colortype==13){//WHITEMARBLE
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.44f,0.44f,0.4125f);}
if(isBright==false){color = vec3(0.55f,0.55f,0.5225f);}

value = 1.0f+0.15f*simplex3d(texPos*64.0)+0.15f*simplex3d(texPos*64.0/exp(1))+0.15f*simplex3d(texPos*64.0/exp(2));	
color*=value;
}

if(colortype==14){//YELLOWMARBLE
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.4185f,0.39525f,0.372f);}
if(isBright==false){color = vec3(0.5665f,0.5356f,0.4635f);}
value = 1.0f+0.15f*simplex3d(texPos*64.0)+0.15f*simplex3d(texPos*64.0/exp(1))+0.15f*simplex3d(texPos*64.0/exp(2));	
color*=value;
}

if(colortype==15){//MARBLE_GROUND
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=false;
if(m.x>0.97f){isBright=!isBright;}
if(m.y>0.97f){isBright=!isBright;}
if(m.z>0.97f){isBright=!isBright;}
if(m.w>0.97f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.4185f,0.39525f,0.372f);}
if(isBright==false){color = vec3(0.5665f,0.5356f,0.4635f);}
value = 1.0f+0.15f*simplex3d(texPos*64.0)+0.15f*simplex3d(texPos*64.0/exp(1))+0.15f*simplex3d(texPos*64.0/exp(2));	
color*=value;
}

if(colortype>=16&&colortype<=21){//MARBLECOLORS
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.y>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(colortype==16){//PURPLE
if(isBright==true){color = vec3(0.168f,0.168f,0.2625f);}
if(isBright==false){color = vec3(0.2925f,0.2025f,0.4275f);}
		}
		if(colortype==17){//BLUE
if(isBright==true){color = vec3(0.168f,0.168f,0.2625f);}
if(isBright==false){color = vec3(0.2025f,0.2925f,0.4275f);}
	    }
		if(colortype==18){//RED
if(isBright==true){color = vec3(0.2625f,0.168f,0.168f);}
if(isBright==false){color = vec3(0.4275f,0.2025f,0.2925f);}
	    }
		if(colortype==19){//GREEN2
if(isBright==true){color = vec3(0.168f,0.2625f,0.168f);}
if(isBright==false){color = vec3(0.2925f,0.4275f,0.2025f);}
	    }
		if(colortype==20){//ORANGE
if(isBright==true){color = vec3(0.2625f,0.168f,0.168f);}
if(isBright==false){color = vec3(0.4275f,0.2925f,0.2025f);}
		}
		if(colortype==21){//GREENBLUE
if(isBright==true){color = vec3(0.168f,0.2625f,0.168f);}
if(isBright==false){color = vec3(0.2025f,0.4275f,0.2925f);}
		}

value = 1.0f+0.15f*simplex3d(texPos*64.0)+0.15f*simplex3d(texPos*64.0/exp(1))+0.15f*simplex3d(texPos*64.0/exp(2));	
color*=value;
}

if(colortype==22){//GRASS
isReflect=false;
value = noisexzw(vs_position*64.0)+noisexzw(vs_position*64.0/exp(1)+
noisexzw(vs_position*64.0/exp(2))+noisexzw(vs_position*64.0/exp(3)))
+noisexzw(vs_position*7.7);
color=lerp(vec3(0.36f,0.5f,0.3f),vec3(0.16f,0.36f,0.2125f),value);
}

if(colortype==23){//WOODXYZ
isReflect=false;
value = 1.0f+0.35f*noisexyw(vec4(1,1,1,0.015f)*vs_position*64.0)+0.35f*noisexyw(vec4(1,1,1,0.015f)*vs_position*64.0/exp(1))+0.35f*noisexyw(vec4(1,1,1,0.015f)*vs_position*64.0/exp(2));	
color=lerp(vec3(152.f,111.f,74.f),vec3(251.f,218.f,190.f),value)/435.2f;
}
if(colortype==24){//WOODXZW
isReflect=false;
value = 1.0f+0.35f*noisexyw(vec4(1,0.015f,1,1)*vs_position*64.0)+0.35f*noisexyw(vec4(1,0.015f,1,1)*vs_position*64.0/exp(1))+0.35f*noisexyw(vec4(1,0.015f,1,1)*vs_position*64.0/exp(2));	
color=lerp(vec3(152.f,111.f,74.f),vec3(251.f,218.f,190.f),value)/435.2f;
}
if(colortype==25){//WATER
color=vec3(0.375f,0.555f,0.835f)/1.1f;
transparency=0.5f;
}
if(colortype==26){//STARS
a=vs_position/GRID_DIMS;
m = a-floor(a);
isBright=true;
if(m.x>0.5f){isBright=!isBright;}
if(m.z>0.5f){isBright=!isBright;}
if(m.w>0.5f){isBright=!isBright;}
		
if(isBright==true){color = vec3(0.168,0.168f,0.2625f);}
	
if(isBright==false){color = vec3(0.2925f,0.2025f,0.4275f);}
		value = max(-7.6f+10.f*simplex3d(texPos*64)+3.5f*simplex3d(texPos*32),0.1f);
		color*=value;
		if(value==0.1f)
		color=vec3(0.015f);
}
directionLight4D.direction4D=vec4(-1,-2,-5,6);
directionLight4D.intensity=1.f;
directionLight4D.color=vec3(1.f);

	ambient_color=vec3(0.85f);
	for(i=0;i < D4_PointLightAmount;i++)
	{
	distance[i]=length(pointLight4D[i].position4D - vs_position);
	attenuation[i]=pointLight4D[i].intensity / (pointLight4D[i].constant+ pointLight4D[i].linear * distance[i] + pointLight4D[i].quadratic * (distance[i] * distance[i])+ pointLight4D[i].cubic * (distance[i] * distance[i]*distance[i]));
diffuseFinal[i]=calculateDiffuse(vs_position, vs_normal, pointLight4D[i].position4D,pointLight4D[i].intensity);
if(isReflect==true){
specularFinal[i] = calculateSpecular(vs_position, vs_normal, pointLight4D[i].position4D, cameraPos,pointLight4D[i].intensity);
}
if(isReflect==false){
specularFinal[i]=vec3(0);
}
diffuseFinal[i]*=20.f*attenuation[i];
specularFinal[i]*=20.f*attenuation[i];
diffuse_color+=diffuseFinal[i]*pointLight4D[i].color;
specular_color+=specularFinal[i]*pointLight4D[i].color;
}
direction_color=0.95f*calculateDirection(vs_normal, directionLight4D.direction4D);
color=color*(ambient_color+diffuse_color+specular_color+direction_color);
viewDistance=length(vs_cameraPos-vs_position);
color=fog(color,vec3(0.375f,0.555f,0.835f)/1.1f,viewDistance*0.023f);
fs_color=vec4(color,transparency);
}
