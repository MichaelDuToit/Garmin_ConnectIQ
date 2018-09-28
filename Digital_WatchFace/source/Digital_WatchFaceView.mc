using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;

class Digital_WatchFaceView extends Ui.WatchFace {
	var highPower;

	function initialize(){
	 	WatchFace.initialize();
	}
	
	// Load resources
	function onLayout(dc){
		setLayout(Rez.Layouts.WatchFace(dc));
	}
	
	// Update the View
	function onUpdate(dc){
		// Battery
		var battery = Sys.getSystemStats().battery;
		var batteryNUM = battery.toNumber();
		var batterySTR = Lang.format("$1$%", [battery.format("%d")]);
		var batteryView = View.findDrawableById("BatteryStatus");
		batteryView.setText(batterySTR);
		
		var batteryLow = 20;
		var batteryMedium = 50;
		
		if(batteryNUM > batteryMedium){
			batteryView.setColor(Gfx.COLOR_DK_GREEN);
		}
		else if (batteryNUM <= batteryMedium && batteryNUM > batteryLow){
			batteryView.setColor(Gfx.COLOR_ORANGE);
		}
		else {
			batteryView.setColor(Gfx.COLOR_DK_RED);
		}
		
		// Clock
		var deviceSettings = Sys.getDeviceSettings();
		var userSetting24hour = deviceSettings.is24Hour;
		var clockTime = Sys.getClockTime();
		var clockHours = clockTime.hour;
		var clockMins = clockTime.min;
		var clockSecs = clockTime.sec;
		var mainClockView = View.findDrawableById("ClockMain");
		var secondsClockView = View.findDrawableById("ClockSeconds");
		
		// 12 hour vs 24 hour
		var am_pmView = View.findDrawableById("Hour12");
		var militaryTime = clockHours;
		if(!userSetting24hour){
			if(militaryTime > 12){
				clockHours = clockHours - 12;
				clockHours = clockHours.format("%02d");
			}
			if (militaryTime < 12){
				am_pmView.setText("AM");
			}
			else {
				am_pmView.setText("PM");
			}
			if (clockHours == 0){
				clockHours = 12;
			}
		}
		else {
			clockHours = clockHours.format("%02d");
		}
		var mainClockSTR = Lang.format("$1$$2$", [clockHours, clockMins.format("%02d")]);
		mainClockView.setText(mainClockSTR);
		
		if (highPower){
			var secondsClockSTR = Lang.format("$1$", [clockSecs.format("%02d")]);
			secondsClockView.setText(secondsClockSTR);
			secondsClockView.setColor(Gfx.COLOR_WHITE);
		}
		else {
			secondsClockView.setColor(Gfx.COLOR_TRANSPARENT);
		}
		
		// Date Content
		var dateInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
		var dateView = View.findDrawableById("Date");
		dateView.setText(dateInfo.day_of_week + " " + dateInfo.day.format("%02d") + " " + dateInfo.month);
		
		View.onUpdate(dc);		
	}
	
	function onExitSleep(){
		highPower = true;
	}
	
	function onEnterSleep(){
		highPower = false;
		Ui.requestUpdate();
	}
}