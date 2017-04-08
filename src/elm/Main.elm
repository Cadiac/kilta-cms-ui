module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Http
import Json.Decode exposing (Decoder, string, list, map3, at)

-- component import example
import Components.Hello exposing ( hello )
import Components.Navbar exposing ( navbar )
import Components.Sponsors exposing ( sponsorGrid, Sponsor )

-- APP
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Model =
  { sponsors: List Sponsor
  , amount : Int
  }

init : (Model, Cmd Msg)
init =
  ( Model [] 0
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
    (at ["logo"] string)
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
  div [ class "container" ][
    navbar "Main title"
    , sponsorGrid model.sponsors
    , div [ class "box" ][    -- inline CSS (literal)
      article [ class "media" ][
        div [ class "media-left" ][
          figure [ class "image is-64x64" ][
            img [ src "static/img/elm.jpg"  ] []
          ]                             -- inline CSS (via var)
        ]
        , div [ class "media-content" ][
          div [ class "content" ][
            hello model.amount                                                    -- ext 'hello' component (takes 'model' as arg)
            , p [ class "title is-4" ] [ text ( "Elm Webpack Starter" ) ]
            , button [ class "button is-primary", onClick Increment ] [                  -- click handler
              span [ class "icon is-small" ][
                i [ class "fa fa-star" ][]
              ]
              , span [][ text "Increment" ]
            ]
          ]
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
