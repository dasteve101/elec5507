function [decoded_data, error_locations] = berlekamp_decode(data_to_decode)
% http://www.mathworks.com.au/help/comm/ug/error-detection-and-correction.html
% http://www.mathworks.com/matlabcentral/fileexchange/9339-bch-and-reed-solomon-decoder-simulation/content/bch.m

% Parameters of n = 31, k = 16, t = 3 BCH
n = 31;
t = 3;
k = 16;
m = 5; % 2^5 = 32

% GF field vars
zero = gf(0, m);
one = gf(1, m);
alpha = gf(2, m);

codeword = gf(data_to_decode, m);

% compute the syndromes
S = gf(zeros(1,2*t), m);
for index = 1:2*t
    S(index) = codeword*(alpha.^(index.*(31:0)));
end

% Based on textbook
% discrepency_mu = one;
% discrepency_rho = one;
% rho = -1;
% sigma = gf([1 zeros(1,2*t)], m); % error location polynomial
% sigma_rho = sigma;
% l_mu = -1; % degree of sigma (-1 for first discrepency)
% l_rho = 0;
% 
% start berlekamp
% STEP 1 - UPDATE simga(mu + 1)
% STEP 2 - UPDATE l_mu
% STEP 3 - UPDATE rho on previous discrepency
% STEP 4 - UPDATE discrepency
% for mu = 0:(2*t)
%     % update to remove discrepency
%     if (discrepency_mu ~= zero)
%         % compute the next sigma(mu+1)
%         sigma_next = sigma - (discrepency_mu/discrepency_rho)*[gf(zeros(1,(mu-1)-rho), m) sigma_rho];
%         l_mu = l_mu + 1; % degree has increased as there was a discrepency
%         % determine rho
%         if (rho - l_rho) < (mu - l_mu)
%             rho = mu;
%             l_rho = l_mu;
%             sigma_rho = sigma;
%             discrepency_rho = discrepency_mu;
%         end
%         sigma = sigma_next;
%         if l_mu == t
%             break % degree of t so break
%         end
%     end
%     % calculate the discrepency
%     discrepency_mu = sum(fliplr(S((mu - l_mu + 1):(mu + 1))).*sigma(1:(l_mu + 1)));
% end

% Based on the matlab algorithm 1st link (similar but different names)
L = 0;
k = -1;
sigma = [one gf(zeros(1,(2*t - 1)), m)];
D = [zero one gf(zeros(1,(2*t - 2)), m)];

for n = 0:(2*t - 1)
    discrepency = sum(fliplr(S((n-L + 1):(n + 1))).*sigma(1:(L + 1)));
    if discrepency ~= 0
        sigma_star = sigma - discrepency*D;
        if L < n - k
            L_star = n - k;
            k = n - L;
            D = sigma/discrepency;
            L = L_star;
        end
        sigma = sigma_star;
    end
    D = [zero D(1:(end-1))];
end


% Find roots of sigma
rootsOfSigma = [];
rootToTry = alpha.^(index.*(31:0));
for index = 1:length(rootToTry)
    % if sum is zero then is root
    if sum(sigma.*(rootToTry(index).^(0:(length(sigma) - 1)))) == 0
        rootsOfSigma = [rootsOfSigma index];
    end
end

locations = n - rootsOfSigma; % inverse - but this won't work
error_locations = zeros(1,length(data_to_decode));
error_locations(locations) = ones(1,length(locations));
decoded_data = mod(data_to_decode + error_locations,2);