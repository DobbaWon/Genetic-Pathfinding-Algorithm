% Make a swapper mask and swap bits according to it:
function chidlren = uniformCrossover(parents)
    numParents = size(parents, 1);
    numGenes = size(parents, 2);
    chidlren = zeros(numParents, numGenes);

    for i = 1:2:numParents-1
        parent1 = parents(i, :);
        parent2 = parents(i+1, :);

        swapper = randi([0, 1], 1, numGenes); % Creates something that looks like this: [0,1,1,1,0,0,0,1,1]
        
        child1 = parent1;
        child2 = parent2;
    
        % Loop through each gene
        % If 1 then keep the genes the same
        % If not then swap the genes
        for j = 1:numGenes
            if swapper(j) == 1
                child1(j) = parent1(j);
                child2(j) = parent2(j); 
            else
                child1(j) = parent2(j);
                child2(j) = parent1(j); 
            end
        end
        
        chidlren(i, :) = child1;
        chidlren(i+1, :) = child2;
    end
end
