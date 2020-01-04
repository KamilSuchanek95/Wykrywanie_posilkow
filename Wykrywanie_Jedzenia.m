% Wizualizacja danych glukozy i wykrywanie posiłków
 close all; clear;
% Załadowanie danych 
load('only.mat');load('Activity_for_plot.mat'); 
% dane załadowane ręcznie podobnie jak librelink.csv, nie wymagały obróbki.
% strukturę only można uzyskać uruchamiając skrypt Zestaw_Danych.m
% pola do modyfikacji, "progi" detekcji oraz wybór rekordu
N = 1 + 2/3;% 1 próbka to 5 minut, ale oryginał to 15 minut około więc przynajmniej N*3 np.: N=2 to czekanie 30min
hiper = .7;  % if V > hiper them...
hipo = -0.95; % if V < hipo them...
column = 3;% 16 kolumn, 1 kolumna to 1 rekordć 
% Uzyskanie wektorów bez wartości NaN oraz NaT
[t, s, g] = return_values_without_NaN_and_NaT(only, column);
% Aby odciążyć wyświetlanie określonych wykresów należy pozbyć się znaczników, które nie dotyczą wybranego 
% przedziału czasu t(1=>end) + flagi posiłków zapychają szare pola obok
% wykresów... tak być nie powinno.
[spanie, treningi, jedzenie, czas_jedzenia] = return_necessary_tags(A, t);
% Plot posiłków i okresów snu oraz treningu.
plot_tags(spanie, treningi, jedzenie, czas_jedzenia);
% Plot glukozy i działek
plot_glucose_and_divisions(t, g);
% Wykrywanie posiłków
[meals_time, m_i, glucose_drops_time, g_i] = detect_meals_and_glucose_drops(t, s, g, N, hipo, hiper);
% Plot wykrytych punktów
plot_detected_points(g, meals_time, m_i, glucose_drops_time, g_i);

% Analiza wyników algorytmu - nieaktualne, zastąpione przez statystyki_zbiorcze.m

%  Jak ocenić trafność wykrywania posiłków?
    % Jeśli w okresie +-15 minut od wykrycia posiłku (meals_time) nie
    % znajduje się posiłek to mamy wynik FP, 
    % Jeśli jednak się tam znajduje to mamy wynik TP.
% 0;
% 
% % okolica
% plus_minus = 30; % [min]
% 
% [czy, fa] = czy_trafnie_wykrylo_posilek(czas_jedzenia, meals_time, plus_minus);
% 
% tp = length(find(czy))/length(czy); 
% fp = 1-tp; 
% fn = length(find(fa))/length(fa);
% 
% FP_str =  sprintf('Fałszywe wykrycie posiłku %.4f%%', fp*100);
% TP_str = sprintf('Poprawne wykrycie posiłku %.4f%%', tp*100);
% FN_str = sprintf('Pominięte posiłki %.4f%%', fn*100);
% 
% czulosc = (100*tp)/(tp+fn); % [%]
% precyzja = (100*tp)/(tp+fp);
% wskaznik_bledu = ((fn+fp)*100)/length(jedzenie);
% stosunek_wykrytych_do_znanych = length(meals_time)/length(jedzenie);
% 
% fprintf('==============================================\n')
% 
% fprintf('Czekanie: %.0fminut, hiper: %.2f\n', N*3, hiper)
% fprintf('__\n')
% fprintf('%s\n%s\n%s\n', FP_str, TP_str, FN_str)
% fprintf('Liczba wykrytych punktów: %.0f\nLiczba otagowanych posiłków: %.0f\n', length(meals_time), length(jedzenie))
% fprintf('Czułość = %.3f, Precyzja = %.3f, Wskaźnik błędu wykrywania = %.3f\n',...
%     czulosc, precyzja, wskaznik_bledu)
% fprintf('Stosunek wykrytych do otagowanych: %.3f\n', stosunek_wykrytych_do_znanych)
% fprintf('==============================================\n')
% 











