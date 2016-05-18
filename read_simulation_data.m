clear all
close all;
clc;
%simulation data

%strings 
%{
6 DIFFERENT ROTATIONS (FOR EACH OF THE 4 POSITIONS)
20degree_Back
20degree_Back20degreeClockwise
20degree_Back20degreeCounterClockwise
20degree_clockwise
20degree_counterclockwise
Norotation
%}
str =  '20degree_Back20degreeCounterClockwise'
f = openfig(strcat(str,'.fig'));
Ap  = 0.01;
H = findobj(f, 'type','line');
x_data = get(H, 'xdata');
y_data = get(H, 'ydata');
%y=0
% x_data_1 = x_data{12};
% y_data_1 = y_data{12};
%y=15cm
% x_data_1 = x_data{11};
% y_data_1 = y_data{11};
%y=-15cm
% x_data_1 = x_data{10};
% y_data_1 = y_data{10};
%y=-30cm
x_data_1 = x_data{2};
y_data_1 = y_data{2};
f2 = figure;
plot(x_data_1, y_data_1,'r','LineWidth',2)
xlabel('range/m','linewidth',12,'fontsize',10,'Fontname','Timesnewroman','fontWeight','bold');
ylabel('amplitude','linewidth',12,'fontsize',10,'Fontname','Timesnewroman','fontWeight','bold')
title(['Range Profile 1st position,',' ', str]);

saveas(f2, ['Range Profile 1st position,',' ', str,'.png']);
% xlim([0 3])


