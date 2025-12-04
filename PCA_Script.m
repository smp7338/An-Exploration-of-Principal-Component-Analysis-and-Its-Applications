%% PCA on Flight Performance Data
% This script performs PCA on a 10x5 dataset representing test flight 
% metrics.
% Variables:
%   1. Air Speed (m/s)
%   2. Climb Rate (m/s)
%   3. Power Consumption (W)
%   4. Vibration Amplitude (m/s^2)
%   5. Yaw Rate Stability Error (deg/s)
clc, clear, close all

% Flight Test Dataset
X = [12.1 1.8 94  0.42 1.9;
     11.4 1.3 89  0.40 2.5;
     13.2 2.1 102 0.48 1.4;
     12.9 2.0 99  0.52 1.6;
     10.7 1.0 87  0.33 3.1;
     14.0 2.4 105 0.58 1.2;
     13.7 2.2 103 0.55 1.3;
     11.1 1.4 88  0.37 2.7;
     12.5 1.9 96  0.47 1.8;
     10.9 1.1 86  0.35 3.0];

varNames = ["Air Speed (m/s)","Climb Rate (m/s)","Power (W)", ...
            "Vibration (m/s^2)","Yaw Error (deg/s)"];

%% PART A: Labeled Raw Data Plot (Pairwise)
figure;
[H,AX,BigAx] = plotmatrix(X);

% Label each small axis with variable names
for i = 1:length(varNames)
    AX(i,1).YLabel.String = varNames(i);
    AX(end,i).XLabel.String = varNames(i);
end

title(BigAx, 'Raw UAV Flight Data (Pairwise Variable Relationships)');

%% PART B: PCA Using SVD
Xc = X - mean(X,1);   % center data
[U,S,V] = svd(Xc,'econ');
Y = U*S;              % PCA scores

% Interpret PC loadings
PC1 = V(:,1);
PC2 = V(:,2);

disp('PC1 Loadings (Aerodynamic Loading Axis):');
disp(PC1);
disp('PC2 Loadings (Stability Error Axis):');
disp(PC2);

%% PART C: PCA Plot With Trend Line 
figure;
scatter(Y(:,1), Y(:,2), 80, 'filled'); hold on;
text(Y(:,1)+0.05, Y(:,2), string(1:10));

%  Least squares fit 
p_raw = polyfit(Y(:,1), Y(:,2), 1);
y_pred_raw = polyval(p_raw, Y(:,1));

% Compute residuals and identify outliers
res = Y(:,2) - y_pred_raw;
MAD = median(abs(res - median(res)));

% Define outlier threshold at 3 standard deviations
thresh = 3 * MAD;
inliers = abs(res - median(res)) < thresh;

% Refit trend line using inliers
x_in = Y(inliers,1);
y_in = Y(inliers,2);

p_final = polyfit(x_in, y_in, 1); 
xline = linspace(min(Y(:,1)), max(Y(:,1)), 200);
yline = polyval(p_final, xline);

% Final trend line plot
plot(xline, yline, 'r-', 'LineWidth', 2);

xlabel('PC1: Aerodynamic Loading / Propulsion Demand');
ylabel('PC2: Stability and Yaw Control Error');
title('Flight Data in PCA Space');
grid on;

% Mark removed outliers
outliers = ~inliers;
plot(Y(outliers,1), Y(outliers,2), 'ko', 'MarkerSize', 10, 'LineWidth', ...
    1.5, 'Color', 'Yellow');

legend('Flight Data','Trend Line (No Outliers)','Outliers','Location', ...
    'best');
