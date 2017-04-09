module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

import Http
import Json.Decode exposing (Decoder, string, list, map2, map3, map5, at)

import Components.Hello exposing ( hello, helloBox )
import Components.Navbar exposing ( navbar )
import Components.Sponsors exposing ( sponsorGrid, Sponsor )

-- TYPES

type alias Image = {
  url: String,
  thumbnail: String
}

type alias JumbotronImage = {
  title: String,
  url: String
}

type alias Info =
  { title : String
  , introduction : String
  , name: String
  , logo: Image
  , jumbotron: List JumbotronImage
  }

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
  { info : Info
  , sponsors : List Sponsor
  , amount : Int
  , config : Flags
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  ( Model {} [] 0 flags
  , getInfo flags.apiUrl
  , getSponsors flags.apiUrl
  )

-- UPDATE


type Msg
  = NoOp
  | Increment
  | FetchSponsors (Result Http.Error (List Sponsor))
  | FetchInfo (Result Http.Error Info)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)

    Increment -> ({ model | amount = model.amount + 1 }, Cmd.none)

    FetchSponsors (Ok newSponsors) ->
      ({ model | sponsors = newSponsors }, Cmd.none)

    FetchSponsors (Err _) -> (model, Cmd.none)

    FetchInfo (Ok newInfo) ->
      ({ model | info = newInfo }, Cmd.none)

    FetchInfo (Err _) -> (model, Cmd.none)

-- HTTP


getSponsors : String -> Cmd Msg
getSponsors apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/sponsors"

    request =
      Http.get url decodeSponsors
  in
    Http.send FetchSponsors request

decodeSponsors : Decoder (List Sponsor)
decodeSponsors =
  Json.Decode.list (map3 Sponsor
    (at ["name"] string)
    (at ["website"] string)
    (at ["logo", "url"] string)
  )

getInfo : String -> Cmd Msg
getInfo apiUrl =
  let
    url =
      apiUrl ++ "/api/v1/info"

    request =
      Http.get url decodeInfo
  in
    Http.send FetchInfo request

decodeInfo : Decoder (Info)
decodeInfo =
  map5 Info
    (at ["main_title"] string)
    (at ["introduction_text"] string)
    (at ["guild_name"] string)
    (at ["guild_logo"] (map2 Image
      (at ["url"] string)
      (at ["thumbnail"] string)
    ))
    (at ["jumbotron_images"]
      (Json.Decode.list (map2 JumbotronImage
        (at ["title"] string)
        (at ["url"] string)
      ))
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
