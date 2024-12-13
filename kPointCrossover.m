function children = kPointCrossover(parents)
    numParents = size(parents, 1); 
    numGenes = size(parents, 2); 
    children = zeros(numParents, numGenes); 

    for i = 1:2:numParents-1 % Increment by 2 to go through pairs
        % Select two parents
        parent1 = parents(i, :);
        parent2 = parents(i+1, :);

        % Choose a random crossover point
        k = randi([1, numGenes]);

        % Create children
        children(i, :) = [parent1(1:k), parent2(k+1:end)];
        children(i+1, :) = [parent2(1:k), parent1(k+1:end)];
    end
end
