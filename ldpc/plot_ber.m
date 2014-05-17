% Given an array of tranisition probbilities and
% error rates for a code, plot them
function plot_ber(transition_prob, bers)
    % Plot transition probability vs BER
    
    bers(bers==0) = 10e-10;
    figure
    semilogy(transition_prob, bers,'r');
    hold on
    xlabel('Transition probability (p)');
    ylabel('Bit error rate (BER)');
    semilogy(transition_prob, transition_prob);
    legend('Coded', 'Uncoded');
    ylim([10^-6 10^0]);
    title('Bit Error Rate vs. Transition probability (p) for LDPC code')
    hold off
    
    
end