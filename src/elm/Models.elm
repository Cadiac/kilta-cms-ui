module Models exposing (..)

import Components.Sponsors exposing ( Sponsor )

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

-- MODEL


type alias Model =
  { info : Info
  , sponsors : List Sponsor
  , amount : Int
  , config : Flags
  }

initialModel : Flags -> Model
initialModel flags =
  { info = (Info "" "" "" (Image "" "") [])
  , sponsors = []
  , amount = 0
  , config = flags
  }
