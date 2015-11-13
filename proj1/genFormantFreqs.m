function [formantFreqs] = genFormantFreqs(fnum,numVar)
    figure(3)
	%img = imread('vowel_formants.tiff');
    %axis([100 1500 500 3500])
    %hold on
    %image(linspace(100, 1500,size(img,2)),linspace(3500, 500,size(img,1)),img(:,:,1:3))
	formantCenters = [310 2790 3310 -pi/12; ... % ee
		 			  430 2480 3070 -pi/12; ... % i
		 			  610 2330 2990 -pi/9; ... % e
		 			  860 2050 2850 -pi/6; ... % ae
		 			  850 1220 2810 -pi/6; ... % ah
		 			  590 920 2710 -pi/10; ... % aw
		 			  470 1160 2680 -pi/40; ... % U
		 			  370 950 2670 -pi/40; ... % oo
		 			  760 1400 2780 -pi/5.6; ... % uh
		 			  500 1640 1960 0]; % er
                  
    formantSizes = [120 400;
                    120 400;
                    120 400;
                    160 400;
                    120 400;
                    100 400;
                    100 300;
                    140 400;
                    100 400;
                    160 270];
    x0 = formantCenters(fnum,1); 
    y0 = formantCenters(fnum,2);
    a = formantSizes(fnum,1);
    b = formantSizes(fnum,2);
    theta = formantCenters(fnum,4);
    t = 0:.002/pi:2*pi;
    x = a*cos(t);
    y = b*sin(t);
    z = ones(size(x));
    R = rottz(theta, x0, y0);
	
    ellipse = R*[x;y;z];
    x = ellipse(1,:);
    y = ellipse(2,:);
    plot(x,y)
	
	pts = rand(2,numVar);
	
    pts(2,:) = 2*pi.*pts(2,:);
    f1 = a*pts(1,:).*cos(pts(2,:));
    f2 = b*pts(1,:).*sin(pts(2,:));
    
    fd = ones(size(f1)); % dummy variable
    f3 = formantCenters(fnum,3).*fd; % formant 3 we hold constant because why not
    
    fshift = R*[f1;f2;fd];
    f1 = fshift(1,:);
    f2 = fshift(2,:);
    
    hold on
    plot(f1,f2,'*')
    
    formantFreqs = [f1;f2;f3];
	
end

