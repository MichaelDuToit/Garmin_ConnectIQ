using Toybox.WatchUi as Ui;

class RecoveryTimerView extends Ui.SimpleDataField {

	var recoveryTimerValue = 0;
	// Initialize our timer as active even though it isn't to stop it from
	// running before we start the activity.
	var timerActive = true;
	var fieldValue;
	
	function initialize(){
		SimpleDataField.initialize();
		label = "Recovery Timer";
	}
	
	function recoveryTimer(active){
		timerActive = active;
		recoveryTimerValue = 0;
		Ui.requestUpdate();
	}
	
	function onTimerStart(){
		recoveryTimer(true);
	}
	function onTimerStop(){
		recoveryTimer(false);
	}
	function onTimerResume(){
		recoveryTimer(true);
	}
	function onTimerPause(){
		recoveryTimer(false);
	}
	function onTimerReset(){
		recoveryTimer(true);
		fieldValue = null;
	}
	
	function compute(info){
		if(timerActive){
			fieldValue = "--:--";
		}
		else {
			recoveryTimerValue += 1;
			fieldValue = Lang.format("$1$:$2$", [
				(recoveryTimerValue / 60).format("%02d"), 
				(recoveryTimerValue % 60).format("%02d")
			]);
			Ui.requestUpdate();
		}
		return fieldValue;
	}
}