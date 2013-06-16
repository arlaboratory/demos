uniform sampler2D DiffuseColor;
varying mediump vec2 vOutTxCoords;
	
void main (void)
{
	mediump vec3 diffuse = texture2D( DiffuseColor, vOutTxCoords ).rgb;
	mediump float fTextureAlpha = texture2D( DiffuseColor, vOutTxCoords ).a;

	if ( diffuse.x < 0.0001 && diffuse.y < 0.0001 && diffuse.z < 0.0001 )
		discard;
	
	gl_FragColor = vec4( diffuse*alpha, alpha );
}
