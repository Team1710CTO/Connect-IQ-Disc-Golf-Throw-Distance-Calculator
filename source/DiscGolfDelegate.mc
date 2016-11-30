using Toybox.WatchUi as Ui;
using Toybox.System as Sys;


class DiscGolfDelegate extends Ui.BehaviorDelegate {
	
	var _view;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new DiscGolfMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onTap() {
    	//stop measuring
    	Ui.switchToView(new SaveThrowView(), new SaveThrowDelegate(), Ui.SLIDE_UP);
    }

}

class SaveThrowDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
	
	function onMenu() {
		Ui.pushView(new Rez.Menus.ThrowTypes(), new SaveThrowMenuDelegate(), Ui.SLIDE_UP);
		return true;
	}
	
	function onTap() {
		//goes back to first screen
    	Ui.switchToView(new DiscGolfView(), new DiscGolfDelegate(), Ui.SLIDE_UP);
    }
}
