clear all; close all;
profile_me = 0;
%im = imread('coins.png');
if profile_me == 1
profile clear; profile on;
end;

   pause on

%%Initiate
man_cen_x = [];
man_cen_y = [];
comp_cen_x = [];
comp_cen_y = [];

success_5 = [];
fail_5 = [];
success_2 = [];
fail_2 = [];
success_10 = [];
fail_10 = [];
success_1 = [];
fail_1 = [];
success_3 = [];
fail_3 = [];
success_10 = [];
fail_10 = [];
success_20 = [];
fail_20 = [];
success_40 = [];
fail_40 = [];

%% Set parameters
%max_centroid_difference = 5;
percentage_rotated_images = 0.75; % What is the min number of images the structure must be on`?
max_centroid_radius = 1; %What is the min distance for several structures to count as the same?
body_radii_min =100;
body_radii_max = 120;
body_radii = body_radii_min:10:body_radii_max; %min radi:step size:max radi
no_bodies = 1; %In this script - can only detect 1 body
%core_radii = 3:1:5; %min radi:step size:max radi
plot_me = 1;

nbr_of_angles = 1; %Only one angle posible
rot_angles = 0:floor(360/nbr_of_angles):360;

start_image_imdex = 1;
nbr_of_images = 20
n= 0;

%  filepath = 'C:\\MMU\\HMC data\\REPORT 131120 Circle searching evaluation\\12_6_PN\\Foc20\\'; %80-89
  filepath = 'C:\\MMU\\HMC data\\REPORT 121314 Embryo location detection\\Large test set\\Deformed\\'; %80-89
  %filepath = 'C:\\MMU\\HMC data\\REPORT 121314 Embryo location detection\\Short test series\\'; %10-48
   %filepath = 'C:\\MMU\\HMC data\\Initial z-stacks 121029\\Scan focus
 
   
%%Setup manual outlines
for i = start_image_imdex:1:nbr_of_images+start_image_imdex-1

    %745_1\\Well06_Run092_'; %0-6
 filename = strcat(strcat(filepath, num2str(i)),'.jpg');
% filename = strcat(strcat(filepath,num2str(i)),'.jpg');

%im = imread('C:\MMU\HMC data\embryo24.bmp'); %Testimage
im = imread(filename);
im = im(:,:,1);

if plot_me == 1
figure(70);
imshow(im); hold on;
axis on;

bounds = zeros(1,4);
pos = ginput(2);
bounds(1) =  pos(1,1); bounds(3) = pos(2,1)-pos(1,1);
bounds(2) = pos(1,2); bounds(4) = pos(2,2)-pos(1,2);


line([bounds(1),bounds(1)+bounds(3)],[bounds(2), bounds(2)], 'Color', 'r', 'LineWidth', 2);
line([bounds(1),bounds(1)+bounds(3)],[bounds(2)+bounds(4), bounds(2)+bounds(4)], 'Color', 'r', 'LineWidth', 2);
line([bounds(1),bounds(1)],[bounds(2)+bounds(4), bounds(2)], 'Color', 'r', 'LineWidth', 2);
 line([bounds(1)+bounds(3),bounds(1)+bounds(3)],[bounds(2)+bounds(4), bounds(2)], 'Color', 'r', 'LineWidth', 2);

%   title(strcat(strcat(strcat(strcat(num2str(i), ': '),strcat('Max = ', num2str(maximum_acc_box_value))),': Area: '), num2str(s.Area)));
%    hold off;

man_cen_x(i) = bounds(3)/2+bounds(1);
man_cen_y(i) = bounds(4)/2+bounds(2);
plot(man_cen_x, man_cen_y, 'r*');

end;

end;

pause;
%%Compute

start = tic;
 
for i = start_image_imdex:1:nbr_of_images+start_image_imdex-1

  %  filepath = 'C:\\MMU\\HMC data\\REPORT 131120 Circle searching evaluation\\12_6_PN\\Foc20\\'; %80-89
  %filepath = 'C:\\MMU\\HMC data\\REPORT 131120 Circle searching evaluation\\Short test series\\'; %80-89
  %filepath = 'C:\\MMU\\HMC data\\REPORT 131213 Embryo activity analysis\\Images\\12_8\\'; %10-48
   %filepath = 'C:\\MMU\\HMC data\\Initial z-stacks 121029\\Scan focus
   %745_1\\Well06_Run092_'; %0-6
 filename = strcat(strcat(filepath, num2str(i)),'.jpg');
% filename = strcat(strcat(filepath,num2str(i)),'.jpg');

%im = imread('C:\MMU\HMC data\embryo24.bmp'); %Testimage
im = imread(filename);
im = im(:,:,1);

e = edge(im, 'canny');


%% Carry out the HT

body_h = circle_hough(e, body_radii, 'same', 'normalise');

%core_h = circle_hough(e, core_radii, 'same', 'normalise');
%same: only circles whose center is inside image are detected.
%normalise: prevents larger circles from getting more votes

%% Find some peaks in the accumulator

body_peaks = circle_houghpeaks(body_h, body_radii, 'nhoodxy', 15, 'nhoodr', 21, 'npeaks', no_bodies);
%returns (x,y,radius)
for peak=body_peaks
    comp_cen_x(i) = peak(1);
    comp_cen_y(i) = peak(2);
    radius = peak(3);
    
        [x, y] = circlepoints(peak(3)); %Compute vector of points with radius peak(3)
   
   

if plot_me == 1
figure(70);
plot(x+peak(1), y+peak(2), 'c-', 'lineWidth', 2); 
plot(comp_cen_x, comp_cen_y, 'c*');

end;
end;
end;


 my_time = toc(start); %Time of this image excluding plotting
 time_per_calculation = my_time/nbr_of_images;
 

%%Compare

for j = start_image_imdex:1:nbr_of_images+start_image_imdex-1
    compare_x = abs(comp_cen_x(j) - man_cen_x(j));
    compare_y = abs(comp_cen_y(j) - man_cen_y(j));
    if (compare_x <=3 && compare_y <= 3)
        success_3(j) = 1;
    else
        fail_3(j) = 1;
    end;
    if (compare_x <=2 && compare_y <= 2)
        success_2(j) = 1;
    else
        fail_2(j) = 1;
    end;
    if (compare_x <=1 && compare_y <= 1)
        success_1(j) = 1;
    else
        fail_1(j) = 1;
    end;
    if (compare_x <=10 && compare_y <= 10)
        success_10(j) = 1;
    else
        fail_10(j) = 1;
    end;
    if (compare_x <=5 && compare_y <= 5)
        success_5(j) = 1;
    else
        fail_5(j) = 1;
    end;
     if (compare_x <=20 && compare_y <= 20)
        success_20(j) = 1;
    else
        fail_20(j) = 1;
    end;
     if (compare_x <=40 && compare_y <= 40)
        success_40(j) = 1;
    else
        fail_40(j) = 1;
    end;
end;


nbr_positives_1 = sum(success_1);
nbr_false_1 = sum(fail_1);
hit_rate_percent_1 = nbr_positives_1/nbr_of_images*100
nbr_positives_2 = sum(success_2);
nbr_false_2 = sum(fail_2);
hit_rate_percent_2 = nbr_positives_2/nbr_of_images*100
nbr_positives_3 = sum(success_3);
nbr_false_3 = sum(fail_3);
hit_rate_percent_3 = nbr_positives_3/nbr_of_images*100
nbr_positives_5 = sum(success_5);
nbr_false_5 = sum(fail_5);
hit_rate_percent_5 = nbr_positives_5/nbr_of_images*100
nbr_positives_10 = sum(success_10);
nbr_false_10 = sum(fail_10);
hit_rate_percent_10 = nbr_positives_10/nbr_of_images*100
nbr_positives_20 = sum(success_20);
nbr_false_20 = sum(fail_20);
hit_rate_percent_20 = nbr_positives_20/nbr_of_images*100
nbr_positives_40 = sum(success_40);
nbr_false_40 = sum(fail_40);
hit_rate_percent_40 = nbr_positives_40/nbr_of_images*100






if profile_me == 1
profile off;
profile viewer
end;