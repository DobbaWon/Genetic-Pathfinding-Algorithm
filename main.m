map = im2bw(imread('random_map.bmp'));

% Configurables:
noOfPointsInSolution = 10;
populationSize = 250; 
generations = 1000;
mutationChance = 0.25;
punishment = 1000;
mutationBounds = 50; % Area around current pixel that the next mutation can be

bestPath = [];
bestFitness = inf;
population = round(rand(populationSize, 2 * noOfPointsInSolution) * 500);
%% User Prompt

disp("Select selection method:");
disp("0: Roulette Wheel");
disp("1: Rank-Based Selection");
disp("2: Tournament Selection");
selectionMethod = input("Enter the selection method (0/1/2): ");

disp("Select crossover method:");
disp("0: Uniform Crossover");
disp("1: k Point Crossover");
crossoverMethod = input("Enter the crossover method (0/1): ");

disp("Select mutation method:");
disp("0: Random Mutation");
disp("1: Scaling Mutation");
mutationMethod = input("Enter the mutation method (0/1): ");

%% Main Loop
tic
for gen = 1:generations
    % Display Progress:
    if mod(gen, generations/10) == 0
        percent = ceil(gen / (generations/10)) * 10;
        display(percent+"% Complete!");
    end
    
    % Get Fitness
    fitness = fitnessTest(population, map, noOfPointsInSolution, punishment);

    % Selection
    switch selectionMethod
        case 0
            parents = rouletteWheelSelection(population, fitness);
        case 1
            parents = rankBasedSelection(population, fitness);
        case 2
            parents = tournamentSelection(population, fitness);
        otherwise
            error("Invalid selection method.");
    end

    % Crossover
    switch crossoverMethod
        case 0
            children = uniformCrossover(parents);
        case 1
            children = kPointCrossover(parents);
        otherwise
            error("Invalid crossover method.");
    end

    % Mutate
    switch mutationMethod
        case 0
            children = randomMutation(children, mutationChance, mutationBounds);
        case 1
            children = scalingMutation(children, mutationChance, mutationBounds, gen, generations);
        otherwise
            error("Invalid mutation method.");
    end

    % Set next Generation
    population = children; 

    % Get the current best fitness and best path from the population
    [currentBestFitness, bestIdx] = min(fitness);
    currentBestPath = population(bestIdx, :);

    % Update the best fitness and best path if needed
    if currentBestFitness < bestFitness
        bestFitness = currentBestFitness;
        bestPath = currentBestPath;
    end
end
toc

function pathDistance = getEuclideanDistance(x_coords, y_coords)
    pathDistance = 0;
    
    % Combine x and y coordinates into a path matrix
    path = [x_coords(:), y_coords(:)];  % Ensure they are column vectors
    
    % Loop through each consecutive pair of points
    for i = 1:(size(path, 1) - 1)
        % Calculate Euclidean distance between consecutive points
        pathDistance = pathDistance + norm(path(i,:) - path(i+1,:));  % Distance between consecutive points
    end
    
    % Add the distance from the last point to the goal (e.g., [500, 500])
    pathDistance = pathDistance + norm(path(end,:) - [500, 500]);
end

%% Final Section

x_coords = bestPath(1:2:end);
y_coords = bestPath(2:2:end);

start = [0, 0];
finish = [500, 500];

% Display Final Result:
path = [start; [x_coords', y_coords']; finish];
clf;
imshow(map);
rectangle('position', [1 1 size(map) - 1], 'edgecolor', 'k');
line(path(:, 2), path(:, 1));

display("Distance: " + getEuclideanDistance(x_coords, y_coords));
