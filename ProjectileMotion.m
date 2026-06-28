% Project: 2D Projectile Motion Simulation
%    Author: Mir Md Minhaajuddin
%    B.Tech Mechanical Engineering student [Batch: 2023-2027]
%    @Aliah University, Kolkata
%    01/06/2026

% Description
%   This program is to simulate the two-dimensional projectile motion of
%   an object under gravitational acceleration. It's numerically computes
%   and graphically visualized the trajectory using kinematic equations
%   of motion in MATLAB.

% Features
%    1. User defined input parameters (v0, angle, g and h0)
%    2. Ground impact detection with filtering
%    3. Compute max height, range and time of flight
%    4. Comparison between multiple launch angel
%    5. Shows the trajectory path along with it's peak
%    6. Real time animation of projectile motion

% Application
%    1. Ballistics
%    2. Aerospace
%    3. Defence
%    4. Sport Engineering

% Software
%    MATLAB (Student)

clc;		 % Clear command window
clear;		 % Clear all the variables
close all;	 % Close all open figures
%% Title

fprintf('2D Projectile Motion Simulation\n')
fprintf('Developed by: Mir Md Minhaajuddin \n')
fprintf('B.Tech Mech Engg Student | Aliah University \n')
fprintf('\n')

%% Input section

% Initial Velocity, v0
v0 = input('Initial Velocity (m/s): ');
while v0 <= 0
    fprintf('Velocity must be positive.\n')
    v0 = input('Initial Velocity (m/s): ');
end

% Gravitational Acceleration
g = input('Gravitational Acceleration (m/s^2): ');
while g <= 0
    fprintf('Gravitational Acceleration must be positive.\n')
    g = input('Gravitational Acceleration (m/s^2): ');
end

% Initial Height
h0 = input('Initial Height (m): ');
while h0 < 0
    fprintf('Initial Height must be positive.\n')
    h0 = input('Initial Height (m): ');
end

% Launch Angle, theta
angle = [];
while true
	val = input('Enter different Launch Angles (to finish enter f): ', 's');
    if strcmp(val, 'f')
	    break;
    end
    num = str2double(val);
    if isnan(num) || num < 0 || num > 90
        disp('Invalid! Angle must be with in 0° to 90°')
    else
        angle = [angle, num];
    end
end

% Accepted Values
fprintf('\nAccepted Values.\n')
fprintf('Initial Velocity, v0: %.2f m/s\n', v0)
fprintf('Gravitational Acceleration, g: %.2f m/s^2\n', g)
fprintf('Initial Height, h0: %.2f m\n', h0)
fprintf('Launch Angle, theta: %g deg\n', angle)
fprintf('\n')

%% Main Computing

% defining storage for the computed data
x_store = cell(1, length(angle));
y_store = cell(1, length(angle));
x_valid_store = cell(1, length(angle));
y_valid_store = cell(1, length(angle));
x_at_peak_store = zeros(1, length(angle));
y_at_peak_store = zeros(1, length(angle));
x_range_store = zeros(1, length(angle));

