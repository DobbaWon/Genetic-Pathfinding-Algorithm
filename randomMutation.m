function children = randomMutation(children, mutationChance, mutationBounds)
    numChildren = size(children, 1);
    numGenes = size(children, 2) / 2; % numOfPointsInSolution

    for i = 1:numChildren
        if rand < mutationChance
            % Choose a random gene
            gene = randi([1, numGenes]);
            
            % Find xIdx and yIdx for the selected gene
            xIdx = 2 * gene - 1;
            yIdx = 2 * gene;
            
            % Generate random mutation 
            xMutation = randi([-mutationBounds, mutationBounds]);
            yMutation = randi([-mutationBounds, mutationBounds]);
            
            % Apply mutation 
            newX = children(i, xIdx) + xMutation;
            children(i, xIdx) = min(max(newX, 1), 500); 
            newY = children(i, yIdx) + yMutation;
            children(i, yIdx) = min(max(newY, 1), 500);
        end
    end
end
