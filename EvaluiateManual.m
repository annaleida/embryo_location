
%  filepath = 'C:\\MMU\\HMC data\\REPORT 131120 Circle searching evaluation\\12_6_PN\\Foc20\\'; %80-89
  filepath = 'C:\\MMU\\HMC data\\REPORT 121314 Embryo location detection\\Large test set\\3-4cell\\'; %80-89
  %filepath = 'C:\\MMU\\HMC data\\REPORT 121314 Embryo location detection\\Short test series\\'; %10-48
   %filepath = 'C:\\MMU\\HMC data\\Initial z-stacks 121029\\Scan focus
 start_image_imdex =1;
 nbr_of_images = 20;
   man_cen_x = [];
   man_cen_y = [];
%%Setup manual outlines
for i = start_image_imdex:1:nbr_of_images+start_image_imdex-1

    %745_1\\Well06_Run092_'; %0-6
 filename = strcat(strcat(filepath, num2str(start_image_imdex)),'.jpg');
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

mean(man_cen_x)
mean(man_cen_y)
var(man_cen_x)
var(man_cen_x)
