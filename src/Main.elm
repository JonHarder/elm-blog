module Main exposing (main)

import Article as Article exposing (Article, Date(..), Slug(..))
import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Http as Http
import Json.Encode exposing (Value)
import User as User exposing (User)


type Msg
    = GotUser (Result Http.Error User)
    | GotArticle (Result Http.Error Article)


type Viewer
    = LoggedIn User
    | LoggedOut


type alias Model =
    { viewer : Viewer
    , articles : List Article
    }


initModel : Model
initModel =
    { viewer = LoggedOut
    , articles = []
    }


initCommands =
    Cmd.batch
        [ User.fetch 1 GotUser
        , Article.fetch (Date "08-16-2018") (Slug "first_post") GotArticle
        , Article.fetch (Date "08-17-2018") (Slug "static_files") GotArticle
        ]


init : ( Model, Cmd Msg )
init =
    ( initModel, initCommands )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUser (Ok user) ->
            ( { model | viewer = LoggedIn user }, Cmd.none )

        GotUser (Err _) ->
            ( model, Cmd.none )

        GotArticle (Ok article) ->
            ( { model | articles = article :: model.articles }, Cmd.none )

        GotArticle (Err _) ->
            ( model, Cmd.none )


viewViewer : Viewer -> Html msg
viewViewer viewer =
    case viewer of
        LoggedOut ->
            text "Welcome Guest!"

        LoggedIn user ->
            text <| "Welcome back, " ++ User.toString user


view model =
    div []
        [ div [ class "header" ] [ viewViewer model.viewer ]
        , div [ class "container" ] <|
            List.reverse <|
                List.map Article.view model.articles
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Value Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
