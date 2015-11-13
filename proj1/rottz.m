function [R] = rottz(theta,dx,dy)
	R = [cos(theta) -sin(theta) dx; ...
		 sin(theta) cos(theta) dy; ...
		 0 0 1];		 
end