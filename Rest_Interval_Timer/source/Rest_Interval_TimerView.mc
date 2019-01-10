using Toybox.WatchUi as Ui;

class Rest_Interval_TimerView extends Ui.SimpleDataField {

	var rest_timerValue = 0;
	// Initialize our timer as active even though it isn't to stop it from
	// running before we start the activity.
	var timerActive = true;
	var fieldValue;
	
	function initialize(){
		SimpleDataField.initialize();
		label = "Rest Timer";
	}
	
	function rest_timer(active){
		timerActive = active;
		rest_timerValue = 0;
		Ui.requestUpdate();
	}
	
	function onTimerStart(){
		rest_timer(true);
	}
	function onTimerStop(){
		rest_timer(false);
	}
	function onTimerResume(){
		rest_timer(true);
	}
	function onTimerPause(){
		rest_timer(false);
	}
	function onTimerReset(){
		rest_timer(true);
		fieldValue = null;
	}
	
	function compute(info){
		if(timerActive){
			fieldValue = "--:--";
		}
		else {
			rest_timerValue += 1;
			fieldValue = Lang.format("$1$:$2$", [(rest_timerValue / 60).format("%02d"), (rest_timerValue % 60).format("%02d")]);
			Ui.requestUpdate();
		}
		return fieldValue;
	}
}