package com.arlab.HelloMatcherOwnCamera;

import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.PreviewCallback;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import com.arlab.imagerecognition.ARmatcher;


/**
 * Camera View class 
 * 
 */
 public class CameraView extends SurfaceView implements SurfaceHolder.Callback, PreviewCallback
{
	 	 
	private SurfaceHolder holder;
	private Camera camera;
	
	int camWidth = 0;
	int camHeight = 0;

	private ARmatcher recognizer = null;		   
	boolean isPreviewRunning;

	public CameraView(Context context, int widht,int height,ARmatcher matcher) 
	{
		super(context);	
								
		recognizer = matcher;	
		camWidth = widht;
		camHeight = height;
						
		holder = getHolder();
		holder.addCallback(this);
		holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);		
	}
	
	public void surfaceCreated(SurfaceHolder holder) 
	{
		try 
		{
			if (camera != null) 
			{
				try 
				{
					camera.stopPreview();
				} 
				catch (Exception ignore) 
				{
				}
				try 
				{
					camera.release();
				} 
				catch (Exception ignore) 
				{
				}
				camera = null;
			}
					
			camera = Camera.open(0);	
			camera.setPreviewDisplay(holder);					
		} 
		catch (Exception ex) 
		{
			try {
				if (camera != null) 
				{
					try
					{
						camera.stopPreview();
					} 
					catch (Exception ignore) 
					{
					}
					try 
					{
						camera.release();
					} 
					catch (Exception ignore) 
					{
					}
					camera = null;
				}
			} 
			catch (Exception ignore) 
			{

			}
		}
	}
	public void surfaceDestroyed(SurfaceHolder holder) 
	{
		try 
		{
			if (camera != null) 
			{
				try 
				{				
					camera.setPreviewCallback(null);
					camera.stopPreview();
				} 
				catch (Exception ignore) 
				{}
				try 
				{
					camera.release();
				} 
				catch (Exception ignore) 
				{}
				camera = null;
			}
				
		} 
		catch (Exception ex) 
		{
			ex.printStackTrace();
		}
	}
	
	
	public void onPreviewFrame(byte[] data, Camera camera) {
						
		/**Process incoming camera frame with the matcher lib */
		recognizer.processFrame(data, camWidth, camHeight);				 		
	}
	
	public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) 
	{
		try 
		{						
			if(isPreviewRunning)
			{
				camera.stopPreview();				
			}				
						
			/** Get and modify the camera parameters*/
			Camera.Parameters p = camera.getParameters();
								
			p.setPreviewSize(camWidth,camHeight);
							
			camera.setParameters(p);
			/** changes the camera view*/
			camera.setDisplayOrientation(90);
												
	        camera.setPreviewDisplay(holder);
	        camera.startPreview();
	        camera.setPreviewCallback(this);
	        	        
	        isPreviewRunning = true;  
		} 
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
	}
		
	
}

