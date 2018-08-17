module User exposing (User, fetch, toString)

import Api as Api
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type alias FirstName =
    String


type alias LastName =
    String


type alias Id =
    Int


type User
    = User Id FirstName LastName


toString : User -> String
toString (User id fn ln) =
    fn


fetch : Id -> (Result Http.Error User -> msg) -> Cmd msg
fetch id toMsg =
    let
        userUrl =
            Api.url ++ "/users/" ++ String.fromInt id

        req =
            Http.get userUrl decode
    in
    Http.send toMsg req


decode : Decoder User
decode =
    Decode.succeed User
        |> required "id" Decode.int
        |> required "firstName" Decode.string
        |> required "lastName" Decode.string
