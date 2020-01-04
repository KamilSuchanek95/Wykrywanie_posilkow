% Wizualizacja danych glukozy i wykrywanie posiłków
 close all; clear;
% Załadowanie danych 
load('only.mat');load('Activity_for_plot.mat'); 
% dane załadowane ręcznie podobnie jak librelink.csv, nie wymagały obróbki.
% strukturę only można uzyskać uruchamiając skrypt Zestaw_Danych.m
% pola do modyfikacji, "progi" detekcji oraz wybór rekordu
N = 1 + 2/3;% 1 próbka to 5 minut, ale oryginał to 15 minut około więc przynajmniej N*3 np.: N=2 to czekanie 30min
hiper = .9;  % if V > hiper them...
hipo = -0.95; % if V < hipo them...
column = 3;% 16 kolumn, 1 kolumna to 1 rekord
param_detected = {}; param_foods = []; param_food_times = {};
for q = 1:16 % pętla po każdym zbiorze danych.
    % Uzyskanie wektorów bez wartości NaN oraz NaT
    [t, s, g] = return_values_without_NaN_and_NaT(only, q);
    [spanie, treningi, jedzenie, czas_jedzenia] = return_necessary_tags(A, t);
    % Wykrywanie posiłków
    [meals_time, m_i, glucose_drops_time, g_i] = detect_meals_and_glucose_drops(t, s, g, N, hipo, hiper);
    param_detected = [param_detected ; meals_time];
    param_foods = [param_foods; jedzenie];
    param_food_times = [param_food_times; czas_jedzenia];
end

plus_minus = 45; % [min]
[czy, fa, lf, ld] = czy_trafnie_wykrylo_posilek(param_food_times, param_detected, plus_minus);
% produkty funkcji zostały opisane w jej wnętrzu.

tp = length(find(czy))/length(czy); fp = 1-tp; 
fn = length(find(fa))/length(fa);
czulosc = (100*tp)/(tp+fn); % [%]
precyzja = (100*tp)/(tp+fp);
wskaznik_bledu = ((fn+fp)*100)/lf;
stosunek_wykrytych_do_znanych = ld/lf;

FP_str =  sprintf('Fałszywe wykrycie posiłku %.4f%%', fp*100);
TP_str = sprintf('Poprawne wykrycie posiłku %.4f%%', tp*100);
FN_str = sprintf('Pominięte posiłki %.4f%%', fn*100);
fprintf('==============================================\n')
fprintf('Czekanie: %.0fminut, hiper: %.2f\n', N*3, hiper)
fprintf('__\n')
fprintf('%s\n%s\n%s\n', FP_str, TP_str, FN_str)
fprintf('Liczba wykrytych punktów: %.0f\nLiczba otagowanych posiłków: %.0f\n', ld, lf)
fprintf('Czułość = %.3f, Precyzja = %.3f, Wskaźnik błędu wykrywania = %.3f\n',...
    czulosc, precyzja, wskaznik_bledu)
fprintf('Stosunek wykrytych do otagowanych: %.3f\n', stosunek_wykrytych_do_znanych)
fprintf('==============================================\n')

% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 55.0000%
% Poprawne wykrycie posiłku 45.0000%
% Pominięte posiłki 43.0508%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 51.107, Precyzja = 45.000, Wskaźnik błędu wykrywania = 0.166
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.90
% __
% Fałszywe wykrycie posiłku 52.7559%
% Poprawne wykrycie posiłku 47.2441%
% Pominięte posiłki 56.1017%
% Liczba wykrytych punktów: 635
% Liczba otagowanych posiłków: 590
% Czułość = 45.715, Precyzja = 47.244, Wskaźnik błędu wykrywania = 0.185
% Stosunek wykrytych do otagowanych: 1.076
% ==============================================
% all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.80
% __
% Fałszywe wykrycie posiłku 53.9726%
% Poprawne wykrycie posiłku 46.0274%
% Pominięte posiłki 51.6949%
% Liczba wykrytych punktów: 730
% Liczba otagowanych posiłków: 590
% Czułość = 47.100, Precyzja = 46.027, Wskaźnik błędu wykrywania = 0.179
% Stosunek wykrytych do otagowanych: 1.237
% 
% 
% ==============================================
% Czekanie: 5minut, hiper: 0.80
% __
% Fałszywe wykrycie posiłku 53.9726%
% Poprawne wykrycie posiłku 46.0274%
% Pominięte posiłki 51.6949%
% Liczba wykrytych punktów: 730
% Liczba otagowanych posiłków: 590
% Czułość = 47.100, Precyzja = 46.027, Wskaźnik błędu wykrywania = 0.179
% Stosunek wykrytych do otagowanych: 1.237
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.80
% __
% Fałszywe wykrycie posiłku 60.9589%
% Poprawne wykrycie posiłku 39.0411%
% Pominięte posiłki 51.6949%
% Liczba wykrytych punktów: 730
% Liczba otagowanych posiłków: 590
% Czułość = 43.027, Precyzja = 39.041, Wskaźnik błędu wykrywania = 0.191
% Stosunek wykrytych do otagowanych: 1.237
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 72.5556%
% Poprawne wykrycie posiłku 27.4444%
% Pominięte posiłki 54.0678%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 33.669, Precyzja = 27.444, Wskaźnik błędu wykrywania = 0.215
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.95
% __
% Fałszywe wykrycie posiłku 69.8214%
% Poprawne wykrycie posiłku 30.1786%
% Pominięte posiłki 68.6441%
% Liczba wykrytych punktów: 560
% Liczba otagowanych posiłków: 590
% Czułość = 30.538, Precyzja = 30.179, Wskaźnik błędu wykrywania = 0.235
% Stosunek wykrytych do otagowanych: 0.949
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.95
% __
% Fałszywe wykrycie posiłku 51.2500%
% Poprawne wykrycie posiłku 48.7500%
% Pominięte posiłki 59.3220%
% Liczba wykrytych punktów: 560
% Liczba otagowanych posiłków: 590
% Czułość = 45.109, Precyzja = 48.750, Wskaźnik błędu wykrywania = 0.187
% Stosunek wykrytych do otagowanych: 0.949
% ==============================================