% Computing loop, computing for the each given angle
for i = 1:length(angle)
    theta = angle(i);
    theta_rad = deg2rad(theta);

    fprintf('\nCompute for the angle: %.2f\n', angle(i))

    % Velocity components
    vx = v0 * cos(theta_rad);
    vy = v0 * sin(theta_rad);

    fprintf('\nVelocity Componentas\n')
    fprintf('Horizontal (vx): %.2f m/s.\n', vx)
    fprintf('Vertical (vy): %.2f m/s.\n', vy)

    % Position Eqn, y(t) = h0 + (vy * t) - (0.5 * g * t.^2)
    % Putting y(t) = 0, we get 0.5*g*t^2 - vy*t - h0 = 0
    a = 0.5 * g;
    b = -vy;
    c = -h0;

    % discriminate
    d = b.^2 - (4 * a * c);

    % roots
    t1 = (- b + sqrt(d)) / (2 * a);
    t2 = (- b - sqrt(d)) / (2 * a);

    % total flight time
    T = max(t1, t2);

    fprintf('\nTime of flight: %.2f sec.\n', T)

    % Time interval
    t = linspace(0, T, 1000);

    % Trajectory
    x = vx * t;
    y = h0 + (vy * t) - (0.5 * g * t.^2);

    fprintf('\n X range: 0 to %.2f m.\n', max(x))
    fprintf('\n Y range: %.2f to %.2f m.\n', min(y), max(y))


    % Ground Hitting
    valid = y >= 0;
    t_valid = t(valid);
    x_valid = x(valid);
    y_valid = y(valid);


    % Engineering Matrix
    [y_max, idx_max] = max(y_valid);
    x_at_peak = x_valid(idx_max);
    t_at_peak = t_valid(idx_max);

    x_range = x_valid(end);			                                       % The last value of x_valid point = the ground impact point
    t_flight = t_valid(end);		                                       % Total flight time, time upto ground impact

    % Theoretical maximum height ( assume, h0 = 0)
    y_max_theory = (vy^2) / (2 * g);


    fprintf('\nEngineering Matrix\n');
    fprintf('Maximum Height 	: %.2f m\n', y_max);
    fprintf('Maximum Height at x	: %.2f m\n', x_at_peak);
    fprintf('Maximum Height at t	: %.2f sec\n', t_at_peak);
    fprintf('Horizontal Range	: %.2f m\n', x_range);
    fprintf('Total Flight Time	: %.2f sec\n', t_flight);
    fprintf('\n')
    fprintf('Maximum Height (Theory)	: %.2f m\n', y_max_theory);
    fprintf('Maximum Height (Simul.)	: %.2f m\n', y_max);
    fprintf('Max Height from initial, h0	: %.2f m\n', abs(y_max - y_max_theory));

    x_store{i} = x;
    y_store{i} = y;
    x_valid_store{i} = x_valid;
    y_valid_store{i} = y_valid;
    x_at_peak_store(i) = x_at_peak;
    y_at_peak_store(i) = y_max;
    x_range_store(i) = x_range;

end

%% Plotting

% Trajectory Plot{i}
colors = lines(length(angle));
figure('Name', '2D Projectile Motion');
hold on;

x_max = max(cellfun(@max, x_valid_store)) + 20;
plot([0, x_max], [0, 0], 'm-', 'LineWidth', 1.2, 'DisplayName', 'Ground');                  % Ground
plot([0, x_max], [h0, h0], 'g--', 'LineWidth', 0.75, 'DisplayName', 'Launch Line');         % Launch Line

for i = 1:length(angle)

    fprintf('\nPlotting for the angle: %g', angle(i))                      % Angle

    plot(x_valid_store{i}, y_valid_store{i}, '-', ...
        'Color', colors(i, :) , 'LineWidth', 2, ...
        'DisplayName', sprintf('%g°', angle(i)));		                   % Actual Trajectory

    plot(x_store{i}, y_store{i}, 'w--', ...
        'LineWidth', 1.5, ...
        'HandleVisibility','off');			                               % Unfiltered trajectory


    plot(x_at_peak_store(i), y_at_peak_store(i), ...
        'd', 'MarkerSize', 7, 'MarkerEdgeColor','w', ...
        'MarkerFaceColor', colors(i, :), 'DisplayName', 'Peak Point') 	   % Peak point

    plot(x_range_store(i), 0, 'o', 'MarkerSize', 7, ...
        'MarkerEdgeColor','w', 'MarkerFaceColor', ...
        colors(i, :), 'DisplayName', 'Imact Point')	                       % Impact point

    %xline(x_at_peak_store(i), 'k--', 'LineWidth', 0.25, ...
        %'HandleVisibility','off')                                          % Peak point marker on x-axis

    %yline(y_at_peak_store(i), 'k--', 'LineWidth', 0.25, ...
        %'HandleVisibility','off', ...
        %'Label', sprintf('%.2f m', y_at_peak_store(i)))                                     % Peak point marker on y-axis

    legend('show');

end




xlim([0, max(cellfun(@max, x_valid_store)) + 20]);
ylim([0, max(cellfun(@max, y_valid_store)) + 20]);

title('2D Projectile Motion')
xlabel('Horizontal Distance (m)');
ylabel('Height (m)');

grid on;
grid minor;
hold off;