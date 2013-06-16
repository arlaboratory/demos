uniform sampler2D DiffuseColor;
varying mediump vec2 vOutTxCoords;

void main (void)
{	
	mediump vec3 diffuse = texture2D( DiffuseColor, vOutTxCoords ).rgb;
	mediump float alpha = texture2D( DiffuseColor, vOutTxCoords ).a;	

	if ( diffuse.x < 0.0000001 && diffuse.y < 0.0000001 && diffuse.z < 0.0000001 )		discard;
	
	gl_FragColor = vec4( diffuse*alpha, alpha );
}