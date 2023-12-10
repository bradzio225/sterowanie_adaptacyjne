function [n, tau_m, T_m] = two_point_Strejc(inputArg1,inputArg2)
    n_vec = 2:7;
    h_n = [0.264, 0.323, 0.353, 0.371, 0.384, 0.394];
    t_vec = zeros(1,6);
    T_vec = zeros(1,6);
    T_vec_coef = [0.34605, 0.30009, 0.27168, 0.25040, 0.23393, 0.22065];
    tau_vec = zeros(1,6);
    G_iter = zeros(1,6);
    diff = abs(h - 0.9);
    [min_diff, indeks] = min(diff);
    T_90 = t(indeks)
    
    for iter = 1:6
    
        diff = abs(h - h_n(iter));
        [min_diff, indeks] = min(diff);
        t_vec(iter) = t(indeks);
        T_vec(iter) = T_vec_coef(iter) * ((T_90) - t_vec(iter));
        tau_vec(iter) = t_vec(iter) - iter*T_vec(iter);
    end 
    t_vec 
    T_vec 
    tau_vec


    syms s
    
    for iter = 1:3
        num = 1;
        poly = (T_vec(iter) * s + 1)^(iter+1);
        den = sym2poly(poly);
        G(iter) = tf(num, den, 'InputDelay',tau_vec(iter));
    end 
    G


    figure
    for i = 1:3
        subplot(3, 1, i)
        hold on
        plot(t, h, 'r')
        step(G(i))
        hold off
        xlabel('Czas [s]')
        ylabel('h(N)')
        txt = sprintf('Strejc %d-rzędu', i+1);
        legend('Oryginalny', txt)
        title('Wykres h(t_i) Strejc')
        grid on
    end
    
    mean_squared_error = zeros(1, 3);
    for i = 1:3
        step_response = step(G(i), 0:0.01:69.99);
        mean_squared_error(i) = sum((step_response - h).^2);
    end
    mean_squared_error
end

