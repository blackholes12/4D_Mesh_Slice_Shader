#version 440

layout (location = 0) in vec4 vertex_A;
layout (location = 1) in vec4 vertex_B;
layout (location = 2) in vec4 vertex_C;
layout (location = 3) in vec4 vertex_D;

layout (location = 4) in vec3 texcoord_A;
layout (location = 5) in vec3 texcoord_B;
layout (location = 6) in vec3 texcoord_C;
layout (location = 7) in vec3 texcoord_D;

layout (location = 8) in vec4 normal_A;
layout (location = 9) in vec4 normal_B;
layout (location = 10) in vec4 normal_C;
layout (location = 11) in vec4 normal_D;

layout (location = 12) in int id;

out vec4 vs_position;
out vec3 vs_texcoord;
out vec4 vs_normal;

uniform mat4 Object4DMat,viewMat,projectionMat;
uniform vec4 Translate4D;
uniform vec4 cameraPos;

vec4 pA,pB,pC,pD;
int line;
int i,vertexAmount;

vec4 relativePos0,relativePos,pos0;

float disA,disB,disC,disD;

vec3 lerp(vec3 A,vec3 B,float C){
return A+(B-A)*C;
}
vec4 lerp(vec4 A,vec4 B,float C){
return A+(B-A)*C;
}

vec3 vector3;
vec3 slice(vec3 A,vec3 B,vec3 C,vec3 D,float disA,float disB,float disC,float disD,int line)
{
switch(line)
{
case 2:vector3=lerp(A,B,(disA)/(disA-disB));break;
case 3:vector3=lerp(A,C,(disA)/(disA-disC));break;
case 4:vector3=lerp(A,D,(disA)/(disA-disD));break;
case 6:vector3=lerp(B,C,(disB)/(disB-disC));break;
case 8:vector3=lerp(B,D,(disB)/(disB-disD));break;
case 12:vector3=lerp(C,D,(disC)/(disC-disD));break;
}
return vector3;
}

vec4 vector4;
vec4 slice(vec4 A,vec4 B,vec4 C,vec4 D,float disA,float disB,float disC,float disD,int line)
{
switch(line)
{
case 2:vector4=lerp(A,B,(disA)/(disA-disB));break;
case 3:vector4=lerp(A,C,(disA)/(disA-disC));break;
case 4:vector4=lerp(A,D,(disA)/(disA-disD));break;
case 6:vector4=lerp(B,C,(disB)/(disB-disC));break;
case 8:vector4=lerp(B,D,(disB)/(disB-disD));break;
case 12:vector4=lerp(C,D,(disC)/(disC-disD));break;
}
return vector4;
}

void main()
{
relativePos0=Translate4D-cameraPos;
pA=viewMat*(Object4DMat *vertex_A+relativePos0);
pB=viewMat*(Object4DMat *vertex_B+relativePos0);
pC=viewMat*(Object4DMat *vertex_C+relativePos0);
pD=viewMat*(Object4DMat *vertex_D+relativePos0);

disA=pA.w;
disB=pB.w;
disC=pC.w;
disD=pD.w;
if(disA>0)
{
  if(disB>0)
  {
    if(disC>0)
	{
	  if(disD>0)
	  {
	  vertexAmount=0;//1111
	  }
	  else
	  {
	    switch(id)
	    {
	    case 0:line=4;break;//DA
	    case 1:line=8;break;//DB
	    case 2:line=12;break;//DC
	    }
      vertexAmount=3;//1110
	  }
	}
	else
	{
	  if(disD>0)
	  {
	   switch(id)
	    {
	    case 0:line=12;break;//CD
	    case 1:line=6;break;//CB
	    case 2:line=3;break;//CA
	    }
      vertexAmount=3;//1101
	  }
	  else
	  {
	   switch(id)
	    {
	    case 0:line=6;break;//CB
	    case 1:line=3;break;//CA
	    case 2:line=4;break;//DA
		case 3:line=8;break;//DB
	    }
      vertexAmount=4;//1100
	  }
	}
  }
  else
  {
    if(disC>0)
	{
	  if(disD>0)
	  {
	   switch(id)
	    {
	    case 0:line=2;break;//BA
	    case 1:line=6;break;//BC
	    case 2:line=8;break;//BD
	    }
      vertexAmount=3;//1011
	  }
	  else
	  {
	  switch(id)
	    {
	    case 0:line=4;break;//DA
	    case 1:line=2;break;//BA
	    case 2:line=6;break;//BC
		case 3:line=12;break;//DC
	    }
      vertexAmount=4;//1010
	  }
	}
	else
	{
	  if(disD>0)
	  {
	    switch(id)
	    {
	    case 0:line=8;break;//BD
	    case 1:line=2;break;//BA
	    case 2:line=3;break;//CA
		case 3:line=12;break;//CD
	    }
      vertexAmount=4;//1001
	  }
	  else
	  {
	   switch(id)
	    {
	    case 0:line=3;break;//AC
	    case 1:line=4;break;//AD
	    case 2:line=2;break;//AB
	    }
      vertexAmount=3;//1000
	  }
	}
  }
}
else
{
  if(disB>0)
  {
    if(disC>0)
	{
	  if(disD>0)
	  {
	    switch(id)
	    {
	    case 0:line=2;break;//AB
	    case 1:line=4;break;//AD
	    case 2:line=3;break;//AC
	    }
      vertexAmount=3;//0111
	  }
	  else
	  {
	    switch(id)
	    {
	    case 0:line=3;break;//CA
	    case 1:line=2;break;//BA
	    case 2:line=8;break;//BD
		case 3:line=12;break;//CD
	    }
      vertexAmount=4;//0110
	  }
	}
	else
	{
	  if(disD>0)
	  {
	  	switch(id)
	    {
	    case 0:line=6;break;//CB
	    case 1:line=2;break;//AB
	    case 2:line=4;break;//AD
		case 3:line=12;break;//CD
	    }
      vertexAmount=4;//0101
	  }
	  else
	  {
	   switch(id)
	    {
	    case 0:line=8;break;//BD
	    case 1:line=6;break;//BC
	    case 2:line=2;break;//BA
	    }
      vertexAmount=3;//0100
	  }
	}
  }
  else
  {
    if(disC>0)
	{
	  if(disD>0)
	  {
	  	switch(id)
	    {
	    case 0:line=4;break;//AD
	    case 1:line=3;break;//AC
	    case 2:line=6;break;//BC
		case 3:line=8;break;//BD
	    }
      vertexAmount=4;//0011
	  }
	  else
	  {
	    switch(id)
	    {
	    case 0:line=3;break;//CA
	    case 1:line=6;break;//BC
	    case 2:line=12;break;//CD
	    }
      vertexAmount=3;//0010
	  }
	}
	else
	{
	  if(disD>0)
	  {
	    switch(id)
	    {
	    case 0:line=12;break;//CD
	    case 1:line=8;break;//BD
	    case 2:line=4;break;//DA
	    }
      vertexAmount=3;//0001
	  }
	  else
	  {
	  vertexAmount=0;//0000
	  }
	}
  }
}

if(vertexAmount==3&&id==3)
{
pos0=slice(pA,pB,pC,pD,disA,disB,disC,disD,line);
}
else
{
pos0=slice(pA,pB,pC,pD,disA,disB,disC,disD,line);
vs_texcoord=slice(texcoord_A,texcoord_B,texcoord_C,texcoord_D,disA,disB,disC,disD,line);
vs_normal=slice(normal_A,normal_B,normal_C,normal_D,disA,disB,disC,disD,line);
}

vs_position=pos0*viewMat+cameraPos;
gl_Position = projectionMat * vec4(pos0.xyz, 1.f);
}
