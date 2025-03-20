clc;
clear;

% Get the directory of the current script
script_folder = fileparts(mfilename('fullpath'));

% Read the target image file
obj = imread("littleGI64.tif");

% Specify the folder path for storing random illumination matrices (relative path)
folderPath = fullfile(script_folder, 'data_illumination_field', 'random_matrix_uniform_64');

% Get a list of all image files with the .png extension in the specified folder
imageFiles = dir(fullfile(folderPath, '*.png'));

% Specify the number of random illumination matrices to use
numImages = 4096;

% Create a cell array to store random illumination matrix data
imageData = cell(1, numImages);

for i = 1:numImages
    imagePath = fullfile(folderPath, imageFiles(i).name);
    img = imread(imagePath);
    img = im2double(img);
    imageData{i} = img;
end

% Get the dimensions of the target image
n = size(obj);
n = [n, 0];  % Ensure n is at least a 1x3 dimension
m = n(1);    % Set m as the image height

% If the image is in color, convert it to grayscale
if n(3) == 3
    obj = rgb2gray(obj);
    obj = double(obj);
else
    obj = im2double(obj);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%       Initialization      %%%%%%%%%%%%%%%%%%%%%%%%
B = [];  
G_2 = zeros(m, m);  
rand_M_all = zeros(m, m);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = numImages;
rand_M = imageData;

for i = 1:k
    rand_M_i = rand_M{i};
    In_obj = rand_M_i .* obj;
    B_i = sum(In_obj(:));
    
    G_2 = G_2 + rand_M_i .* B_i;
    B(i) = B_i;
    rand_M_all = rand_M_all + rand_M{i};
end

B_average = sum(B) / k;
rand_M_average = rand_M_all / k;

T_G_2 = zeros(m, m);
for i = 1:k
    T_G_2 = T_G_2 + (rand_M{i} - rand_M_average) .* (B(i) - B_average);
end

N_G_2 = (G_2 / k) ./ (rand_M_average .* B_average);

m = 1;  % Differential ratio coefficient
D_G_2 = (G_2 / k) - m .* (rand_M_average .* B_average);

% Normalization processing
B = (B - min(B)) / (max(B) - min(B));
T_G_2 = (T_G_2 - min(T_G_2(:))) / (max(T_G_2(:)) - min(T_G_2(:)));
D_G_2 = (D_G_2 - min(D_G_2(:))) / (max(D_G_2(:)) - min(D_G_2(:)));
N_G_2 = (N_G_2 - min(N_G_2(:))) / (max(N_G_2(:)) - min(N_G_2(:)));
obj = (obj - min(obj(:))) / (max(obj(:)) - min(obj(:)));

% Compute Signal-to-Noise Ratio (SNR)
SNR_T_G_2 = 20 * log10(norm(T_G_2(:)) / norm(T_G_2(:) - obj(:)));
SNR_D_G_2 = 20 * log10(norm(D_G_2(:)) / norm(D_G_2(:) - obj(:)));
SNR_N_G_2 = 20 * log10(norm(N_G_2(:)) / norm(N_G_2(:) - obj(:)));

% Display three ghost imaging results with SNR values in the figure
figure;

subplot(1, 3, 1);
imagesc(T_G_2); colormap('gray'); title('T_G_2 ');
text(10, 10, ['SNR: ', num2str(SNR_T_G_2, '%.2f'), ' dB'], 'Color', 'white', 'FontSize', 12);

subplot(1, 3, 2);
imagesc(D_G_2); colormap('gray'); title('D_G_2 ');
text(10, 10, ['SNR: ', num2str(SNR_D_G_2, '%.2f'), ' dB'], 'Color', 'white', 'FontSize', 12);

subplot(1, 3, 3);
imagesc(N_G_2); colormap('gray'); title('N_G_2 ');
text(10, 10, ['SNR: ', num2str(SNR_N_G_2, '%.2f'), ' dB'], 'Color', 'white', 'FontSize', 12);