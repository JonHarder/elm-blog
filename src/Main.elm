module Main exposing (main)

import Url exposing (Url)
import Article as Article exposing (Article, Date(..), Slug(..))
import Browser exposing (Document)
import Browser.Navigation as Navigation
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Http as Http
import Json.Encode exposing (Value)
import User as User exposing (User)


type Msg
    = GotUser (Result Http.Error User)
    | GotArticle (Result Http.Error Article)
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest


type Viewer
    = LoggedIn User
    | LoggedOut


type alias Model =
    { url : Url
    , viewer : Viewer
    , articles : List Article
    }


initModel : Url -> Model
initModel url =
    { url = url
    , viewer = LoggedOut
    , articles = []
    }


initCommands =
    Cmd.batch
        [ User.fetch 1 GotUser
        , Article.fetch (Date "08-16-2018") (Slug "first_post") GotArticle
        , Article.fetch (Date "08-17-2018") (Slug "static_files") GotArticle
        ]


init : Value -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initModel url, initCommands )


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

        UrlChanged url ->
            ( model, Cmd.none )

        UrlRequested req ->
            ( model, Cmd.none )


viewViewer : Viewer -> Html msg
viewViewer viewer =
    case viewer of
        LoggedOut ->
            text "Welcome Guest!"

        LoggedIn user ->
            text <| "Welcome back, " ++ User.toString user


view : Model -> Document Msg
view model =
    { title = "Elm Blog"
    , body =
        [ div []
            [ div [ class "header" ] [ viewViewer model.viewer ]
            , text <| Url.toString model.url
            , div [ class "container" ] <|
                List.reverse <|
                    List.map Article.view model.articles
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }
