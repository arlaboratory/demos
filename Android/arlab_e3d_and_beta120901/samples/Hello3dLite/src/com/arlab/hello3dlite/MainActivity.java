/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.arlab.hello3dlite;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.arlab.enginelight.EADResult;
import com.arlab.enginelight.EAGLView;
import com.arlab.enginelight.EngineRenderCallbacks;
import com.arlab.enginelight.ModelTouchCallback;
import com.arlab.enginelight.SensorDataManager;


@SuppressLint({ "FloatMath", "FloatMath" })
public class MainActivity extends Activity implements EngineRenderCallbacks,ModelTouchCallback{


	// Objects Ids
	int MainModelRootID;
	int skeletonAnimationID;
	int skyModelID;
	int buttonsModelRootID;
	int LeftButtonModelID;
	int MidButtonModelID;
	int RightButtonModelID;
	
	int hairID;
	int leftLegId;
	int rightLegId;
	int swordId;
	
	int rootModelEAD_ID;
	int skyEAD_ID;
	
	float head_rotation_angle=0;
	boolean head_rotation_b=true;
	final double HEAD_MAX_ROTATION=360/10;
	
	boolean firstrun = true;
	float fAngle = 0.0f;
	float fAngleSky = 0.0f;
	
	// Values arrays
	float[] tempArray = new float[3] ;
	float[] camPosition = new float[] {0.0f,30.0f,175.0f};
	float[] targetPosition = new float[] {0.0f,5.0f,0.0f};
	float[] modelScale = new float[] {2.0f,2.0f,2.0f};
	
	// Library instance variable
	private EAGLView gl3DEngine;
	
	// Sensor manager instance variable
	private SensorDataManager sensorDataManager; 
	
	
	private static String TAG = "Hello3dLite";
	
    @Override protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);
     
      
       /** Create the OpenGL view instance  */
        gl3DEngine = new EAGLView(this, "9OMdoCXfeLMzLKpn2J2Cq4dAuE7Bz6MR2YdZZMa12Q==", this);	 
        
       /** Set library instance to view content  */
        setContentView(gl3DEngine);	  
        
        /** Initiate sensor manager  */
        sensorDataManager = new SensorDataManager(this, false);
        
    }
    
    @Override protected void onPause() {
        super.onPause();
        sensorDataManager.stopSensorReading();
        gl3DEngine.onPause();
    }

    @Override protected void onResume() {
        super.onResume();
        sensorDataManager.startSensorReading();
    }

    
    @Override
	public void onEngineInit(int viewWidth, int viewHeight) {
    	
    	/** Load scene  on engine initiation*/
		 loadEADScene();
	}
    
	@Override
	public void onRenderFrame() {					
		//APPLIES THE MODEL MOVEMENT AROUND ITS POSITION (FLOATING EFFECT)
		if (fAngle > 360.0f)
			fAngle = 0.0f;
		fAngle += 0.75f;
		
		float s = (float) Math.sin(fAngle/8.0f),
		c = (float) Math.cos(fAngle/8.0f);
		
		tempArray[0] = c+s + 10;
		tempArray[1] = s + c -5;
		tempArray[2] = s+c + 10;
		
		/** Set model positing (Move model to other value*/
		gl3DEngine.setModelPosition(MainModelRootID, tempArray);
		
		
		// APPLIES THE SKY ROTATION
		if (fAngleSky > 3600.0f)
			fAngleSky = 0.0f;
		fAngleSky += 0.75f;

		tempArray[0] = 0.0f;
		tempArray[1] = -fAngleSky/10.0f;
		tempArray[2] = 0.0f;
		
		/** Set model rotation (applied to 3 axes)*/
		gl3DEngine.setModelRotation(skyModelID, tempArray);
				
		
		//APPLIES THE MODEL ORIENTATION DEPENDING ON DEVICE POSITION
		/** Apply rotation matrix to the model (The model gets the ability to move)*/
		gl3DEngine.setModelMatrix(MainModelRootID, sensorDataManager.getCurrentRotationMatrix());
		
		
		/** Draw current frame to OpenGL*/
		gl3DEngine.drawFrame();
		
	}
	
	
	private void loadEADScene()
	{
		EADResult eadResult; 
		
		/** Create Girl model Root object*/
		MainModelRootID =  gl3DEngine.createNewModel();	
		
		/** Load 3D Model scene graphics from file*/
		
		eadResult = gl3DEngine.loadEAD("Data/Models/girlscene/girl_model.EAD");
	    rootModelEAD_ID = eadResult.getEAD_ID();
	    
	    if(rootModelEAD_ID != -1)
	    {   
	    	/** Attach graphics to the model*/
	    	if(!gl3DEngine.attachEAD(MainModelRootID, rootModelEAD_ID))
	    		Log.d(TAG, "Error attaching girl_model.EAD");
	    	
	    	/** Get skeleton animation object from the Root model*/
		    skeletonAnimationID = gl3DEngine.getModel(rootModelEAD_ID,"ctl_girl_root");
		  
		    //Mesh object
	        hairID = gl3DEngine.getModel(rootModelEAD_ID,"m_girl_hair");
		  
  		    // Some other girl bones
		    rightLegId = gl3DEngine.getModel(rootModelEAD_ID,"ctl_leg_R");
		    leftLegId = gl3DEngine.getModel(rootModelEAD_ID,"ctl_leg_L");
		    swordId = gl3DEngine.getModel(rootModelEAD_ID,"ctl_sword");
	    	
	    }	    

	    /** Load animation to the engine*/
	    eadResult = gl3DEngine.loadEAD("Data/Models/girlscene/girl_animation_01.EAD");
	    int eadID = eadResult.getEAD_ID();
	    
	    if (eadResult.isAnimationLoaded())
	    { 
	    	Log.d(TAG, "Animation loaded girl_animation_01.EAD");
	    }
	    
	    /** Load animation to the engine*/
	    eadResult =  gl3DEngine.loadEAD("Data/Models/girlscene/girl_animation_02.EAD");
	    eadID = eadResult.getEAD_ID();
	    
	    if (eadResult.isAnimationLoaded())
	    { 
	    	Log.d(TAG, "Animation loaded girl_animation_02.EAD");
	    }
	    
	    /** Load animation to the engine*/
	    eadResult =  gl3DEngine.loadEAD("Data/Models/girlscene/girl_animation_03.EAD");
	    eadID = eadResult.getEAD_ID();
	    
	    if (eadResult.isAnimationLoaded())
	    { 
	    	Log.d(TAG, "Animation loaded girl_animation_03.EAD");
	    }
	    	    
	    
	    if(skeletonAnimationID != -1)
	    {
	    	/** Set animation to the model*/
	    	if(gl3DEngine.setAnimation(skeletonAnimationID, "girl_animation_01"))
	    	{
	    		/** Play animation previously set*/
		    	if(!gl3DEngine.playAnimation(skeletonAnimationID, true))
		    		Log.d(TAG, "Error playing girl_animated");
	    	}
	    	   	
	    }
	           
	    /** Create Sky model root object*/
	    skyModelID =  gl3DEngine.createNewModel();	
	    
	    /** Load Sky scene graphics from file*/
	    eadResult =   gl3DEngine.loadEAD("Data/Models/girlscene/skydome.EAD");
	    skyEAD_ID = eadResult.getEAD_ID();
	    
	    if(skyEAD_ID != -1)
	    {
	    	/** Attach graphics to the model*/
	    	if(!gl3DEngine.attachEAD(skyModelID, skyEAD_ID))
	    		Log.d(TAG, "Error attaching skydome.EAD");
	    }
	    
	    
	    /** Create Buttons model Root object*/
	    buttonsModelRootID = gl3DEngine.createNewModel();
	    
	    /** Load Button scene graphics from file*/
	    eadResult =  gl3DEngine.loadEAD("Data/Models/girlscene/buttons.EAD");
	    eadID = eadResult.getEAD_ID();
	    if(eadID != -1)
	    {
	    	/** Attach graphics to the model*/
	    	if(gl3DEngine.attachEAD(buttonsModelRootID, eadID))
	    	{
	    		/** Create left button from the Root button model*/
		    	LeftButtonModelID = gl3DEngine.getModel(eadID,"button01");
		    	
		    	/** Create middle button from the Root button model*/
		    	MidButtonModelID = gl3DEngine.getModel(eadID,"button02");
		    	
		    	/** Create right button from the Root button model*/
		    	RightButtonModelID = gl3DEngine.getModel(eadID,"button03");

		    	gl3DEngine.setOnModelTouchListener(LeftButtonModelID, this);
		    	gl3DEngine.setOnModelTouchListener(MidButtonModelID, this);
		    	gl3DEngine.setOnModelTouchListener(RightButtonModelID, this);
	    	}
	    	
	    }    
	    
	    /** Load scene Lights from file*/
	    eadResult = gl3DEngine.loadEAD("Data/Models/girlscene/girl_lights.EAD");
	    eadID = eadResult.getEAD_ID();
	    if (eadID > -1)
	    { }
	        
	    gl3DEngine.setAnimationLoop(skeletonAnimationID, true);
	    
	    /** Set Sky Model to not be affected by those lights*/
	    gl3DEngine.setAffectedByLights(skyModelID, false, true);
	    
	    /** Set Buttons Model to not be affected by those lights*/
	    gl3DEngine.setAffectedByLights(buttonsModelRootID, false, true);
	    	    	    	  	    
	    /** Set Initial camera position in the scene*/
	    gl3DEngine.setCameraPosition(camPosition);	  
	    
	    /** Set Initial camera target position in the scene*/
	    gl3DEngine.setCameraTargetPosition(targetPosition);
	    
	    gl3DEngine.setModelRotationOffset(MainModelRootID,90, 0, 0);	
	    
	    /** Set Model initial scale*/
		gl3DEngine.setModelScale(MainModelRootID, modelScale);
		
		
		 
	}

	
	@Override
	public void onModelTouched(int modelId) {
		if (modelId==LeftButtonModelID) {
		
			/** Set animation to the model*/
   			if(gl3DEngine.setAnimation(skeletonAnimationID, "girl_animation_01"))
   			{
   				/** Play animation previously set*/
   				if(!gl3DEngine.playAnimation(skeletonAnimationID,true))
   					Log.d(TAG, "Error playing girl_animation_01");
   					
   			}
   			Log.d(TAG, "Left Button clicked");
		}else 	if (modelId==MidButtonModelID) {
			/** Set animation to the model*/
   			if(gl3DEngine.setAnimation(skeletonAnimationID, "girl_animation_02"))
   			{
   				/** Play animation previously set*/
   				if(!gl3DEngine.playAnimation(skeletonAnimationID,true))
   					Log.d(TAG, "Error playing girl_animation_02");
   					
   			}
   			Log.d(TAG, "Middle Button clicked");
		}else 	if (modelId==RightButtonModelID) {
			/** Set animation to the model*/
   			if(gl3DEngine.setAnimation(skeletonAnimationID, "girl_animation_03"))
   			{
   				/** Play animation previously set*/
   				if(!gl3DEngine.playAnimation(skeletonAnimationID,true))
   					Log.d(TAG, "Error playing girl_animation_03");
   					
   			}
   			Log.d(TAG, "Right Button clicked");
   		}
		
			
	}

	
	
	

}
