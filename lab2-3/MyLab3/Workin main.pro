% Copyright
/*
Какие Фильмы показывает определенный кинотеатр
Какие у фильма жанры
В каком кинотеатре и какие фильмы сейчас в прокате определенного жанра
Сколько фильмов определенного режиссера в топе
*/

implement main
    open core, file, stdio

domains
    genres =
        crime; drama; action; thriller; biography; history; adventure; fantasy; western; romance; sci_fi; mystery; comedy; war; family; animation;
        musical; music; horror; film_noir; sport.
    cinema_film = cinema_film(string Cinema, string Film).

class facts - kinoDB
    genre : (integer GenreId, genres Genre).
    cinema : (integer Id, string Name, string Adress, string Telephone, real Latitude, real Longitude).
    film : (integer Id, string Name, string Released, string Director).
    filmGenre : (integer FilmId, integer GenreId).
    showing : (integer CinemaId, integer FilmId, string Date, string Time).

class predicates  %Вспомогательные предикаты
    len : (A*) -> integer N.
    listSum : (real* List) -> real Sum.
    listAverage : (real* List) -> real Average determ.

clauses
    len([]) = 0.
    len([_ | T]) = len(T) + 1.

    listSum([]) = 0.
    listSum([H | T]) = listSum(T) + H.

    listAverage(L) = listSum(L) / len(L) :-
        len(L) > 0.

class predicates
    filmInCinema : (string CinemaName) -> string* Films determ.
    getGenres : (string CinemaName) -> genres* G determ.
    getStreamByGenre : (genres X) -> cinema_film* Cifi determ.
    numFilmsByDirector : (string Director) -> string* Names.

clauses
    filmInCinema(X) = List :-
        cinema(Cid, X, _, _, _, _),
        !,
        List =
            [ Name ||
                showing(Cid, Fid, _, _),
                film(Fid, Name, _, _)
            ].

    getGenres(X) = List :-
        film(Cid, X, _, _),
        !,
        List =
            [ Name ||
                filmGenre(Cid, Gen),
                genre(Gen, Name)
            ].

    getStreamByGenre(X) = List :-
        write("Фильмы жанра ", X, " идут в кинотеатрах:\n"),
        genre(Id, X),
        !,
        List =
            [ cinema_film(Cname, Fname) ||
                showing(Cid, Fid, _, _),
                cinema(Cid, Cname, _, _, _, _),
                filmGenre(Fid, Id),
                film(Fid, Fname, _, _)
            ].

    numFilmsByDirector(X) = [ Name || film(_, Name, _, X) ].
        %write("\nКоличество фильмов режиссера ", X),

class predicates  %Вывод на экран
    beautifyOutputStr : (string* Str).
    beautifyCiFi : (cinema_film* Cifi).
    beautifyGenre : (genres* Gen).

clauses
    beautifyOutputStr(L) :-
        foreach Elem = list::getMember_nd(L) and Idx = list::tryGetIndex(Elem, L) do
            write("\t", Idx + 1, ". ", Elem),
            nl
        end foreach.

    beautifyCiFi(L) :-
        foreach cinema_film(Cname, Fname) = list::getMember_nd(L) do
            writef("\t% <---> %\n", Cname, Fname)
        end foreach.

    beautifyGenre(L) :-
        foreach Elem = list::getMember_nd(L) do
            write("\t", Elem),
            nl
        end foreach.

clauses
    run() :-
        console::init(),
        reconsult("..\\selection.txt", kinoDB),
        X = "Иллюзион",
        L = filmInCinema(X),
        write("Фильмы в ", X, ":\n"),
        beautifyOutputStr(L),
        nl,
        nl,
        fail.

    run() :-
        X = "The Dark Knight",
        L = getGenres("The Dark Knight"),
        write("Жанры ", X, ":\n"),
        beautifyGenre(L),
        nl,
        nl,
        fail.
    run() :-
        X = thriller,
        L = getStreamByGenre(X),
        beautifyCiFi(L),
        write(len(L), " фильмов жанра ", X, " сейчас в кино."),
        nl,
        nl,
        fail.

    run() :-
        X = "Christopher Nolan",
        L = numFilmsByDirector(X),
        write("Всего фильмов режиссера ", X, " = ", len(L), ". Их названия: \n"),
        beautifyOutputStr(L),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
