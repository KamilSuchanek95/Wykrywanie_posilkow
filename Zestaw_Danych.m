% Surowe dane zajdują się w strukturze raw_data
% pola: datatime, type, historic, scan - wektory kolumnowe
% wczytane z pliku librelink.csv 4 kolumny, 
% pierwsza kolumna datatime MM/dd/yy HH:mm, pozostałe Numeric
clear; clc;
load('raw_data.mat');
%% stworzenie wektorów pozbawionych NaN z osobnymi wektorami czasu.
t = raw_data.datatime;
h = raw_data.historic;
s = raw_data.scan;
type = raw_data.type;

time_h = t(1); h_only = []; s_only = []; time_s = t(1);
for i = 1:length(t)                     % dla każdego elementu czasu h i s
    if i == 1                           % dla 1 iteracji
        if type(i) == 1                 % jeśli to zapis s
            s_only(end + 1, 1) = s(i);  % dodaj s do tablicy z samymi s (bez NaN)
            time_s(end, 1) = t(i);      % dodaj czas do czasów s_only
        elseif type(i, 1) == 0          % jeśli to zapis h
            h_only(end + 1, 1) = h(i);  % dodaj h do tablicy z samymi h (bez NaN)
            time_h(end, 1) = t(i);      % dodaj czas do czasów h_only
        end
    else                                % dla reszty iteracji
        if type(i) == 1
            s_only(end + 1, 1) = s(i);
            time_s(end + 1, 1) = t(i);
        elseif type(i) == 0
            h_only(end + 1, 1) = h(i);
            time_h(end + 1, 1) = t(i);
        end
    end
end
time_h(1) = []; % ucięcie 1 wiersza bo wkradła się tam data z linii nr 11
only.t_h = time_h; only.t_s = time_s; only.h = h_only; only.s = s_only;
clear s_only h_only time_s time_h i t h s type
%% obliczenie periodów i histogramu.
q = only;                           % zmienna tymczasowa
periods_h = []; periods_h(1, 1) = 0;% tylko dla time_h / h_only
for i = 2:length(q.t_h)             % tile ile dat
    periods_h(i, 1) =  seconds(q.t_h(i) - q.t_h(i - 1)); % wynik odejmowania w sekundach
end
q.p_h = periods_h; only = q; % przepisz do struktury
clear q periods_h i % posprzątaj 

%% Jak powinno się pokroić wektor czasu by próbki były możliwie blisko siebie?

godziny =  unique(only.p_h)/(60*60);
minuty = unique(only.p_h)/(60);
porownanie = table(godziny, minuty); clear godziny minuty
% śledząc unikalne odstępy w minutach i godzinach 
% (tak aby te wartości liczbowe coś nam mówiły), najlepiej klikając 2 razy
% w Workspace w zmienną porównanie. 
% największe odstępy zaczynają się od ok. 2h oraz następny wiekszy ok. 10h
% więc za period dzielący wektor główny na mniejsze uznamy każdy większy od
% 3 godzin.

%% Podział wektora historic (h) na wektory poddawane dalszej analizie.
% wektor scan nie będzie brany pod uwagę.
q = only;
data = [];
datatime = q.t_h(1, 1); % inicjacja tablicy o typie datetime
row = 1; col = 1;
for i = 1:length(q.t_h) % dla każdego elementu...
    if(q.p_h(i)>60*60*3) % jeśli period jest dłuższy niż 3h to zacznij od nowej kolumny
        row = 1; % od 1 wiersza ponownie
        col = col + 1; % nowa kolumna
    end
    data(row, col) = q.h(i);        % zapis kolumny wartości 
    datatime(row, col) = q.t_h(i);  % zapis kolumny dat
    row = 1 + row; % kolejny wiersz
