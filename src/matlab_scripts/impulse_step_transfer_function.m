function [g, h] = impulse_step_transfer_function(u, y, t, sys)

    U_matrix = zeros(length(u), length(u));
    for i=1:length(u)
        for j=1:length(u)
            if i >= j
                U_matrix(i, j) = u(i - j + 1);
            end
        end
    end
    
    g = U_matrix\y;
    h = cumsum(g);

    figure
    plot(t, g)
    xlabel('Czas [s]')
    ylabel('g(N)')
    title('Wykres g(t_i)')
    grid on
    
    figure
    hold on
    plot(t, h, 'r')
    step(sys)
    hold off
    xlabel('Czas [s]')
    ylabel('h(N)')
    title('Wykres h(t_i)')
    grid on
end