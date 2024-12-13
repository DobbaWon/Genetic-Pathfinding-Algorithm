function parents = rankBasedSelection(population, fitness)
    numSolutions = size(population, 1);
    
    % Sort fitness values in descending order and get the indices
    [~, sortedIndices] = sort(fitness, 'descend'); % Discarding the values just keeping the indices
    
    % Assign ranks (1 for worst, numSolutions for best)
    ranks = 1:numSolutions;
    
    % Compute cumulative ranks
    cumulativeRanks = cumsum(ranks);
    totalProbability = cumulativeRanks(end); % Total sum of ranks
    
    % Select parents based on the cumulative ranks
    parents = zeros(numSolutions, size(population, 2));
    for i = 1:numSolutions
        r = randi([1, totalProbability]);  % Random number between 1 and totalProbability
        idx = find(cumulativeRanks >= r, 1, 'first');
        parents(i, :) = population(sortedIndices(idx), :); % Select parent corresponding to rank generated
    end
end