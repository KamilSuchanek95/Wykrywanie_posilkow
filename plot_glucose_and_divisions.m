function [nil] = plot_glucose_and_divisions(t, g)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
ylabel('Historic Glucose [mg/dL]');
% rysowanie glukozy
plot(t, g, '-', 'color', [.9 .5 .1]); hold all; grid minor; grid on;
plot(t, g, '--', 'color', [.1 .3 .5]); grid on; % to był cały wykres
% Określenie działki dni, w pętli będzie to powtarzane.
min_max = minmax(g');% wysokość działki (to linia pionowa na wykresie)
dateforday = t(1);% data dla pierwszej działki
day = dateforday.Day;% dzień, kótry potem sprawdzamy, jeśli się zmieni to znak, by kreślić kolejną działkę
dateforday.Hour = 0; dateforday.Minute = 0; % ustawiamy działkę na 00:00
plot([dateforday dateforday], [min_max(1)-5 min_max(2)+5], '-.', 'color', [.5 .1 .7]);% rysowanie

plot([t(1) t(end)], [140 140], 'r-.');
hold on; % to była działka 140 mg/dL
plot([t(1) t(end)], [45 45], 'g-.');
hold on; % to była działka 45 mg/dL

for i = 2:length(g)
    % Oddzielenie na wykresie dni o porach [00:00 (day i-1)]=> [00:00 (day i)]
    if day ~= t(i).Day % jeśli zapamiętany dzień różni się od dnia aktualnej próbki to...
        day = t(i).Day; % ustaw nowy dzień
        dateforday = t(1); % stwórz jakąś datę.
        dateforday.Day = day; % ustaw wymagany dzień dla działki
        dateforday.Hour = 0; % godzinę 
        dateforday.Month = t(i).Month; % upewnij się że miesiąc się zgadza (są rekordy z pograniczy 2 miesięcy)
        dateforday.Minute = 0; % Takie postępowanie zakłada posługiwanie się datami w obrębie 1 roku
        % W przeciwnym razie należałoby wykrywać zmianę roku. Zakładamy ciągłość danych względem dni.
        plot([dateforday dateforday], [min_max(1)-5 min_max(2)+5], '-.', 'color', [.5 .1 .7]);
        hold all;
    end
end

ylim([min(g) max(g)]);
xlim([t(1), t(end)]);

end

