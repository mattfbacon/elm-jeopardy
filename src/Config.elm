module Config exposing (..)

import Array as A exposing (Array)


name : String
name =
    "Branham Programming Club"


headers : Array String
headers =
    A.fromList
        [ "People"
        , "Networking"
        , "Languages"
        , "Syntax"
        , "Jargon"
        ]


type alias Item =
    { question : String
    , answer : String
    , dailyDouble : Bool
    }


items : Array (Array Item)
items =
    A.fromList <|
        List.map A.fromList <|
            [ [ Item "The child of a famous poet and English mathematician whom many historians consider the first programmer" "Who is Ada Lovelace?" False
              , Item "The more safe version of HTTP" "What is HTTPS?" False
              , Item "The programming language of the web" "What is JavaScript?" True
              , Item "A program statement that branches program execution based on some conditional (whether something is true)" "What is an if statement?" False
              , Item "Database" "What is a place where you storage and manage data?" False
              ]
            , [ Item "A computer scientist reponsible for decoding the encryption of German Enigma machines during the second world war" "Who is Alan Turing?" False
              , Item "A unique address that identifies a device on the internet or a local network" "What is an IP Address?" False
              , Item "An early language whose name shares its first 4 letters with \"FORTNITE\"" "What is FORTRAN?" False
              , Item "A way to store code to be reused later" "What is a function?" False
              , Item "PNG (initialism)" "What is Portable Network Graphics?" False
              ]
            , [ Item "One of the creators of the C programming language" "Who is Dennis Ritchie/Ken Thompson?" False
              , Item "The most common transport protocol on the Internet, which ensures proper transmission" "What is TCP?" False
              , Item "A programming language considered to be the successor of C" "What is C++?" False
              , Item "A type of loop that always executes at least once" "What is a do-while loop?" False
              , Item "KISS (acronym)" "What is \"Keep it simple, stupid\"?" False
              ]
            , [ Item "The creator of the Linux kernel" "Who is Linus Torvalds?" False
              , Item "A protocol used for mail transfer. Acronym. Starts with \"simple\"." "What is SMTP?" False
              , Item "The programming language that Linux is written in" "What is C?" False
              , Item "A symbol commonly seen at the end of programming statements." "What is a semicolon?" False
              , Item "Spaghetti Code" "What do you call code that is obviously badly written?" False
              ]
            , [ Item "A US Navy admiral and one of the most well-known programmers" "Who is Grace Hopper?" False
              , Item "Sections of a network, usually given slightly different internal IPs" "What are subnets?" False
              , Item "One example of a purely functional programming language" "What is Elm, Haskell?" False
              , Item "Generating an infinite amount of data" "What is Trying to exit Vim?" True
              , Item "RTFM (initialism)" "What is \"Read the fine manual\"?" False
              ]
            ]


rows : Int
rows =
    A.length items


cols : Int
cols =
    A.length headers
