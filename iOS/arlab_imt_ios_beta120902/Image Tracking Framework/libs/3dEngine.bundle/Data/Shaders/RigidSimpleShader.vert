attribute mediump vec3	inVertex;
attribute mediump vec3	inNormal;
attribute mediump vec2	inTxCoords;


uniform highp mat4		inProjMatrix;
uniform highp mat4		inCameraMatrix;
uniform highp mat4		inObjectGlobalMatrix;
varying mediump vec2 	vOutTxCoords;
varying mediump vec3	vOutNormal;
void main(void)
{
	vOutNormal = ( inNormal.xyz );
	vOutTxCoords = inTxCoords;
	
	gl_Position = inProjMatrix * inCameraMatrix * inObjectGlobalMatrix * vec4( inVertex, 1.0 );
}
