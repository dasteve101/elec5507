% Plots coded and uncoded Eb/No given transition probabilities
% and the code rate. Formulas given in project notes
function plot_ebno(transition_prob, bers, uncoded_bers, code_rate)
    
    % Replace zero's with episolon for plot-friendliness
    bers(bers==0) = 10e-10;
    uncoded_bers(uncoded_bers==0) = 10e-10;
    
    % Determine Eb/No for coded/uncoded
    ebno_coded =  10*log10 (  (qfuncinv(transition_prob).^2) / (code_rate));
    ebno = 20*log10(qfuncinv(transition_prob));
    
    % Plot Eb/No vs for coded/uncoded
    figure
    semilogy(ebno_coded(2:end-1), bers(2:end-1), 'g');
    hold on
    semilogy(ebno(2:end-1), uncoded_bers(2:end-1));
    legend('Coded BSC', 'Uncoded BSC');
    xlabel('Eb/No (dB)');
    ylabel('Bit Error Rate') 
    xlim([0 10])
    ylim([10^-6 10^0]);
    title('Bit Error Rate vs. Eb/No (dB) for LDPC code');
    hold off
    
end