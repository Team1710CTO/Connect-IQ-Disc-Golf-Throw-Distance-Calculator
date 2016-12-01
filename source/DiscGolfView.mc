using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;


class DiscGolfView extends Ui.View {

	var longest_drive_label, longest_mid_label, longest_putt_label;
	var longest_drive, longest_mid, longest_putt;
	var app;
	
    function initialize() {
    	app = App.getApp();
        View.initialize();
        longest_drive = app.getProperty("longest_drive");
        longest_mid = app.getProperty("longest_mid");
        longest_putt = app.getProperty("longest_putt");
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        longest_drive_label = View.findDrawableById("longest_drive");
        longest_drive_label.setText("Longest Drive: " + longest_drive.toString());
        
        longest_drive_label = View.findDrawableById("longest_mid_throw");
        longest_drive_label.setText("Longest Mid-Mange: " + longest_mid.toString());
        
        longest_drive_label = View.findDrawableById("longest_putt");
        longest_drive_label.setText("Longest Putt: " + longest_putt.toString());
    }
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }
	
	function onPosition(geoPositionInfo) {
    	var lat = geoPositionInfo.position.toDegrees()[0];
    	var lon = geoPositionInfo.position.toDegrees()[1];
    	Ui.requestUpdate();
	}

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}

class MeasureView extends Ui.View {
	
	var distance_ft = 0;
	var lat_init, lon_init;
	var longest_throw;
	var init_found = false;
	var tapped = false;
	var lat, lon;
	var count;
	var posnInfo;
	
	function initialize() {
		var app = App.getApp();
        View.initialize();
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        longest_throw = app.getProperty("longest_drive").toNumber();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MeasureLayout(dc));
    }
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	View.findDrawableById("cur_dist").setText(distance_ft + " ft");
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    	lat_init = Position.getInfo().position.toDegrees()[0];
    	lon_init = Position.getInfo().position.toDegrees()[1];
    }
	
	function onPosition(geoPositionInfo) {
    	lat = geoPositionInfo.position.toDegrees()[0];
    	lon = geoPositionInfo.position.toDegrees()[1];
    	posnInfo = geoPositionInfo;
    	Ui.requestUpdate();
	}

    // Update the view
    function onUpdate(dc) {
    	
    	var app = App.getApp();
    
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
		//logic only works on device, not sim
		
		if(tapped == false) {
			if(Position.getInfo().accuracy < 3) {        
        		View.findDrawableById("gps_accuracy_label").setText("Waiting on GPS...");
        		Sys.println(lat_init + " " + lon_init);
        		app.setProperty("distance", 0);		
			} else if(Position.getInfo().accuracy >= 3) {
        		View.findDrawableById("gps_accuracy_label").setText("Tap to stop measuring");
        		if(init_found == false) {
        			lon_init = getInitLon();
        			lat_init = getInitLat();
        			//View.findDrawableById("lat_initial").setText(lat_init.toString()); //for debugging
        			//View.findDrawableById("lon_initial").setText(lon_init.toString()); //for debugging
        			init_found = true;
        		}
        		distance_ft = distance(lat_init, lon_init, Position.getInfo().position.toDegrees()[0], Position.getInfo().position.toDegrees()[1]).toNumber();
        		if(init_found) {
        			View.findDrawableById("cur_dist").setText(distance_ft + " ft");
        			app.setProperty("distance", distance_ft);
        			if(distance_ft > 0 && longest_throw > 0) {
        				/*if((distance_ft/longest_throw) < 0.25) {
        					View.findDrawableById("cur_dist").setColor(Gfx.COLOR_RED);
        				} else if((distance_ft/longest_throw) > 0.25 && (distance_ft/longest_throw) < 0.5) {
        		    		View.findDrawableById("cur_dist").setColor(Gfx.COLOR_ORANGE);
        				} else if((distance_ft/longest_throw) > 0.5 && (distance_ft/lonngest_throw) < 1) {
        		    		View.findDrawableById("cur_dist").setColor(Gfx.COLOR_YELLOW);
        				} else if((distance_ft/longest_throw) > 1) {
        	        		View.findDrawableById("cur_dist").setColor(Gfx.COLOR_GREEN);
        				} else {
        		    		View.findDrawableById("cur_dist").setColor(Gfx.COLOR_GREEN);
        				}*/
        			} else {
        				View.findDrawableById("cur_dist").setColor(Gfx.COLOR_GREEN);
        			}
        		} else {
        			View.findDrawableById("cur_dist").setText(distance_ft + " ft");
        		}
        	}
        }
    }
    
    function getInitLat() {
    	return Position.getInfo().position.toDegrees()[0];
    }
    
    function getInitLon() {
    	return Position.getInfo().position.toDegrees()[1];
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function distance(lat1, lon1, lat2, lon2) {
		var x = deg2rad((lon2 - lon1)) * Math.cos(deg2rad( (lat1 + lat2) / 2));
		var y = deg2rad(lat2 - lat1);
		var distance = Math.sqrt(x * x + y * y) * 20900000; //mult'd by earth's radius in feet
		return distance.format("%d");
   	 }
   	 
   	 function betterDistance(lat1, lon1, lat2, lon2) {
   	 
   	 }
   	 
	function deg2rad(deg) {
  		return deg * (Math.PI/180);
	}	 
	
}

class SaveThrowView extends Ui.View {
	
	function initialize() {
        View.initialize();
	}
	
	function onLayout(dc) {
		setLayout(Rez.Layouts.SaveThrowLayout(dc));
	}
	
	function onShow() {
		var app = App.getApp();
		var throw_dist = app.getProperty("distance");
		View.findDrawableById("feet_thrown").setText("You threw: " + throw_dist.toString() + "ft!");
	}
	
	function onUpdate(dc) {
		View.onUpdate(dc);
	}
	
	function onHide() {
	
	}
}
