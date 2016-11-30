using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class DiscGolfApp extends App.AppBase {
	
    function initialize() {
    	var app = App.getApp();
        AppBase.initialize();
        if(app.getProperty("longest_throw") == null) {
			app.setProperty("longest_throw", 0);
        }
        
        if(app.getProperty("longest_drive") == null) {
			app.setProperty("longest_drive", 0);
        }
        
        if(app.getProperty("longest_mid") == null) {
			app.setProperty("longest_mid", 0);
        }
        
        if(app.getProperty("longest_putt") == null) {
			app.setProperty("longest_putt", 0);
        }
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new DiscGolfView(), new DiscGolfDelegate() ];
    }

}
