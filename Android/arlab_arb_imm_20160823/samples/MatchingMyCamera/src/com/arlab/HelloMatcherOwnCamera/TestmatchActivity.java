package com.arlab.HelloMatcherOwnCamera;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.arlab.callbacks.ARmatcherImageCallBack;
import com.arlab.callbacks.ARmatcherQRCallBack;
import com.arlab.imagerecognition.AESCrypt;
import com.arlab.imagerecognition.ARmatcher;
import com.arlab.imagerecognition.ROI;

public class TestmatchActivity extends Activity implements ARmatcherImageCallBack, ARmatcherQRCallBack{
	
	protected int camerawidth;
	protected int cameraheight;
	protected int layoutWidth;
	protected int layoutHeight;
	protected int screenheight ;
	protected int screenwidth ;
	
	/**The matcher instance */
	private ARmatcher aRmatcher;
	/**Array that holds added images IDs in the matching pool */
	private ArrayList<Integer> imageIdHolder = new ArrayList<Integer>();
	
	/**Debug Tag */
	private static final String TAG = "ARLAB_Hello";
		
	/**Camera and views variables*/
	private CameraView cameraView;
	private FrameLayout frameLayout;
	private TextView textView = null;
	
    @Override 
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        /**Get full screen size */
        DisplayMetrics displaymetrics = new DisplayMetrics();
    	getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
    	screenheight = getWindowManager().getDefaultDisplay().getHeight();
    	screenwidth = getWindowManager().getDefaultDisplay().getWidth();
    	
    	//*** MATCHER LIB **//   
    	/**Create an instance of the ARmatcher object. */
    	aRmatcher = new ARmatcher(this,"0YMpMABoIp/KDYNKbXH3o/J97U4mKwPEendG6vmnc4A=");
    	   	                  
        /**Set image and QR matching callbacks */
        aRmatcher.setImageRecognitionCallback(this); 
        aRmatcher.setQRRecognitionCallback(this);
       
        /**Set the matching type. */
        aRmatcher.setMatchingType(ARmatcher.BOTH_IMAGE_AND_QR_MATCHER);
        
        /**Enable median filter ,witch help to reduce noise and mismatches in IMAGE matching .(Optional) */
        aRmatcher.enableMedianFilter(false);
        
        /**Set minimum image quality threshold, for image to be accepted in the image pool */
        aRmatcher.setImageQuality(5);
                    
        /**Adding the images*/
        addImage(2);
        addImage(4);
        addImage(5);
        addImage(6);  // This image has few quality therefore it will not pass
        
        
        
        //*** CAMERA **//       
        /**Calculate right camera and layout parameters */
        calculateTrueCameraParameteres();
        /**Create camera instance */
      	cameraView = new CameraView(this,camerawidth , cameraheight, aRmatcher);
      		    
      	/**Create camera holder layout */
        frameLayout = new FrameLayout(this);       
        FrameLayout.LayoutParams frame = new FrameLayout.LayoutParams(layoutWidth , layoutHeight,Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL);
        
        /**Add camera to the camera holder  layout */
        frameLayout.addView(cameraView,frame);
          
        /**Add camera holder to content view */
        setContentView(frameLayout);    
    	
        /**Add TextView to the view in order to show matching results. */
        addResultTextView();   
    }
    
	
    /**Add TextView to the screen to show the matching results. */
    private void addResultTextView()
    {
    	textView = new TextView(this);
    	textView.setTextColor(Color.WHITE);
    	textView.setTextSize(23);
		FrameLayout.LayoutParams frame = new FrameLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 
				LayoutParams.WRAP_CONTENT,Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM);
	
		frameLayout.addView(textView,frame);
    }

    
    /**Callback that will accept all IMAGE matching results */
	public void onImageRecognitionResult(int res) {
		
		
		if (res != -1) {
			Log.d("TESTMATCH", "id:"+res);
				if(imageIdHolder.get(0) == res)
					textView.setText("3 Dogs");
				else if(imageIdHolder.get(1) == res)
					textView.setText("Donkey");
				else if(imageIdHolder.get(2) == res)
					textView.setText("Cat");
				else if(imageIdHolder.get(3) == res)
					textView.setText("Horse");		
				else 
					textView.setText(""+res);
							
		} 
		else
		{				
			textView.setText("Nothing found");
		}	
		
	}

	private void addImage(int i){
		/** Add image from local resources to the image matching pool specifying the unique id */
        int id = this.getResources().getIdentifier("pic"+i, "drawable", this.getPackageName());

		
		
        Bitmap bmp = BitmapFactory.decodeResource(getResources(),id);
        int aux=aRmatcher.addImage(bmp);
        if(aux>=0){
        	imageIdHolder.add(aux);
        	
        	Log.i(TAG,"image "+i+" added to the pool with id: " + aux);
        }else{
        	Log.i(TAG,"image "+i+" not added to the pool"); 
        }
        
	}
	 /**Callback that will accept all QR codes matching results */
	public void QRRecognitionResult(String res) {
		if(res != "")
			textView.setText(res);
	}
    
    /**Callback that will accept all QR codes matching results */
    public void onSingleQRrecognitionResult(ArrayList<ROI> roiList) {
    	String output = "";
    	int i = 0;
    	for(i=0; i<roiList.size(); i++){
    		if(roiList.get(i).foundResult != null)
    			output += roiList.get(i).foundResult + "\n";
    	}
    	textView.setText(output);
    	if(output == "")
    		textView.setText("Nothing found");
	}
	

	protected void onStop() {			
		super.onStop();
		try {
			 /**Empty image matching pool*/
			aRmatcher.releaseResources();
		} catch (Exception e) {	 }
		System.gc();
	}


	@Override
	public void onMultipleQRrecognitionResult(ArrayList<ROI> arg0) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void onSingleQRrecognitionResult(String arg0) {
		// TODO Auto-generated method stub
		
	}
	
	
	
	/**Calculate right camera and layout parameters to avoid camera view distortions */
	 private void calculateTrueCameraParameteres()
	    {
	    	Camera cam = Camera.open(0);

			camerawidth = cam.getParameters().getPreviewSize().width;
			cameraheight = cam.getParameters().getPreviewSize().height;

				boolean upsideDown = false;
				if ((camerawidth > cameraheight) && (screenwidth < screenheight)) {
					int temp = screenwidth;
					screenwidth = screenheight;
					screenheight = temp;
					upsideDown = true;
				}

				List<Size> camSize = cam.getParameters().getSupportedPreviewSizes();			
				cam.release();
				
				float diff = Float.MAX_VALUE;
				float aspec = screenwidth / (float) screenheight;
				for (int i = 0; i < camSize.size(); i++) {
					float tempaspec = camSize.get(i).width
							/ (float) camSize.get(i).height;
					if (Math.abs(aspec - tempaspec) < diff) {
						diff = Math.abs(aspec - tempaspec);

						camerawidth = camSize.get(i).width;
						cameraheight = camSize.get(i).height;

					}
				}
			
				float finalw = 0;
				float finalh = 0;

				finalw = screenwidth;
				finalh = cameraheight * (screenwidth / (float) camerawidth);

				if (finalh > screenheight) {
					finalw = camerawidth * (screenheight / (float) cameraheight);
					finalh = (float) screenheight;

				}

				layoutWidth = 0;
				layoutHeight = 0;
				if (upsideDown) {
					layoutWidth = (int) finalh;
					layoutHeight = (int) finalw;
				} else {
					layoutWidth = (int) finalw;
					layoutHeight = (int) finalh;

				}
	    }
}