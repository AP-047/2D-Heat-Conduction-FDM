clear
clc

% Parameters
Lx = 2.0; % Length of the plate in x-direction (m)
Ly = 1.0; % Length of the plate in y-direction (m)
Nx = 50; % Number of grid points in x-direction
Ny = 25; % Number of grid points in y-direction
dx = Lx / (Nx - 1); % Grid spacing in x-direction
dy = Ly / (Ny - 1); % Grid spacing in y-direction
k = 50; % Heat conductivity (W/(mK))

% Initialize temperature matrix
T = zeros(Ny, Nx);

% Boundary conditions
T(:, 1) = 20; % Temperature T1 applied on the left boundary
T(:, end) = 40; % Temperature T2 applied on the right boundary

% Heat input Q1 applied at the bottom boundary
Q1 = 420; % Heat flux in W/m^2

% Iterative solution using the finite difference method
maxIter = 1000; % Maximum number of iterations
tolerance = 0.0001; % Threshold for minimal temperature change

for iter = 1:maxIter
    T_old = T; % Store current temperatures for next iteration comparison
    
    for i = 1:Ny
        for j = 2:(Nx-1)
            if i == 1 % Bottom boundary
                T(i, j) = T(i+1, j) + Q1 * (dx / k);
            elseif i == Ny % Top boundary
                T(i, j) = T(i-1, j);
            else % Interior points
                % Apply finite difference method for interior points
                if j > 1 && j < Nx
                    T(i, j) = (T(i+1, j) + T(i-1, j) + T(i, j+1) + T(i, j-1)) / 4;
                end
            end
        end
    end
    
    % End loop if temperature changes are small enough, indicating steady state
    if max(max(abs(T_old - T))) < tolerance
        fprintf('Steady state reached in %d iterations\n', iter);
        break;
    end
end

% Plot temperature distribution
[X, Y] = meshgrid(linspace(0, Lx, Nx), linspace(0, Ly, Ny));
colormap(jet);
contourf(X, Y, T, 100, 'LineColor', 'none');

cbar = colorbar; % Get the handle of the colorbar
ylabel(cbar, 'Temperature (°C)'); % Set the label for the colorbar
xlabel('x (m)');
ylabel('y (m)');
title('Temperature Distribution');
