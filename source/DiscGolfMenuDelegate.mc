using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Position as Position;
using Toybox.Application as App;

class DiscGolfMenuDelegate extends Ui.MenuInputDelegate {
	
	var _view;

    function initialize() {
        MenuInputDelegate.initialize();
        _view = new DiscGolfView();
    }

    function onMenuItem(item) {
        if (item == :measure_throw) {
            Sys.println("item 1");
            Ui.pushView(new MeasureView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
        } else if (item == :stats) {
            Sys.println("item 2");
        }
    }

}

class SaveThrowMenuDelegate extends Ui.MenuInputDelegate {
	var _view, app;
	
	function initialize() {
		MenuInputDelegate.initialize();
		_view = new SaveThrowView();
		var app = App.getApp();
	}
	
	function onMenuItem(item) {
		//handle hi scores
		var throw_dist, longest_drive, longest_mid, longest_putt;
		throw_dist = app.getProperty("distance").toFloat();
		longest_drive = app.getProperty("longest_drive");
		longest_mid = app.getProperty("longest_mid");
		longest_putt = app.getProperty("longest_putt");

		if(item == :drive) {
			if(throw_dist > longest_drive) {
				app.setProperty("longest_drive", app.getProperty("distance"));
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			} else {
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			}
		} else if(item == :mid_range_throw) {
			if(throw_dist > longest_mid) {
				app.setProperty("longest_mid", app.getProperty("distance"));
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			} else {
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			}
		} else if(item == :putt) {
			if(throw_dist > longest_putt) {
				app.setProperty("longest_putt", app.getProperty("distance"));
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			} else {
				Ui.pushView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
			}
		} else {
			Sys.println("pls help");
		}
	}

}

