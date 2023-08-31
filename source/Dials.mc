const SUBDIALMARKERLENGTH = 5;
const SUBDIALMARKERWIDTH = 3;

class Dial {
    var x, y, radius, dc, current;

    function initialize(mx, my, mradius, mdc){
        x = mx;
        y = my;
        radius = mradius;
        dc = mdc;
        current = 0;
    }

    function clear(){
        dc.setColor(BACKGROUND_COLOR, BACKGROUND_COLOR);
        dc.fillCircle(x, y, radius);
        dc.setColor(FOREGROUND_COLOR, Graphics.COLOR_TRANSPARENT);
    }

    function markers(dc){
        dc.drawCircle(x, y, radius);
    }

    function ticks(dc){
        dc.setPenWidth(SUBDIALMARKERWIDTH);
        dc.drawLine(x, y-radius, x, y-radius+SUBDIALMARKERLENGTH); // 12
        dc.drawLine(x+radius, y, x+radius-SUBDIALMARKERLENGTH, y); // 3
        dc.drawLine(x, y+radius, x, y+radius-SUBDIALMARKERLENGTH); // 6
        dc.drawLine(x-radius, y, x-radius+SUBDIALMARKERLENGTH, y); // 9
        dc.setPenWidth(1); // back to original?
    }
}

class HourDial extends Dial {
    function initialize(x, y, radius, dc){
        Dial.initialize(x, y, radius, dc);
    }
    
    function update(hour){
        if(hour != current){
            clear();
            var hourString = Lang.format("$1$", [hour]);
            dc.drawText(x, y, Graphics.FONT_SYSTEM_NUMBER_HOT, hourString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            current = hour;
        }
    }
}

class DayDial extends Dial {
    function initialize(x, y, radius, dc){
        Dial.initialize(x, y, radius, dc);
    }
    
    function update(day){
        if(day != current){
            clear();
            var dayString = Lang.format("$1$", [day]);
            dc.drawText(x, y, Graphics.FONT_MEDIUM, dayString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            current = day;
        }
    }
}

class StepsDial extends Dial {
    function initialize(x, y, radius, dc){
        Dial.initialize(x, y, radius, dc);
    }

    function update(stepCount, stepGoal){
        var sixty = stepCount * 60 / stepGoal;
        //sixty = sixty.toNumber();
        System.println("current sixty " + sixty);
        if(sixty != current){
            clear();
            if(sixty > 59){
                dc.drawCircle(x, y, radius/2.0);
            } else {
                dc.drawArc(x, y, radius/2.0, Graphics.ARC_CLOCKWISE, 90, sixtyAngles[sixty]);
            }
            current = sixty;
        }
    }
    
    function markers(dc){
        Dial.markers(dc);
        Dial.ticks(dc);
    }
}

class SecondsDial extends Dial {
    function initialize(x, y, radius, dc){
        Dial.initialize(x, y, radius, dc);
        dc.setPenWidth(radius);
    }

    function update(seconds){
        if(seconds != current){
            clear();
            if(seconds > 0){
                dc.drawArc(x, y, radius/2.0, Graphics.ARC_CLOCKWISE, 90, sixtyAngles[seconds]);
            }
        }
    }

    function partialUpdate(seconds){
        if(seconds){
            dc.drawArc(x, y, radius/2.0, Graphics.ARC_CLOCKWISE, sixtyAngles[seconds-1], sixtyAngles[seconds]);
            current = seconds;
        }
    }

    function markers(dc){
        Dial.markers(dc);
        Dial.ticks(dc);
    }
}