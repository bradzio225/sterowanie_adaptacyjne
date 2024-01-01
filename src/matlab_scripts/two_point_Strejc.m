function [n_m, tau_m, T_m] = two_point_Strejc(t, h, stop_time)
    n_vec = 2:7;
    h_n = [0.264, 0.323, 0.353, 0.371, 0.384, 0.394];
    t_vec = zeros(1,6);
    T_vec = zeros(1,6);
    T_vec_coef = [0.34605, 0.30009, 0.27168, 0.25040, 0.23393, 0.22065];
    tau_vec = zeros(1,6);
    G_iter = zeros(1,6);
    diff = abs(h - 0.9);
    [min_diff, indeks] = min(diff);
    T_90 = t(indeks);
    
    for iter = 1:6
    
        diff = abs(h - h_n(iter));
        [min_diff, indeks] = min(diff);
        t_vec(iter) = t(indeks);
        T_vec(iter) = T_vec_coef(iter) * ((T_90) - t_vec(iter));
        tau_vec(iter) = t_vec(iter) - iter*T_vec(iter);
    end 
    "Znalezione opóźnienia obiektów"
    tau_vec
    tau_vec = tau_vec(tau_vec > 0);
    T_vec = T_vec(tau_vec > 0);

    syms s
    
    for iter = 1:length(tau_vec)
        num = 1;
        poly = (T_vec(iter) * s + 1)^(iter+1);
        den = sym2poly(poly);
        G(iter) = tf(num, den, 'InputDelay',tau_vec(iter));
    end 

    figure
    for i = 1:length(tau_vec)
        subplot(length(tau_vec), 1, i)
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
    
    mean_squared_error = zeros(1, length(tau_vec));
    for i = 1:length(tau_vec)
        step_response = step(G(i), 0:0.01:stop_time);
        mean_squared_error(i) = sum((step_response - h).^2);
    end
    mean_squared_error
    [~, min_index] = min(mean_squared_error);
    
    n_m = min_index + 1;
    tau_m = tau_vec(min_index);
    T_m = T_vec(min_index);
end

