import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

var sixtyAngles as Array<Float> = new Array<Float>[60];
const FOREGROUND_COLOR    = Graphics.COLOR_WHITE;
const BACKGROUND_COLOR    = Graphics.COLOR_BLACK;
var maxX, maxY, centerX, centerY;

class MinutePieView extends WatchUi.WatchFace {
    hidden var sleeping;
    hidden var subdialsLayer, markersLayer;

    function initialize() {
        WatchFace.initialize();
        // pre-fill angles
        for(var a = 0; a < 60; a+=1){
            sixtyAngles[a] = 90 - (180 * getAngle(a, 60.0) / (Math.PI));
        }
        sleeping = false;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        var settings = System.getDeviceSettings();
        maxX = settings.screenWidth;
        maxY = settings.screenHeight;
        centerX = maxX/2;
        centerY = maxY/2;
        dc.setPenWidth(centerX);
        subdialsLayer = new MinutePieSubdialsLayer();
        markersLayer = new MarkersLayer(subdialsLayer.subdials());
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Clear the screen
    hidden function clear(dc, min) {
        //dc.setClip(minX, minY, maxX, maxY);
        dc.clearClip();
        if(!sleeping || min == 0){
            dc.setColor(FOREGROUND_COLOR, BACKGROUND_COLOR);
            dc.clear();
        }
    }

    // Update the view, gets called once every second if not in power saving mode
    function onUpdate(dc as Dc) as Void {
        var now = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var info = ActivityMonitor.getInfo();
        /*if(sleeping){
            System.println("sleepy update " + now.min + "." + now.sec);
        }*/
        // Get and show the current time
        clear(dc, now.min);
        updateMinute(dc, now.min);
        subdialsLayer.update(now.hour, now.sec, now.day, info.steps, info.stepGoal);
        dc.drawBitmap(0, 0, subdialsLayer.buffer.get());
        dc.drawBitmap(0, 0, markersLayer.buffer.get());
        //drawSmallPie(dc, info.steps, info.stepGoal - 0.1, maxX * 0.2);
        if(sleeping){
            subdialsLayer.setClip(dc);
        }
    }

    function onPartialUpdate(dc as Dc) as Void {
        // seconds
        var clockTime = System.getClockTime();
        System.println("low power update " + clockTime.sec);
        subdialsLayer.partialUpdate(clockTime.sec);
        dc.drawBitmap(0, 0, subdialsLayer.buffer.get());
        dc.drawBitmap(0, 0, subdialsLayer.markers.get());
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        sleeping = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        sleeping = true;
    }
    
    hidden function getAngle(value, maxValue) {
    	return ( value / maxValue ) * Math.PI * 2.0;
    }
    
    function updateMinute(dc, minute){
        if(minute > 0){
            if(sleeping){
                dc.drawArc(centerX, centerY, centerX/2.0, Graphics.ARC_CLOCKWISE, sixtyAngles[minute-1], sixtyAngles[minute]);
            } else {
                dc.drawArc(centerX, centerY, centerX/2.0, Graphics.ARC_CLOCKWISE, 90, sixtyAngles[minute]);
            }
        }
    }
}

class MinutePieDelegate extends WatchUi.WatchFaceDelegate {

    function initialize() {
        WatchFaceDelegate.initialize();
    }

    function onPowerBudgetExceeded(powerInfo) {
        System.println( "Average execution time: " + powerInfo.executionTimeAverage );
        System.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
    }
}