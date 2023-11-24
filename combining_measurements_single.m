function [output] =  combining_measurements_single(folder,snr_threshold_high)
%folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/Actual_3mJ_500ns';
% folder = '/Users/Xtyalls_city/Documents/MATLAB/Thor/400nm_500ns';

% Get a list of all the txt files in the folder
files = dir(fullfile(folder, '*.txt'));

% Define the range of the noise regions
noise_region1 = [580 588.4];
%noise_region2 = [600 625];
%noise_region1 = [560 586];
%noise_region2 = [600 620];

% Initialize array to store SNR values
snr_values = zeros(length(files), 1);

% set threshold for the double charge particles and low snr particles
snr_threshold_low = 1;

% Initialize variables for omitted snrs
snr_NaN = [];
omitted_snr_values = [];
num_omitted = 0;

noise_amplitude = zeros(1, length(files));

peak_area_total = 0;
background_heights = [];

% Loop over each file in the folder
for i = 1:length(files)
    
    filename = fullfile(folder, files(i).name);
    fprintf('Processing file %s...\n', filename);
    
    % Read the data from the file
    Actual = fopen(filename, 'r');
    data = textscan(Actual, '%f%f%f%f%f', 'Delimiter', ';', 'HeaderLines', 8);
    fclose(Actual);
    dataMatrix = cell2mat(data);
    
    % Extract wavelength and intensity values from the data matrix
    wavelength = dataMatrix(:,1);
    intensity = dataMatrix(:,5);
    
    %     plot wavelength, intensity
    %     figure(130)
    %     plot(wavelength,intensity)
    %     hold on
    %     set(gca,'yscale','lin');
    % Find the indices of the peak regions
    peak_region1_indices = find(wavelength >= 588.3 & wavelength <= 589.3);
    %peak_region2_indices = find(wavelength >= 589.4 & wavelength <= 589.8);
    
    % Calculate the integrated peak area for each peak region
    peak_area1 = trapz(intensity(peak_region1_indices));
    % peak_area2 = trapz(intensity(peak_region2_indices));
    
    % Find the indices of the noise regions
    noise_region1_indices = find(wavelength >= noise_region1(1) & wavelength <= noise_region1(2));
    %noise_region2_indices = find(wavelength >= noise_region2(1) & wavelength <= noise_region2(2));
    
    
    
    % plot the noise and peak regions
    %     figure(i)
    %     hold on;
    %     plot(wavelength(peak_region1_indices),intensity(peak_region1_indices))
    %
    %     plot(wavelength(noise_region1_indices),intensity(noise_region1_indices))
    
    
    
    % Fit a linear curve to the continuum intensity in each noise region
    p1 = polyfit(wavelength(noise_region1_indices), intensity(noise_region1_indices), 1);
    %p2 = polyfit(wavelength(noise_region2_indices), intensity(noise_region2_indices), 1);
    
    % Calculate the rms noise in each noise region
    noise_rms(i) = rms(intensity(noise_region1_indices) - polyval(p1, wavelength(noise_region1_indices)));
    %noise2 = rms(intensity(noise_region2_indices) - polyval(p2, wavelength(noise_region2_indices)));
    
    % plot the background level
    %     plot(wavelength(noise_region1_indices),polyval(p1,wavelength(noise_region1_indices)))
    
    
    % calculate the area below each peak
    background =  polyval(p1, wavelength(noise_region1_indices));
    background_height = background(end);
    background_height_values(i) = background_height;
    background_width = 589.28 - 588.48;
    background_area = background_width * background_height;
    
    
    % compute the average background height
    noise_level = mean(background_height_values);
    
    
    [xData, yData] = prepareCurveData( wavelength(peak_region1_indices), intensity(peak_region1_indices) - background_height);
    ft = fittype( 'gauss1' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf 0];
    opts.StartPoint = [140, 589, 0.2];
    [fitresult, gof{i}] = fit( xData, yData, ft, opts );
    % interpolate x axis around the peak
    interpl_xaxis = linspace(wavelength(peak_region1_indices(1) - 10),wavelength(peak_region1_indices(end) + 10),1000);
    
    
    
    peak_gaussian = fitresult(interpl_xaxis);
    %     plot(interpl_xaxis,peak_gaussian + background_height)
    
    
    
    % Calculate the SNR for the peak region
    peak_indices = [peak_region1_indices];
    peak_area(i) = trapz(interpl_xaxis,peak_gaussian);
    
    try
        peak_width(i) = fwhm(interpl_xaxis, peak_gaussian);
    catch
        
        peak_width(i) = NaN;
    end
    
    if ~isnan(peak_width(i))
        
        snr_values(i) = peak_area(i) / (peak_width(i) * noise_rms(i));
    else
        snr_values(i) = NaN;
        
    end
    
    % estimate peak height
    peak_height(i) = peak_area(i) / peak_width(i);
    
    
    
    % check if snr_values should be omitted or set to NaN
    if snr_values(i) > snr_threshold_high
        omitted_snr_values = [omitted_snr_values, snr_values(i)];
        num_omitted = num_omitted + 1;
    elseif gof{i}.rsquare < 0.6
        snr_values(i) = 0;
        peak_height(i) = 0;
        peak_area(i) = 0;
        peak_width(i) = 0;
        
    end
    
    
    
    % Plot the intensity vs. wavelength with the SNR value in the title
    %figure();
    %plot(wavelength, intensity);
    %title(sprintf('SNR = %.2f', snr_values(i)));
    % xlabel('Wavelength');
    % ylabel('Intensity');
    figure(120)
    hold on
    yyaxis left
    plot(i,gof{i}.rsquare,'marker','x','color','b')
    yyaxis right
    plot(i,snr_values(i),'marker','x','color','r')
    
end



output.snr_values = snr_values;
output.peak_height = peak_height;
output.peak_area = peak_area;
output.peak_width = peak_width;
output.noise_rms = noise_rms;