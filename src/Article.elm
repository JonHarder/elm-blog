module Article exposing (Article, Date(..), Slug(..), fetch, header, view)

import Api as Api
import Html exposing (Html, div, h2, hr, li, p, span, text, ul)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Markdown as Markdown


type alias Id =
    Int


type Header
    = Header String


type Tag
    = Tag String


type Article
    = Article Internals


type alias Internals =
    { header : Header
    , tags : List Tag
    , body : String
    , date : String
    }


header : Article -> String
header (Article internals) =
    let
        (Header h) =
            internals.header
    in
    h


decode : String -> Decoder Article
decode date =
    Decode.succeed Internals
        |> required "header" (Decode.map Header Decode.string)
        |> required "tags" (Decode.list (Decode.map Tag Decode.string))
        |> required "body" Decode.string
        |> hardcoded date
        |> Decode.map Article


type Date
    = Date String


type Slug
    = Slug String


fetch : Date -> Slug -> (Result Http.Error Article -> msg) -> Cmd msg
fetch (Date dateStr) (Slug slug) toMsg =
    let
        articleUrl =
            Api.url ++ "/articles/" ++ dateStr ++ "/" ++ slug

        req =
            Http.get articleUrl (decode dateStr)
    in
    Http.send toMsg req


viewTag : Tag -> Html msg
viewTag (Tag tagName) =
    span [ class "tag" ]
        [ text tagName
        , text " "
        ]


viewHeader : Header -> String -> List Tag -> Html msg
viewHeader (Header h) date tags =
    div []
        [ h2 [] [ text h ]
        , div []
            [ p [] [ text date ]
            , div [] <|
                List.map viewTag tags
            ]
        ]


view : Article -> Html msg
view (Article internals) =
    div [ class "article" ]
        [ viewHeader internals.header internals.date internals.tags
        , hr [] []
        , Markdown.toHtml [] internals.body
        ]
