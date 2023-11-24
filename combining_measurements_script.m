clc
close all
clear 

%folder = '400nm_500ns';
clc
close all
clear 

%folder = '400nm_500ns';
folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_2mJ_1us';
%folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_2mJ_1us'
snr_threshold_high = 15;
data = combining_measurements_single(folder,snr_threshold_high);


%bar graphs
figure(111)
a = data.snr_values;
b = data.peak_area;
c = data.peak_height;
d = data.noise_rms;
histogram(a(a < snr_threshold_high),25)

hold on
snr_median(1) = median(data.snr_values);
peak_area_median(1) = median(data.peak_area);
peak_height_median(1) = median(data.peak_height);
peak_width_median(1) = median(data.peak_width);
noise_rms_median(1) = median(data.noise_rms);





%folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_2mJ_1us'
snr_threshold_high = 15;
data = combining_measurements_single(folder,snr_threshold_high);


%bar graphs
figure(111)
a = data.snr_values;
b = data.peak_area;
c = data.peak_height;
d = data.noise_rms;
histogram(a(a < snr_threshold_high),25)

hold on
snr_median(1) = median(data.snr_values);
peak_area_median(1) = median(data.peak_area);
peak_height_median(1) = median(data.peak_height);
peak_width_median(1) = median(data.peak_width);
noise_rms_median(1) = median(data.noise_rms);




%folder = '500nm_500ns';
folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/500nm_125ns';
%folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_2mJ_2us'
snr_threshold_high = 20;
data2 = combining_measurements_single(folder,snr_threshold_high);
%bar graphs
figure(111)
a = data2.snr_values;
b = data2.peak_area;
c = data2.peak_height;
d = data2.noise_rms;
histogram(a(a < snr_threshold_high),25)

hold on
snr_median(2) = median(data2.snr_values);
peak_area_median(2) = median(data2.peak_area);
peak_height_median(2) = median(data2.peak_height);
peak_width_median(2) = median(data2.peak_width);
noise_rms_median(2) = median(data2.noise_rms);





%folder = '600nm_500ns';
folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/600nm_500ns';
%folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_1.3_1us'
snr_threshold_high = 35;
data3 = combining_measurements_single(folder,snr_threshold_high);
%bar graphs
figure(111)
a = data3.snr_values;
b = data3.peak_area;
c = data3.peak_height;
d = data3.noise_rms;
histogram(a(a < snr_threshold_high),25)

hold on
snr_median(3) = median(data3.snr_values);
peak_area_median(3) = median(data3.peak_area);
peak_height_median(3) = median(data3.peak_height);
peak_width_median(3) = median(data3.peak_width);
noise_rms_median(3) = median(data3.noise_rms);



% Set title and labels for the plot
title('SNR Distribution with 500ns gate delay for different particle diameter', 'FontSize', 14)
xlabel('SNR', 'FontSize', 12)
ylabel('Frequency', 'FontSize', 12)


% Legend
legend('400nm', '500nm', '600nm')