end
q.data = data; q.datatime = datatime;
only = q; clear q datatime data row col i;
% data oraz datatime to teraz wektory kolumnowe danych glukozy i czasu (w strukturze only)
%% obliczanie wektorów sekund
q = only;    sek = [];
for j = 1:size(q.datatime, 2)           % dla każdej kolumny danych
    m = q.datatime(:, j);               % zapisz kolumnę dat
    for i = 2:length(m(~isnat(m)))      % dla każdego wiersza dat, który nie jest NaT
        sek(i, j) = seconds(m(i)-m(1)); % oblicz ilość sekund względem 1 daty
    end
end
q.seconds = sek;            % otwórz nowe pole dla sekund
only = q; clear q sek j m i % rzutuj tymczasową strukturę do stałej i wyczyść śmieci

%% Interpolacja
q = only;
for col = 1:size(q.datatime, 2) % pętla dla każdej kolumny
    
    % Przygotowanie startu i stopu interpolacji
        % zaokrąglanie minut w dół do godziny podzielnej przez 5 minut
    start_minute = q.datatime(1, col).Minute; % minuty 1-szej daty
    if (start_minute - 5*ceil(start_minute/5)) == 0 % podzielna przez 5?
    else % niepodzielne...
        start_minute = start_minute - ((start_minute - 5*ceil(start_minute/5)) + 5);
        % zaokrąglenie w dół np 34 minut => 30 minut, 41 minut => 40 minut
    end
    start = q.datatime(1, col); start.Minute = start_minute; % korekcja obliczonych minut
        % zaokrąglenie minut w górę do godziny podzielnej przez 5 minut
    m = q.datatime(:, col); % to samo wszystko tylko zaokrąglenie w dół...
    limit = length(m(~isnat(m))); % ostatni element będący datą a nie NaT nas interesuje
    stop_minute = q.datatime(limit, col).Minute;
    if (stop_minute - 5*ceil(stop_minute/5)) == 0
    else
        stop_minute = stop_minute + ((5*ceil(stop_minute/5) - stop_minute));
    end
    stop = q.datatime(limit, col); stop.Minute = stop_minute;
    % koniec ustalania startu i końca przedziału interpolacji
    interp_x = 0:5*60:seconds(stop-start); % wektor sekund w których chcemy interpolować
    interp_x = interp_x'; % chcemy wektor wierszowany (kolumnę)
    % interpolacja niżej... dla takich sekund i dakich danych iterpoluj...
    % w takim przedziale...
    interp_y = interp1(q.seconds(1:limit, col), q.data(1:limit, col), interp_x);
    % znów zamiast ":" to "1:limit" bo nie chcemy pracować na 0 i NaT.
    
    interp_datetime = q.datatime(1, 1); % uzupełnienie wektora czasu w postaci datetime
    for i = 1:length(interp_x)
        date_tmp = start; % tutaj tworzymy obiekt datetime oraz dodajemy mu
        % sekund, w ten sposób data sama się uzupełnia do pożądanej
        % względem startowej.
        date_tmp.Second = date_tmp.Second + interp_x(i);
        
    % trzeba to wsadzić ręcznie iterując bo matlab nie ogarnia konkatenacji
    % tablic o różnych rozmiarach....................
    
        q.interpolated_datatime(i, col) = date_tmp; % zapis daty
        q.interpolated_data(i, col) = interp_y(i, 1); % zapis danych 
        q.interpolated_seconds(i, col) = interp_x(i, 1); % zapis sekund
    end
end
only = q; % przepisanie z powodzeniem uzupełnionej struktury i czyszczenie
clear start stop col interp_x limit stop_minute m start_minute ... 
      q i date_tmp interp_y interp_datatime
%%

% plot(only.interpolated_datatime(), only.interpolated_data)
% tablice muszą być "kwadratowe" więc uzupełnia sobie tam dla kolumn
% numerycznych zera na ostatich pozycjach oraz NaT w tablicy datetime
% NaT to coś jak NaN dla liczb. 

% przy przetwarzaniu należy pamiętać o 0 oraz NaT na końcach kolumn.
% tablica(~isnat(tablica)) dla datatime i uciąć te ostatnie.
% albo zastosować find(tablica~=NaT) zwróci indeksy tablicy nie
% zawierających NaT.
