clc;
clear;

% Set parameters
n = 4096;  % Number of random matrices to generate
m = 64;    % Dimension of the random matrices

% Generate random matrices
randomMatrices = Generate_Uniform_Random_Matrices(n, m, 0, 256);

% Get the directory of the current script
scriptFolder = fileparts(mfilename('fullpath'));

% **Save .mat file to the script directory**
savePath = fullfile(scriptFolder, 'rand_M_64.mat');
save(savePath, 'randomMatrices');
fprintf('Random matrices saved to: %s\n', savePath);

% **Convert to images and save**
illuminationFieldFolder = fullfile(scriptFolder, 'data_illumination_field');
imageSaveFolder = fullfile(illuminationFieldFolder, 'random_matrix_uniform_64');

% Create directory if it does not exist
if ~exist(imageSaveFolder, 'dir')
    mkdir(imageSaveFolder);
end

% **Loop to save images**
numMatrices = numel(randomMatrices);

for i = 1:numMatrices
    img = uint8(randomMatrices{i}); % Convert to uint8
    imagePath = fullfile(imageSaveFolder, sprintf('random_uniform%d.png', i));
    imwrite(img, imagePath);
end

fprintf('All images saved to: %s\n', imageSaveFolder);