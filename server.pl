:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_cors)).
:- consult('n_puzzle_pashchuk.pl').

:- http_handler('/solvable', handle_solvable, [methods([post, options])]).
:- http_handler('/solve', handle_solve, [methods([post, options])]).

start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

handle_solvable(Request) :-
    http_read_json_dict(Request, Dict),
    Puzzle = Dict.get(puzzle),
    (solvable(Puzzle) -> Response = json{result: true} ; Response = json{result: false}),
    cors_enable(Request, [methods([post, options])]),
    reply_json(Response).
    
handle_solve(Request) :-
    http_read_json_dict(Request, Dict),
    Board = Dict.get(board),
    (solve(Board, Moves) -> Response = json{result: Moves} ; Response = json{error: "Unsolvable"}),
    reply_json(Response).


% Stop the server
stop_server :-
    http_stop_server(8080, []).

:- start_server(8080).
