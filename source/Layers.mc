const MARKERLENGTH=6;
const MARKERWIDTH=6;

class MinutePieSubdialsLayer{
    //hidden var maxX, maxY, centerX, centerY, currentMinute;
    hidden var hourDial, secondsDial, stepsDial, dayDial;
    var buffer;
    var markers;

    function initialize(){
        buffer = Graphics.createBufferedBitmap(
            {:width=>maxX,
             :height=>maxY});
             //:palette=>[Graphics.COLOR_TRANSPARENT, Graphics.COLOR_WHITE, Graphics.COLOR_BLACK],
             //:colorDepth=>4});
        var dc = buffer.get().getDc();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        hourDial = new HourDial(centerX, centerY, centerX/2.7, dc);
        secondsDial = new SecondsDial(centerX, maxY*0.85, centerX/5, dc);
        stepsDial = new StepsDial(maxX*0.15, centerY, centerX/5, dc);
        dayDial = new DayDial(maxX*0.85, centerY, centerX/5, dc);
        markerDial();
    }
    
    function update(hour, seconds, day, stepCount, stepGoal){
        hourDial.update(hour);
        secondsDial.update(seconds);
        dayDial.update(day);
        stepsDial.update(stepCount, stepGoal);
    }

    function partialUpdate(seconds){
        secondsDial.partialUpdate(seconds);
    }

    function markerDial(){
        markers = Graphics.createBufferedBitmap(
            {:width=>maxX,
             :height=>maxY,
             :palette=>[Graphics.COLOR_TRANSPARENT, Graphics.COLOR_RED],
             :colorDepth=>2});
        var dc = markers.get().getDc();
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        hourDial.markers(dc);
        secondsDial.markers(dc);
        dayDial.markers(dc);
        stepsDial.markers(dc);
        dc.setPenWidth(MARKERWIDTH);
        dc.drawLine(centerX, 0, centerX, MARKERLENGTH); // 12
        dc.drawLine(maxX, centerY, maxX-MARKERLENGTH, centerY); // 3
        dc.drawLine(centerX, maxY, centerX, maxY-MARKERLENGTH); // 6
        dc.drawLine(0, centerY, MARKERLENGTH, centerY); // 9
        dc.setPenWidth(1);
    }

    function setClip(dc){
        dc.setClip(secondsDial.x-secondsDial.radius,
                   secondsDial.y-secondsDial.radius,
                   secondsDial.x+secondsDial.radius,
                   secondsDial.y+secondsDial.radius);
    }
}
