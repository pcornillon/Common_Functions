function h = circle(x,y,r,COLOR)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
eval(['h = plot(xunit, yunit,' COLOR ');'])
hold off

end

