module Components.Sponsors exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, string, list, map3, at)


-- MODEL

type alias Sponsor =
  { name : String
  , website : String
  , logo: String
  }

type alias Model = List Sponsor

-- UPDATE

type Msg
  = NewSponsors (Result Http.Error Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewSponsors (Ok newSponsors) ->
      (Model model newSponsors, Cmd.none)

    NewSponsors (Err _) ->
      (model, Cmd.none)



-- HTTP

getSponsors : Cmd Msg
getSponsors =
  let
    url =
      "http://localhost:8081/api/v1/sponsors"

    request =
      Http.get url decodeSponsors
  in
    Http.send NewSponsors request

decodeSponsors : Decoder Model
decodeSponsors =
  Json.Decode.list (map3 Sponsor
    (at ["name"] string)
    (at ["website"] string)
    (at ["logo"] string)
  )


-- VIEW

sponsorItem : Sponsor -> Html msg
sponsorItem sponsor =
  div [] [
    text ( sponsor.name )
  ]

sponsorGrid : Model -> Html msg
sponsorGrid sponsors =
  div [ class "box" ] (
    List.map sponsorItem sponsors
  )
