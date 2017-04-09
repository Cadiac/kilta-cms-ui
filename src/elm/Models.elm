module Models exposing (..)

import RemoteData exposing (WebData)

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


type alias Sponsor =
  { name : String
  , website : String
  , logo: String
  }

-- MODEL


type alias Model =
  { info : WebData Info
  , sponsors : WebData (List Sponsor)
  , amount : Int
  , config : Flags
  }

initialModel : Flags -> Model
initialModel flags =
  { info = RemoteData.Loading
  , sponsors = RemoteData.Loading
  , amount = 0
  , config = flags
  }
