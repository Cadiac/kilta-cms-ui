module Models exposing (..)

import Dict exposing (Dict)
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

type LoginForm
    = Username
    | Password

type alias JwtToken =
  { id : String
  , role : String
  , username : String
  , iat : Int
  , expiry : Int
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
  , news : Dict NewsId (WebData NewsItem)
  , newsList : WebData (List NewsItem)
  , sponsors : WebData (List Sponsor)
  , amount : Int
  , config : Flags
  , route : Route
  , token : Maybe String
  , username : String
  , password : String
  , error : String
  }

initialModel : Flags -> Route -> Model
initialModel flags route =
  { info = RemoteData.Loading
  , news = Dict.empty
  , newsList = RemoteData.Loading
  , sponsors = RemoteData.Loading
  , amount = 0
  , config = flags
  , route = route
  , token = Nothing
  , username = ""
  , password = ""
  , error = ""
  }
