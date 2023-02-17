#version 440

layout (location = 0) in vec4 point_A;
layout (location = 1) in vec4 point_B;
layout (location = 2) in vec4 point_C;
layout (location = 3) in vec4 point_D;
layout (location = 4) in int id;

out vec4 vs_position;
out mat4 vs_Object4DMat;
struct line_segment
{
int point1;
int point2;
};

uniform mat4 Object4DMat,ViewMat,ProjectionMat;
uniform vec4 Translate4D;
uniform float View_Position_D4;
vec4 pA,pB,pC,pD;
line_segment lineSegment;
bool isA,isB,isC,isD,valid;
bool p0000,p0001,p0010,p0011,p0100,p0101,p0110,p0111,p1000,p1001,p1010,p1011,p1100,p1101,p1110,p1111;
vec4 lerp(vec4 A,vec4 B,float C){
return A*(1.f-C)+B*C;
}
void main()
{

pA=Object4DMat *point_A+Translate4D;
pB=Object4DMat *point_B+Translate4D;
pC=Object4DMat *point_C+Translate4D;
pD=Object4DMat *point_D+Translate4D;

if(pA.w>View_Position_D4){
isA=true;}
if(pA.w<View_Position_D4){
isA=false;}
if(pB.w>View_Position_D4){
isB=true;}
if(pB.w<View_Position_D4){
isB=false;}
if(pC.w>View_Position_D4){
isC=true;}
if(pC.w<View_Position_D4){
isC=false;}
if(pD.w>View_Position_D4){
isD=true;}
if(pD.w<View_Position_D4){
isD=false;}
//1
p1111=isA==true&&isB==true&&isC==true&&isD==true;
if(id==0&&p1111){
valid=false;}
if(id==1&&p1111){
valid=false;}
if(id==2&&p1111){
valid=false;}
if(id==3&&p1111){
valid=false;}
//2
p0111=isA==false&&isB==true&&isC==true&&isD==true;
if(id==0&&p0111){
lineSegment.point1=1;
lineSegment.point2=2;
valid=true;}
if(id==1&&p0111){
lineSegment.point1=1;
lineSegment.point2=3;
valid=true;}
if(id==2&&p0111){
lineSegment.point1=1;
lineSegment.point2=4;
valid=true;}
if(id==3&&p0111){
valid=false;}
//3
p1011=isA==true&&isB==false&&isC==true&&isD==true;
if(id==0&&p1011){
lineSegment.point1=2;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1011){
lineSegment.point1=2;
lineSegment.point2=3;
valid=true;}
if(id==2&&p1011){
lineSegment.point1=2;
lineSegment.point2=4;
valid=true;}
if(id==3&&p1011){
valid=false;}
//4
p1101=isA==true&&isB==true&&isC==false&&isD==true;
if(id==0&&p1101){
lineSegment.point1=3;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1101){
lineSegment.point1=3;
lineSegment.point2=2;
valid=true;}
if(id==2&&p1101){
lineSegment.point1=3;
lineSegment.point2=4;
valid=true;}
if(id==3&&p1101){
valid=false;}
//5
p1110=isA==true&&isB==true&&isC==true&&isD==false;
if(id==0&&p1110){
lineSegment.point1=4;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1110){
lineSegment.point1=4;
lineSegment.point2=2;
valid=true;}
if(id==2&&p1110){
lineSegment.point1=4;
lineSegment.point2=3;
valid=true;}
if(id==3&&p1110){
valid=false;}
//6
p0011=isA==false&&isB==false&&isC==true&&isD==true;
if(id==0&&p0011){
lineSegment.point1=1;
lineSegment.point2=3;
valid=true;}
if(id==1&&p0011){
lineSegment.point1=1;
lineSegment.point2=4;
valid=true;}
if(id==2&&p0011){
lineSegment.point1=2;
lineSegment.point2=4;
valid=true;}
if(id==3&&p0011){
lineSegment.point1=2;
lineSegment.point2=3;
valid=true;}
//7
p0101=isA==false&&isB==true&&isC==false&&isD==true;
if(id==0&&p0101){
lineSegment.point1=1;
lineSegment.point2=2;
valid=true;}
if(id==1&&p0101){
lineSegment.point1=1;
lineSegment.point2=4;
valid=true;}
if(id==2&&p0101){
lineSegment.point1=3;
lineSegment.point2=4;
valid=true;}
if(id==3&&p0101){
lineSegment.point1=3;
lineSegment.point2=2;
valid=true;}
//8
p0110=isA==false&&isB==true&&isC==true&&isD==false;
if(id==0&&p0110){
lineSegment.point1=1;
lineSegment.point2=2;
valid=true;}
if(id==1&&p0110){
lineSegment.point1=1;
lineSegment.point2=3;
valid=true;}
if(id==2&&p0110){
lineSegment.point1=4;
lineSegment.point2=3;
valid=true;}
if(id==3&&p0110){
lineSegment.point1=4;
lineSegment.point2=2;
valid=true;}
//9
p1001=isA==true&&isB==false&&isC==false&&isD==true;
if(id==0&&p1001){
lineSegment.point1=2;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1001){
lineSegment.point1=2;
lineSegment.point2=4;
valid=true;}
if(id==2&&p1001){
lineSegment.point1=3;
lineSegment.point2=4;
valid=true;}
if(id==3&&p1001){
lineSegment.point1=3;
lineSegment.point2=1;
valid=true;}
//10
p1010=isA==true&&isB==false&&isC==true&&isD==false;
if(id==0&&p1010){
lineSegment.point1=2;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1010){
lineSegment.point1=2;
lineSegment.point2=3;
valid=true;}
if(id==2&&p1010){
lineSegment.point1=4;
lineSegment.point2=3;
valid=true;}
if(id==3&&p1010){
lineSegment.point1=4;
lineSegment.point2=1;
valid=true;}
//11
p1100=isA==true&&isB==true&&isC==false&&isD==false;
if(id==0&&p1100){
lineSegment.point1=3;
lineSegment.point2=1;
valid=true;}
if(id==1&&p1100){
lineSegment.point1=3;
lineSegment.point2=2;
valid=true;}
if(id==2&&p1100){
lineSegment.point1=4;
lineSegment.point2=2;
valid=true;}
if(id==3&&p1100){
lineSegment.point1=4;
lineSegment.point2=1;
valid=true;}
//12
p1000=isA==true&&isB==false&&isC==false&&isD==false;
if(id==0&&p1000){
lineSegment.point1=1;
lineSegment.point2=2;
valid=true;}
if(id==1&&p1000){
lineSegment.point1=1;
lineSegment.point2=3;
valid=true;}
if(id==2&&p1000){
lineSegment.point1=1;
lineSegment.point2=4;
valid=true;}
if(id==3&&p1000){
valid=false;}
//13
p0100=isA==false&&isB==true&&isC==false&&isD==false;
if(id==0&&p0100){
lineSegment.point1=2;
lineSegment.point2=1;
valid=true;}
if(id==1&&p0100){
lineSegment.point1=2;
lineSegment.point2=3;
valid=true;}
if(id==2&&p0100){
lineSegment.point1=2;
lineSegment.point2=4;
valid=true;}
if(id==3&&p0100){
valid=false;}
//14
p0010=isA==false&&isB==false&&isC==true&&isD==false;
if(id==0&&p0010){
lineSegment.point1=3;
lineSegment.point2=1;
valid=true;}
if(id==1&&p0010){
lineSegment.point1=3;
lineSegment.point2=2;
valid=true;}
if(id==2&&p0010){
lineSegment.point1=3;
lineSegment.point2=4;
valid=true;}
if(id==3&&p0010){
valid=false;}
//15
p0001=isA==false&&isB==false&&isC==false&&isD==true;
if(id==0&&p0001){
lineSegment.point1=4;
lineSegment.point2=1;
valid=true;}
if(id==1&&p0001){
lineSegment.point1=4;
lineSegment.point2=2;
valid=true;}
if(id==2&&p0001){
lineSegment.point1=4;
lineSegment.point2=3;
valid=true;}
if(id==3&&p0001){
valid=false;}
//16
p0000=isA==false&&isB==false&&isC==false&&isD==false;
if(id==0&&p0000){
valid=false;}
if(id==1&&p0000){
valid=false;}
if(id==2&&p0000){
valid=false;}
if(id==3&&p0000){
valid=false;}

if(valid==true)
{

if(lineSegment.point1*lineSegment.point2==2){//AB
vs_position=lerp(pA,pB,(View_Position_D4-pA.w)/(pB.w-pA.w));}
if(lineSegment.point1*lineSegment.point2==3){//AC
vs_position=lerp(pA,pC,(View_Position_D4-pA.w)/(pC.w-pA.w));}
if(lineSegment.point1*lineSegment.point2==4){//AD
vs_position=lerp(pA,pD,(View_Position_D4-pA.w)/(pD.w-pA.w));}
if(lineSegment.point1*lineSegment.point2==6){//BC
vs_position=lerp(pB,pC,(View_Position_D4-pB.w)/(pC.w-pB.w));}
if(lineSegment.point1*lineSegment.point2==8){//BD
vs_position=lerp(pB,pD,(View_Position_D4-pB.w)/(pD.w-pB.w));}
if(lineSegment.point1*lineSegment.point2==12){//CD
vs_position=lerp(pC,pD,(View_Position_D4-pC.w)/(pD.w-pC.w));}
vs_Object4DMat=Object4DMat;
gl_Position = ProjectionMat * ViewMat * vec4(vs_position.xyz, 1.f);

}

}
