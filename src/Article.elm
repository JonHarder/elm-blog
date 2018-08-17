module Article exposing (Article, fetch, header, view)

import Api as Api
import Html exposing (Html, div, h2, hr, li, p, text, ul)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias Id =
    Int


type Header
    = Header String


type Tag
    = Tag String


type Article
    = Article Internals


type alias Internals =
    { userId : Id
    , header : Header
    , tags : List Tag
    , body : String
    }


header : Article -> String
header (Article internals) =
    let
        (Header h) =
            internals.header
    in
    h


decodeTag : Decoder Tag
decodeTag =
    Decode.succeed Tag
        |> required "tagName" Decode.string


decode : Decoder Article
decode =
    Decode.succeed Internals
        |> required "userId" Decode.int
        |> required "header" (Decode.map Header Decode.string)
        |> required "tags" (Decode.list decodeTag)
        |> required "body" Decode.string
        |> Decode.map Article


fetch : Id -> (Result Http.Error Article -> msg) -> Cmd msg
fetch id toMsg =
    let
        articleUrl =
            Api.url ++ "/articles/" ++ String.fromInt id

        req =
            Http.get articleUrl decode
    in
    Http.send toMsg req


viewTag : Tag -> Html msg
viewTag (Tag tagName) =
    li [] [ text tagName ]


viewHeader : Header -> Html msg
viewHeader (Header h) =
    h2 [] [ text h ]


view : Article -> Html msg
view (Article internals) =
    div []
        [ viewHeader internals.header
        , hr [] []
        , div [] [ text "the tags" ]
        , ul [] (List.map viewTag internals.tags)
        , hr [] []
        , p [] [ text internals.body ]
        ]
