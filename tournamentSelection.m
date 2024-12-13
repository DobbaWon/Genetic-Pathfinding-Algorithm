% Make tournaments where the solutions are selected randomly and the best
% solution wins
% Much more elitist
function parents = tournamentSelection(population, fitness)
    tournamentSize = 8;
    numParents = size(population, 1);
    parents = zeros(numParents, size(population, 2));
    
    for i = 1:numParents
        % Randomly select solutions:
        tournamentSolutions = randperm(numParents, tournamentSize);
        tournamentFitness = fitness(tournamentSolutions);
        
        % Find the best solution's index in this tournament:
        [~, bestIdx] = min(tournamentFitness); % ~ to discard
        
        % Set it to be the winner:
        parents(i, :) = population(tournamentSolutions(bestIdx), :);
    end
end
