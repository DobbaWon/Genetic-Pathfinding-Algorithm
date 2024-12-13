function children = scalingMutation(children, mutationChance, mutationBounds, gen, generations)
    numChildren = size(children, 1);
    numGenes = size(children, 2) / 2; % numOfPointsInSolution

    % Calculate scaled mutation based on generations elapsed
    scaledMutation = round((gen/generations + 1) * mutationBounds);
    if scaledMutation > 500
        scaledMutation = 500;
    end

    for i = 1:numChildren
        if rand < mutationChance
            % Choose a random gene
            gene = randi([1, numGenes]);
            
            % Find xIdx and yIdx for the selected gene
            xIdx = 2 * gene - 1;
            yIdx = 2 * gene;
            
            % Generate random mutation 
            xMutation = randi([-scaledMutation, scaledMutation]);
            yMutation = randi([-scaledMutation, scaledMutation]);
            
            % Apply mutation 
            newX = children(i, xIdx) + xMutation;
            children(i, xIdx) = min(max(newX, 1), 500); 
            newY = children(i, yIdx) + yMutation;
            children(i, yIdx) = min(max(newY, 1), 500);
        end
    end
end