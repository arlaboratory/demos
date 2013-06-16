
attribute highp vec3	inVertex;
attribute mediump vec3	inNormal;
attribute mediump vec2	inTxCoords;

attribute highp vec4    inBoneIndex;
attribute mediump vec4  inBoneWeights;

uniform sampler2D 		DiffuseColor;

uniform mediump mat4	inProjMatrix;
uniform mediump mat4	inCameraMatrix;
uniform highp mat4		inObjectGlobalMatrix;

uniform highp   mat4 	BoneMatrixArray[ NUM_BONES ];

#if defined( BUMP_CHANNEL )

	attribute highp vec3 inTangent;
	attribute highp vec3 inBinormal;

#endif


#if defined( NUM_LIGHTS ) && ( NUM_LIGHTS >= 1 )
	
	uniform highp vec4 lightPos[ NUM_LIGHTS ];
	uniform mediump float lightRadius[ NUM_LIGHTS ];

	varying mediump vec3 vLightVector[ NUM_LIGHTS ];
		
#endif

varying highp 	vec3 	vOutPos;
varying mediump vec3 	vOutNormal;
varying mediump vec2 	vOutTxCoords;
varying mediump vec3 	vViewVec;
void main( void )
{
#if ( defined BUMP_CHANNEL )

	highp vec3 vOutTangent = vec3( 0.0 );
	highp vec3 vOutBinormal = vec3( 0.0 );
	
	vOutTangent = normalize( inTangent );
	vOutBinormal = normalize( inBinormal );
	
#endif // BUMP_CHANNEL

	mediump vec4 vPos = vec4( 0.0 );
	
	mediump vec3 vNormal = vec3( 0.0 );

	mediump vec4 blendWeight = inBoneWeights;
	highp ivec4 blendBone = ivec4( inBoneIndex );

    for( mediump float i = 0.0; i < 4.0; i += 1.0 )
	{    
		if( blendWeight.x > 0.0 )
		{
			highp mat4 m44 = BoneMatrixArray[ blendBone.x ];

			vPos += vec4( ( m44 * vec4( inVertex, 1.0 ) ).xyz, 1.0 ) * blendWeight.x;

			mediump mat3 m33 = mat3( m44[0].xyz,
                                     m44[1].xyz,
                                     m44[2].xyz );
                       
			vNormal += m33 * normalize(inNormal) * blendWeight.x;

			blendBone = blendBone.yzwx;
			blendWeight = blendWeight.yzwx;
		}
		else break;
	}

//    vPos = vec4( inVertex, 1.0 );

#if defined( NUM_LIGHTS ) && ( NUM_LIGHTS >= 1 )
		
	//vViewVec = ( viewPos - vOutPos ).xyz;
	//vViewVec = vec3( 0.0, 1.0, 0.0 );

							 
	vViewVec = -normalize((inCameraMatrix * vec4( inVertex, 1.0 )).xyz);
	


#if ( defined BUMP_CHANNEL )

	vViewVec.x = dot( vViewVec, vOutTangent );
	vViewVec.y = dot( vViewVec, vOutBinormal );
	vViewVec.z = dot( vViewVec, vOutNormal );

#endif // BUMP_CHANNEL
		
	mediump vec3 temp_light_vector;
	for( int i = 0; i < NUM_LIGHTS; ++i )
	{
		temp_light_vector = lightPos[ i ].xyz - vPos.xyz;

#if ( defined BUMP_CHANNEL )
		vLightVector[ i ].x = dot( temp_light_vector, vOutTangent );
		vLightVector[ i ].y = dot( temp_light_vector, vOutBinormal );
		vLightVector[ i ].z = dot( temp_light_vector, vOutNormal );
#else
		vLightVector[ i ] = temp_light_vector;
		
#endif // BUMP_CHANNEL
	}
		
#endif 

	vPos = inCameraMatrix * vPos;
	gl_Position = inProjMatrix * vPos;

	vOutPos = vPos.xyz;
	vOutNormal = vNormal;
	vOutTxCoords = inTxCoords;
}

