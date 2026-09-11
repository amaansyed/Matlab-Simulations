%% Airfoil Aerodynamic Coefficients vs Angle of Attack
% Thin airfoil theory for lift + empirical drag polar

clear; clc; close all;

alpha_deg = -5:0.5:15;
alpha = deg2rad(alpha_deg);

alpha0 = deg2rad(-2);  % zero-lift angle (cambered airfoil)
a0 = 2*pi;             % lift-curve slope (thin airfoil theory)

Cl = a0 * (alpha - alpha0);

% Stall model: cap and drop beyond critical AoA
alpha_stall = deg2rad(12);
Cl(alpha > alpha_stall) = Cl(alpha_deg == 12) .* ...
    exp(-3*(alpha(alpha > alpha_stall) - alpha_stall));

Cd0 = 0.008;
k = 0.045; % induced drag factor
Cd = Cd0 + k .* Cl.^2;

figure;
subplot(1,2,1);
plot(alpha_deg, Cl, 'LineWidth', 1.8);
xlabel('Angle of Attack (deg)'); ylabel('C_l'); grid on;
title('Lift Coefficient vs AoA');

subplot(1,2,2);
plot(Cd, Cl, 'LineWidth', 1.8);
xlabel('C_d'); ylabel('C_l'); grid on;
title('Drag Polar');

[~, idx] = max(Cl./Cd);
fprintf('Best L/D at alpha = %.1f deg, L/D = %.1f\n', alpha_deg(idx), Cl(idx)/Cd(idx));
