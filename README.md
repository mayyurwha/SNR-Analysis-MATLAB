# SNR-Analysis-MATLAB
Analysis of Signal-to-Noise Ratio (SNR) in Spectroscopy Measurements using MATLAB

The MATLAB script 'combining_measurements_single.m' serves as a comprehensive tool for the analysis of spectroscopy data, specifically focusing on the computation of the SNR and detailed characterization of peak regions within the acquired spectra.
The script reads data from text files in a specified folder, defines noise and peak regions within the spectrum, calculates integrated peak areas using the trapezoidal ruke, fits a linear curve to the continuum intensity in noise regions to estimate background,
fits a gaussian function to the peak region to extract peak characteristics. computes SNR for each peak region based on the peak area, width, and noise.


The MATLAB script 'combining_measurements_script.m' calls the 'combining_measurements_single.m' for different folders and SNR thresholds, plots histograms of SNR values for each dataset, computes and plots median values for SNR, peak area, height, width, and noise RMS.