% ==============================================
% Czekanie: 5minut, hiper: 0.90
% __
% Fałszywe wykrycie posiłku 57.0079%
% Poprawne wykrycie posiłku 42.9921%
% Pominięte posiłki 56.1017%
% Liczba wykrytych punktów: 635
% Liczba otagowanych posiłków: 590
% Czułość = 43.385, Precyzja = 42.992, Wskaźnik błędu wykrywania = 0.192
% Stosunek wykrytych do otagowanych: 1.076
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.60
% __
% Fałszywe wykrycie posiłku 61.6181%
% Poprawne wykrycie posiłku 38.3819%
% Pominięte posiłki 37.6271%
% Liczba wykrytych punktów: 1063
% Liczba otagowanych posiłków: 590
% Czułość = 50.497, Precyzja = 38.382, Wskaźnik błędu wykrywania = 0.168
% Stosunek wykrytych do otagowanych: 1.802
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 60.0000%
% Poprawne wykrycie posiłku 40.0000%
% Pominięte posiłki 43.0508%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 48.163, Precyzja = 40.000, Wskaźnik błędu wykrywania = 0.175
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 55.0000%
% Poprawne wykrycie posiłku 45.0000%
% Pominięte posiłki 43.0508%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 51.107, Precyzja = 45.000, Wskaźnik błędu wykrywania = 0.166
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% >> all_1
% 45
% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 41.4444%
% Poprawne wykrycie posiłku 58.5556%
% Pominięte posiłki 33.3898%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 63.685, Precyzja = 58.556, Wskaźnik błędu wykrywania = 0.127
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% 
% ans =
% 
%     45
% 
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.80
% __
% Fałszywe wykrycie posiłku 40.1370%
% Poprawne wykrycie posiłku 59.8630%
% Pominięte posiłki 41.3559%
% Liczba wykrytych punktów: 730
% Liczba otagowanych posiłków: 590
% Czułość = 59.142, Precyzja = 59.863, Wskaźnik błędu wykrywania = 0.138
% Stosunek wykrytych do otagowanych: 1.237
% ==============================================
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.90
% __
% Fałszywe wykrycie posiłku 38.2677%
% Poprawne wykrycie posiłku 61.7323%
% Pominięte posiłki 46.1017%
% Liczba wykrytych punktów: 635
% Liczba otagowanych posiłków: 590
% Czułość = 57.248, Precyzja = 61.732, Wskaźnik błędu wykrywania = 0.143
% Stosunek wykrytych do otagowanych: 1.076
% ==============================================
% >> -5
% 
% ans =
% 
%     -5
% 
% >> all_1
% ==============================================
% Czekanie: 5minut, hiper: 0.90
% __
% Fałszywe wykrycie posiłku 43.3071%
% Poprawne wykrycie posiłku 56.6929%
% Pominięte posiłki 46.1017%
% Liczba wykrytych punktów: 635
% Liczba otagowanych posiłków: 590
% Czułość = 55.152, Precyzja = 56.693, Wskaźnik błędu wykrywania = 0.152
% Stosunek wykrytych do otagowanych: 1.076
% ==============================================
% ...
%     ==============================================
% Czekanie: 5minut, hiper: 0.90
% __
% Fałszywe wykrycie posiłku 34.8837%
% Poprawne wykrycie posiłku 65.1163%
% Pominięte posiłki 46.1017%
% Liczba wykrytych punktów: 635
% Liczba otagowanych posiłków: 590
% Czułość = 58.548, Precyzja = 65.116, Wskaźnik błędu wykrywania = 0.137
% Stosunek wykrytych do otagowanych: 1.076
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.80
% __
% Fałszywe wykrycie posiłku 36.7583%
% Poprawne wykrycie posiłku 63.2417%
% Pominięte posiłki 41.3559%
% Liczba wykrytych punktów: 730
% Liczba otagowanych posiłków: 590
% Czułość = 60.462, Precyzja = 63.242, Wskaźnik błędu wykrywania = 0.132
% Stosunek wykrytych do otagowanych: 1.237
% ==============================================
% kiedy_zjadlooo
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.70
% __
% Fałszywe wykrycie posiłku 38.0729%
% Poprawne wykrycie posiłku 61.9271%
% Pominięte posiłki 33.3898%
% Liczba wykrytych punktów: 900
% Liczba otagowanych posiłków: 590
% Czułość = 64.970, Precyzja = 61.927, Wskaźnik błędu wykrywania = 0.121
% Stosunek wykrytych do otagowanych: 1.525
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.60
% __
% Fałszywe wykrycie posiłku 40.3596%
% Poprawne wykrycie posiłku 59.6404%
% Pominięte posiłki 27.2881%
% Liczba wykrytych punktów: 1063
% Liczba otagowanych posiłków: 590
% Czułość = 68.609, Precyzja = 59.640, Wskaźnik błędu wykrywania = 0.115
% Stosunek wykrytych do otagowanych: 1.802
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.50
% __
% Fałszywe wykrycie posiłku 45.3560%
% Poprawne wykrycie posiłku 54.6440%
% Pominięte posiłki 21.5254%
% Liczba wykrytych punktów: 1369
% Liczba otagowanych posiłków: 590
% Czułość = 71.740, Precyzja = 54.644, Wskaźnik błędu wykrywania = 0.113
% Stosunek wykrytych do otagowanych: 2.320
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.40
% __
% Fałszywe wykrycie posiłku 48.0635%
% Poprawne wykrycie posiłku 51.9365%
% Pominięte posiłki 13.3898%
% Liczba wykrytych punktów: 1663
% Liczba otagowanych posiłków: 590
% Czułość = 79.503, Precyzja = 51.937, Wskaźnik błędu wykrywania = 0.104
% Stosunek wykrytych do otagowanych: 2.819
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.30
% __
% Fałszywe wykrycie posiłku 52.7833%
% Poprawne wykrycie posiłku 47.2167%
% Pominięte posiłki 8.4746%
% Liczba wykrytych punktów: 2130
% Liczba otagowanych posiłków: 590
% Czułość = 84.783, Precyzja = 47.217, Wskaźnik błędu wykrywania = 0.104
% Stosunek wykrytych do otagowanych: 3.610
% ==============================================
% statystyki_zbiorcze
% ==============================================
% Czekanie: 5minut, hiper: 0.20
% __
% Fałszywe wykrycie posiłku 56.6879%
% Poprawne wykrycie posiłku 43.3121%
% Pominięte posiłki 4.4068%
% Liczba wykrytych punktów: 2661
% Liczba otagowanych posiłków: 590
% Czułość = 90.765, Precyzja = 43.312, Wskaźnik błędu wykrywania = 0.104
% Stosunek wykrytych do otagowanych: 4.510
% ==============================================

