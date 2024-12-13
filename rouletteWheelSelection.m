% Weighted probabilities based on fitness
% 1/fitness makes the values appropriate, making lower fitness values more
% likely to be picked
function parents = rouletteWheelSelection(population, fitness)
    inverseFitness = 1 ./ fitness; % element wise division ./ rather than dividing the matrix
    totalFitness = sum(inverseFitness);
    probabilities = inverseFitness / totalFitness;
    probabilitySum = cumsum(probabilities);
    
    numParents = size(population, 1);
    parents = zeros(numParents, size(population, 2));

    for i = 1:numParents
        r = rand;  % Random number between 0 and 1
        idx = find(probabilitySum >= r, 1, 'first');  % Select parent based on the random number
        parents(i, :) = population(idx, :);
    end
end
