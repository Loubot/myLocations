package com.louis.mylocations;

import org.apache.cordova.DroidGap;
import android.os.Bundle;

public class MyPhoneGapActivity extends DroidGap {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.setIntegerProperty("loadUrlTimeoutValue", 70000);
		super.onCreate(savedInstanceState);
		super.loadUrl("file:///android_asset/www/myLocations/myLocations.html");
	}
}
