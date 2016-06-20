function r= rotmat(theta,opt)
%% function r= rotmat(theta,opt)
%
% theta default in degrees (opt=='rad' for radians)
% r= [cos sin; -sin cos] for rotation in plane
%
if nargin<2
    convfactor= pi/180;
elseif strcmp(opt,'rad')
    convfactor= 1;
else
    convfactor= pi/180;
end

theta= theta*convfactor;
r= [cos(theta), sin(theta); -sin(theta), cos(theta)];

end
