function fitness = fitnessTest(population, map, noOfPointsInSolution, punishment)
    fitness = zeros(size(population, 1), 1);
    
    for i = 1:size(population, 1) % Loop over each solution
        solution = population(i, :);
        x_coords = solution(1:2:end);
        y_coords = solution(2:2:end);
        path = [x_coords', y_coords'];  % ' operator flips the coords into columns

        penalty = 0;

        % Check if there are identical points in the path
        penalty = hasIdenticalPoints(path, penalty);
        
        % Check if the points regress at any point (go backwards)
        penalty = checkRegressingPoints(x_coords, y_coords, penalty, punishment);

        % Check for obstacles passed through
        penalty = givePenaltyForObstacles(path, map, punishment, penalty);

        % Check for points generated in obstacles
        penalty = checkPointsInObstacles(x_coords, y_coords, map, penalty);

        % Calculate path length
        pathLength = 0;
        for j = 1:(noOfPointsInSolution-1) % Every point other than the last one
            pathLength = pathLength + norm(path(j,:) - path(j+1,:)); % Get the distance between the two vectors
        end
        pathLength = pathLength + norm(path(end,:) - [500, 500]); % Distance between last point and end.
        pathLength = round(pathLength, 0);
           
        % Total fitness
        fitness(i) = (pathLength + penalty);
    end
end

% Check for identical points
function penalty = hasIdenticalPoints(path, penalty)
    numPoints = size(path, 1);

    for i = 1:numPoints
        for j = i+1:numPoints
            if isequal(path(i, :), path(j, :))  % Check if two points are the same
                penalty = penalty + 100000000;
            end
        end
    end
end

% Check for regressing points
function penalty = checkRegressingPoints(x_coords, y_coords, penalty, punishment)
    for j=1:length(x_coords)
        % Punishment for non-increasing points
        if j > 1 % Check from the second point onward
            difference = (x_coords(j-1) - x_coords(j)) + (y_coords(j-1) - y_coords(j));
            if difference > 0
                penalty = penalty + (punishment * 1000 * difference);
            else
                if difference > -50
                    penalty = penalty + (punishment * 1000 * (difference+50));
                end
            end
        end
    end
end

% Check for points directly generated in obstacles
function penalty = checkPointsInObstacles(x_coords, y_coords, map, penalty)
    for j = 1:length(x_coords)
        % Make sure points are actually on the map:
        if x_coords(j) >= 1 && x_coords(j) <= 500 && ...
           y_coords(j) >= 1 && y_coords(j) <= 500
            if map(x_coords(j), y_coords(j)) == 0
                penalty = penalty + 100000000; % Obstacle penalty
            end
        end
    end
end

% Check for lines in obstacles
function penalty = givePenaltyForObstacles(path, map, punishment, penalty)
    % Check if the first line intersects
    firstLine = [1, 1; path(1, :)];
    penalty = checkObstacles(firstLine, map, penalty, punishment);
    
    % Check if any part of the path intersects up to the last point
    for i = 1:(size(path, 1) - 1) 
        line = [path(i, :); path(i+1, :)];
        penalty = checkObstacles(line, map, penalty, punishment);
    end
    
    % Check if the last point to [500, 500] intersects
    lastPoint = path(end, :);
    lastLine = [lastPoint; 500, 500];
    penalty = checkObstacles(lastLine, map, penalty, punishment);
end

% Check for lines in obstacles
function penalty = checkObstacles(line, map, penalty, punishment)
    x1 = round(line(1, 1)); 
    y1 = round(line(1, 2));
    x2 = round(line(2, 1)); 
    y2 = round(line(2, 2)); 

    % Get the number of steps based on the distance
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    
    % The number of steps to generate points
    steps = max(dx, dy); % Choosing the maximum distance value as our denominator for later
    
    x_points = zeros(1, steps);
    y_points = zeros(1, steps);
    
    % Generate points along the line
    for i = 1:steps
        interpolation = i / steps; % How far along the line we are
        x_points(i) = round(x1 + interpolation * (x2 - x1)); % This point on the line so far
        y_points(i) = round(y1 + interpolation * (y2 - y1));

        % Making sure no pixel is equal to 0 for indexing:
        if (x_points(i) == 0)
            x_points(i) = 1;
        end
        if (y_points(i) == 0)
            y_points(i) = 1;
        end
    end

    % Check each point on the line to see if it intersects an obstacle
    for i = 1:length(x_points)
        if map(x_points(i), y_points(i)) == 0 % If its an obstacle
            penalty = penalty + punishment;
        end
    end
    % That means if more of a line is in an obstacle, it gets more of a
    % punishment
end
