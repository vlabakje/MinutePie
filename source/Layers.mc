import Toybox.Lang;

const MARKERLENGTH=6;
const MARKERWIDTH=4;

class MinutePieSubdialsLayer{
    //hidden var maxX, maxY, centerX, centerY, currentMinute;
    hidden var hourDial, secondsDial, stepsDial, dayDial;
    var buffer;

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

    function subdials() as Array<Dial>{
        return [hourDial, secondsDial, dayDial, stepsDial];
    }

    // for sleeping mode we need to set a clip for the rectangle around the seconds dial
    function setClip(dc){
        dc.setClip(secondsDial.x-secondsDial.radius,
                   secondsDial.y-secondsDial.radius,
                   secondsDial.x+secondsDial.radius,
                   secondsDial.y+secondsDial.radius);
    }
}

class MarkersLayer {
    var buffer;

    function initialize(subdials as Array<Dial>){
        buffer = Graphics.createBufferedBitmap(
            {:width=>maxX,
             :height=>maxY,
             :palette=>[Graphics.COLOR_TRANSPARENT, Graphics.COLOR_RED],
             :colorDepth=>2});
        var dc = buffer.get().getDc();
        for(var i=0; i<subdials.size(); i++){
            subdials[i].markers(dc);
        }
        mainMarkers(dc);
    }

    function mainMarkers(dc){
        dc.setPenWidth(MARKERWIDTH);
        dc.fillPolygon([
            [centerX, MARKERLENGTH*2], // bottom point
            [centerX-MARKERLENGTH, 0], // top left
            [centerX+MARKERLENGTH, 0] // top right
        ]);
        dc.drawLine(maxX, centerY, maxX-MARKERLENGTH, centerY); // 3
        dc.drawLine(centerX, maxY, centerX, maxY-MARKERLENGTH); // 6
        dc.drawLine(0, centerY, MARKERLENGTH, centerY); // 9
        dc.setPenWidth(1);        
    }
}