function [meals_time, m_index, glucose_drops_time, g_index] = detect_meals_and_glucose_drops(t, s, g, N, hipo, hiper)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
meals_time = t(1); glucose_drops_time = t(1);
m_index = [];
g_index = [];
% Filtr %med = medfilt1(g, 3*2);%med = movmean(g, 3*1); %med; g(1)= g(1); % dla 1 próbki filtr robi głupie "przeregulowanie", w ten sposób je usuwamy.

% Odległość czekania dla kolejnego odkrycia posiłku
czekanie = N*3; 
czekaj = czekanie; % licznik, dla wartości większej/równej 'czekanie' pozwala odnotować posiłek
% po wykryciu posiłku ustawia czekaj=0 i znów liczy próbki odpowiadające za N*15minut

for i = 2:length(g)
    % Określenie prędkości przyrostu
    delta = s(i) - s(i - 1);
    V = g(i) - g(i - 1);
    V = (V * 60) / delta; % to aktualna prędkość zmian
    
    czekaj = czekaj + 1; % liczenie, +1 czyli +5 minut, istotne po wykryciu posiłku.
    if V > hiper % Oznaczanie posiłków [mg/dL na minutę]
        if czekaj >= czekanie % upłynęło dość czasu od ostatniego wykrycia?
            meals_time(end+1, 1) = t(i);
            m_index(end+1, 1) = i;
            czekaj = 0; % start czekania
        end
    end
    if V < hipo % Oznaczanie spadków
        glucose_drops_time(end+1, 1) = t(i);
        g_index(end+1, 1) = i;
    end
end

meals_time = meals_time(2:end, 1);
glucose_drops_time = glucose_drops_time(2:end, 1);

end

