%clear workspace in Matlab 
clear all
%close all images
close all
%clear screen
clc
%simulation data
f = openfig('20degree_Back20degreeClockwise.fig');
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
x_data_1 = x_data{9};
y_data_1 = y_data{9};
figure
plot(x_data_1, y_data_1,'r','LineWidth',2)
xlabel('range/m','linewidth',12,'fontsize',10,'Fontname','Timesnewroman','fontWeight','bold');
ylabel('amplitude','linewidth',12,'fontsize',10,'Fontname','Timesnewroman','fontWeight','bold')
title('Range Profile 1st position 0 degree')
% xlim([0 3])


