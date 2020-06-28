% Copyright
/*
Какие продукты входят в блюдо
В каких блюдах используется данный продукт
Калорийность каждого продукта в блюде
Общая калорийность блюда
*/

implement main
    open core, file, stdio

domains
    unit = шт; г; кг; мл; л; чл; стл; щепотка; зб.

class facts - kulinarDb
    магазин : (integer Id, string Название, string Адрес, string Телефон).
    продукт : (integer Id, string Название, unit ЕдиницаИзмерения, real Калорийность).
    блюдо : (integer Id, string Название, string Рецепт).

    состав_блюда : (integer IdБлюда, integer IdПродукта, real Количество).
    продает : (integer Id, real Цена, integer Осталось, integer IdМагазина, integer IdПродукта).
    куплен : (integer Id, real Количество, real ЦенаЗаЕдИзм, integer IdМагазина, integer IdПродукта).

class facts
    s : (real Sum) single.

clauses
    s(0).

class predicates
    состав : (string Название_блюда) nondeterm.
    исп_пр : (string Название_продукта) nondeterm.
    калорийность : (string Название_блюда) nondeterm.
    калор_расш : (string Название_блюда) failure.

clauses

    состав(X) :-
        блюдо(N, X, _),
        write("Состав ", X, ":\n"),
        состав_блюда(N, NPR, _),
        продукт(NPR, NamePr, _, _),
        write("  ", NamePr),
        nl,
        fail.
    состав(X) :-
        блюдо(_, X, _),
        write("Конец списка"),
        nl.

    исп_пр(X) :-
        продукт(Npr, X, _, _),
        write(X, " используется в:\n"),
        состав_блюда(Nbl, Npr, _),
        блюдо(Nbl, NameBl, _),
        write("  ", NameBl),
        nl,
        fail.
    исп_пр(X) :-
        продукт(_, X, _, _),
        write("Конец списка"),
        nl.

    калорийность(X) :-
        блюдо(N, X, _),
        assert(s(0)),
        состав_блюда(N, NPR, Kol),
        продукт(NPR, _, _, Kalor),
        s(Sum),
        asserta(s(Sum + Kol * Kalor)),
        fail.
    калорийность(X) :-
        блюдо(_, X, _),
        s(Sum),
        write("Калорийность ", X, ": ", Sum, " ккал"),
        nl.

    калор_расш(X) :-
        калорийность(X),
        блюдо(N, X, _),
        состав_блюда(N, NPR, Kol),
        продукт(NPR, NamePr, _, Kalor),
        write("  ", NamePr, ": ", Kol * Kalor),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("..\\kul.txt", kulinarDb),
        состав("Тающий картофель"),
        fail.
    run() :-
        исп_пр("Сливочное масло"),
        fail.
    run() :-
        калорийность("Тающий картофель"),
        fail.
    run() :-
        калор_расш("Тающий картофель").
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
