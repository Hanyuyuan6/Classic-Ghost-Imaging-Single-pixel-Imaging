function matrices = Generate_Uniform_Random_Matrices(n, m, rand_number_down, rand_number_up)
% n = Total number of matrices to generate
% m = Dimension of each generated matrix
% rand_number_down = Lower bound of the random numbers
% rand_number_up = Upper bound of the random numbers

matrices = cell(1, n); % Create a cell array containing n elements
    for i = 1:n
        matrices{i} = rand_number_down + (rand_number_up - rand_number_down) * rand(m, m); % Generate an m x m random matrix and store it in the cell array
    end                                                                                    % rand function returns values uniformly distributed in the interval (0,1)
end