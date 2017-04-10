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

type alias NewsId = Int

type alias NewsItem =
  { id : NewsId
  , title : String
  , text : String
  , slug : String
  , created_on : String
  , tags : String
  , news_category : Int
  , authors : List String
  }

-- ROUTES


type Route
    = IndexRoute
    | NewsListRoute
    | NewsRoute NewsId
    | NotFoundRoute

-- MODEL


type alias Model =
  { info : WebData Info
  , news : WebData (List NewsItem)
  , sponsors : WebData (List Sponsor)
  , amount : Int
  , config : Flags
  , route : Route
  }

initialModel : Flags -> Route -> Model
initialModel flags route =
  { info = RemoteData.Loading
  , news = RemoteData.Loading
  , sponsors = RemoteData.Loading
  , amount = 0
  , config = flags
  , route = route
  }