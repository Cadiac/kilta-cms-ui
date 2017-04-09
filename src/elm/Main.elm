module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import Http
import Json.Decode exposing (Decoder, string, list, map3, at)

-- component import example
import Components.Hello exposing ( hello, helloBox )
import Components.Navbar exposing ( navbar )
import Components.Sponsors exposing ( sponsorGrid, Sponsor )

type alias Flags =
  { apiUrl: String }

-- APP


main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL


type alias Model =
  { sponsors: List Sponsor
  , amount : Int
  , config : Flags
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  ( Model [] 0 flags
  , getSponsors
  )

-- UPDATE


type Msg
  = NoOp
  | Increment
  | NewSponsors (Result Http.Error (List Sponsor))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)

    Increment -> ({ model | amount = model.amount + 1 }, Cmd.none)

    NewSponsors (Ok newSponsors) ->
      ({ model | sponsors = newSponsors }, Cmd.none)

    NewSponsors (Err _) -> (model, Cmd.none)

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

decodeSponsors : Decoder (List Sponsor)
decodeSponsors =
  Json.Decode.list (map3 Sponsor
    (at ["name"] string)
    (at ["website"] string)
    (at ["logo", "url"] string)
  )

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [][
    navbar "Main title"
    , section [ class "section" ][
      div [ class "columns" ][
        div [ class "column is-two-thirds" ][
          helloBox model.amount Increment
        ]
        , div [ class "column" ][
          sponsorGrid model.sponsors
        ]
      ]
    ]
  ]


-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
