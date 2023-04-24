#version 440

layout (location = 0) in vec4 point_A;
layout (location = 1) in vec4 point_B;
layout (location = 2) in vec4 point_C;
layout (location = 3) in vec4 point_D;
layout (location = 4) in vec4 normal4D;
layout (location = 5) in int id;

out vec4 vs_position;
out vec4 vs_normal;
out vec4 vs_cameraPos;

struct sliced_position
{
	int line;
	vec4 point;
};

uniform mat4 Object4DMat,viewMat,projectionMat;
uniform vec4 Translate4D;
uniform vec4 cameraPos;
vec4 pA,pB,pC,pD;
sliced_position[4] slicedPosition;
int i,vertexAmount;
bool isA,isB,isC,isD,valid;
bool p0000,p0001,p0010,p0011,p0100,p0101,p0110,p0111,p1000,p1001,p1010,p1011,p1100,p1101,p1110,p1111;
vec4 relativePos,wDir;
float disA,disB,disC,disD;
vec4 lerp(vec4 A,vec4 B,float C){
return A*(1.f-C)+B*C;
}



void main()
{

pA=Object4DMat *point_A+Translate4D;
pB=Object4DMat *point_B+Translate4D;
pC=Object4DMat *point_C+Translate4D;
pD=Object4DMat *point_D+Translate4D;

wDir=normalize(vec4(0,0,0,1)*viewMat);
disA=dot(cameraPos-pA,wDir);
disB=dot(cameraPos-pB,wDir);
disC=dot(cameraPos-pC,wDir);
disD=dot(cameraPos-pD,wDir);

if(disA>0){
isA=true;}
if(disA<=0){
isA=false;}
if(disB>0){
isB=true;}
if(disB<=0){
isB=false;}
if(disC>0){
isC=true;}
if(disC<=0){
isC=false;}
if(disD>0){
isD=true;}
if(disD<=0){
isD=false;}
//1
p1111=isA==true&&isB==true&&isC==true&&isD==true;
if(p1111)
{
vertexAmount=0;
}
//2
p0111=isA==false&&isB==true&&isC==true&&isD==true;
if(p0111)
{
slicedPosition[0].line=2;//AB
slicedPosition[1].line=3;//AC
slicedPosition[2].line=4;//AD
vertexAmount=3;
}
//3
p1011=isA==true&&isB==false&&isC==true&&isD==true;
if(p1011)
{
slicedPosition[0].line=2;//BA
slicedPosition[1].line=6;//BC
slicedPosition[2].line=8;//BD
vertexAmount=3;
}
//4
p1101=isA==true&&isB==true&&isC==false&&isD==true;
if(p1101)
{
slicedPosition[0].line=3;//CA
slicedPosition[1].line=6;//CB
slicedPosition[2].line=12;//CD
vertexAmount=3;
}
//5
p1110=isA==true&&isB==true&&isC==true&&isD==false;
if(p1110)
{
slicedPosition[0].line=4;//DA
slicedPosition[1].line=8;//DB
slicedPosition[2].line=12;//DC
vertexAmount=3;
}
//6
p0011=isA==false&&isB==false&&isC==true&&isD==true;
if(p0011)
{
slicedPosition[0].line=3;//AC
slicedPosition[1].line=4;//AD
slicedPosition[2].line=8;//BD
slicedPosition[3].line=6;//BC
vertexAmount=4;
}
//7
p0101=isA==false&&isB==true&&isC==false&&isD==true;
if(p0101)
{
slicedPosition[0].line=2;//AB
slicedPosition[1].line=4;//AD
slicedPosition[2].line=12;//CD
slicedPosition[3].line=6;//CB
vertexAmount=4;
}
//8
p0110=isA==false&&isB==true&&isC==true&&isD==false;
if(p0110)
{
slicedPosition[0].line=2;//AB
slicedPosition[1].line=3;//AC
slicedPosition[2].line=12;//DC
slicedPosition[3].line=8;//DB
vertexAmount=4;
}
//9
p1001=isA==true&&isB==false&&isC==false&&isD==true;
if(p1001)
{
slicedPosition[0].line=2;//BA
slicedPosition[1].line=8;//BD
slicedPosition[2].line=12;//CD
slicedPosition[3].line=3;//CA
vertexAmount=4;
}
//10
p1010=isA==true&&isB==false&&isC==true&&isD==false;
if(p1010)
{
slicedPosition[0].line=2;//BA
slicedPosition[1].line=6;//BC
slicedPosition[2].line=12;//DC
slicedPosition[3].line=4;//DA
vertexAmount=4;
}
//11
p1100=isA==true&&isB==true&&isC==false&&isD==false;
if(p1100)
{
slicedPosition[0].line=3;//CA
slicedPosition[1].line=6;//CB
slicedPosition[2].line=8;//DB
slicedPosition[3].line=4;//DA
vertexAmount=4;
}
//12
p1000=isA==true&&isB==false&&isC==false&&isD==false;
if(p1000)
{
slicedPosition[0].line=2;//AB
slicedPosition[1].line=3;//AC
slicedPosition[2].line=4;//AD
vertexAmount=3;
}
//13
p0100=isA==false&&isB==true&&isC==false&&isD==false;
if(p0100)
{
slicedPosition[0].line=2;//BA
slicedPosition[1].line=6;//BC
slicedPosition[2].line=8;//BD
vertexAmount=3;
}
//14
p0010=isA==false&&isB==false&&isC==true&&isD==false;
if(p0010)
{
slicedPosition[0].line=3;//CA
slicedPosition[1].line=6;//CB
slicedPosition[2].line=12;//CD
vertexAmount=3;
}
//15
p0001=isA==false&&isB==false&&isC==false&&isD==true;
if(p0001)
{
slicedPosition[0].line=4;//DA
slicedPosition[1].line=8;//DB
slicedPosition[2].line=12;//DC
vertexAmount=3;
}
//16
p0000=isA==false&&isB==false&&isC==false&&isD==false;
if(p0000)
{
vertexAmount=0;
}

if((vertexAmount==3&&id!=3)||vertexAmount==4)
{
vs_normal=normal4D;
vs_cameraPos=cameraPos;

for(i=0;i<vertexAmount;i++){
if(slicedPosition[i].line==2){//AB
slicedPosition[i].point=lerp(pA,pB,(disA)/(disA-disB));}
if(slicedPosition[i].line==3){//AC
slicedPosition[i].point=lerp(pA,pC,(disA)/(disA-disC));}
if(slicedPosition[i].line==4){//AD
slicedPosition[i].point=lerp(pA,pD,(disA)/(disA-disD));}
if(slicedPosition[i].line==6){//BC
slicedPosition[i].point=lerp(pB,pC,(disB)/(disB-disC));}
if(slicedPosition[i].line==8){//BD
slicedPosition[i].point=lerp(pB,pD,(disB)/(disB-disD));}
if(slicedPosition[i].line==12){//CD
slicedPosition[i].point=lerp(pC,pD,(disC)/(disC-disD));}
}

if( dot(cross((viewMat*slicedPosition[0].point).xyz-(viewMat*slicedPosition[1].point).xyz, (viewMat*slicedPosition[0].point).xyz-(viewMat*slicedPosition[2].point).xyz),(viewMat*normal4D).xyz)<0 )
{
if(id==0){
vs_position=slicedPosition[2].point;
}
if(id==1){
vs_position=slicedPosition[1].point;
}
if(id==2){
vs_position=slicedPosition[0].point;
}
if(id==3){
vs_position=slicedPosition[3].point;
}
}
else
{
vs_position=slicedPosition[id].point;
}

}
if(vertexAmount==3&&id==3)
{
if(slicedPosition[0].line==2){//AB
vs_position=lerp(pA,pB,(disA)/(disA-disB));}
if(slicedPosition[0].line==3){//AC
vs_position=lerp(pA,pC,(disA)/(disA-disC));}
if(slicedPosition[0].line==4){//AD
vs_position=lerp(pA,pD,(disA)/(disA-disD));}
if(slicedPosition[0].line==6){//BC
vs_position=lerp(pB,pC,(disB)/(disB-disC));}
if(slicedPosition[0].line==8){//BD
vs_position=lerp(pB,pD,(disB)/(disB-disD));}
if(slicedPosition[0].line==12){//CD
vs_position=lerp(pC,pD,(disC)/(disC-disD));}
}
relativePos= viewMat*(vs_position-cameraPos);
gl_Position = projectionMat * vec4(relativePos.xyz, 1.f);
}
