module Models exposing (..)

import Dict exposing (Dict)
import RemoteData exposing (WebData)

type alias Image = {
  url : String,
  thumbnail : String
}

type alias JumbotronImage = {
  title : String,
  url : String
}

type alias Info =
  { title : String
  , introduction : String
  , name : String
  , logo : Image
  , jumbotron : List JumbotronImage
  }

type alias FooterLink =
  { title : String
  , url : String
  }

type alias SocialMediaButton =
  { title : String
  , url : String
  , logo : Image
  }

type alias Footer =
  { contact_info : String
  , other_links : List FooterLink
  , social_media_buttons : List SocialMediaButton
  }

type alias Flags =
  { apiUrl : String
  , token : String
  }

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
  , slug : Slug
  , created_on : String
  , tags : String
  , news_category : Int
  , authors : List String
  }

type alias NewsCategoryId = Int

type alias NewsCategory =
  { id : NewsCategoryId
  , title : String
  , slug : Slug
  }

type alias PageCategoryId = Int

type alias SubPage =
  { title : String
  , slug : Slug
  , priority : Int
  }

type alias PageCategory =
  { title : String
  , slug : Slug
  , subpages : List SubPage
  }

type alias PageItem =
  { title : String
  , slug : Slug
  , text : String
  , mainCategory : PageCategoryId
  }

type alias EventId = Int

type alias EventItem =
  { id : EventId
  , title : String
  , text : String
  , slug : String
  , created_on : String
  , location : String
  , event_start_time : String
  , event_end_time : String
  , registration_start_time : String
  , registration_end_time : String
  , max_participants : Int
  , authors : List String
  , participants : List String
  }

type alias BoardYear =
  { title : String
  , year : Int
  , slug : String
  }

type alias BoardMember =
  { id : Int
  , title : String
  , first_name : String
  , last_name : String
  , email_shorthand : String
  , irc : String
  , image : Image
  }

type alias BoardMeta =
  { text : String
  , title : String
  , year : Int
  , slug : String
  , board_members_title : String
  , board_officials_title : String
  }

type alias BoardItem =
  { meta : BoardMeta
  , chairman : BoardMember
  , board_members : List BoardMember
  , board_officials : List BoardMember
  }

type LoginForm
    = Username
    | Password

type ProfileForm
    = FirstName
    | LastName
    | Email
    | Phone

type alias JwtToken =
  { id : Int
  , role : String
  , username : String
  , iat : Int
  , expiry : Int
  }

type alias Profile =
  { username : String
  , firstName : String
  , lastName : String
  , email : String
  , phone : String
  , role : String
  }

-- ROUTES

type alias Slug = String

type Route
  = IndexRoute
  | LoginRoute
  | ProfileRoute
  | LogoutRoute
  | NewsListRoute
  | NewsRoute NewsId
  | EventListRoute
  | EventRoute EventId
  | PageRoute Slug
  | SubPageRoute Slug Slug
  | BoardRoute Slug
  | NotFoundRoute

-- MODEL


type alias Model =
  { info : WebData Info
  , footer : WebData Footer
  , news : Dict NewsId (WebData NewsItem)
  , newsList : WebData (List NewsItem)
  , events : Dict EventId (WebData EventItem)
  , eventsList : WebData (List EventItem)
  , newsCategories : WebData (List NewsCategory)
  , pageCategories : WebData (List PageCategory)
  , pages : Dict Slug (WebData PageItem)
  , boards : Dict Slug (WebData BoardItem)
  , sponsors : WebData (List Sponsor)
  , amount : Int
  , config : Flags
  , route : Route
  , token : String
  , decodedToken : Maybe JwtToken
  , profile : WebData Profile
  , username : String
  , password : String
  , logoutTimer : Int
  , jumbotronTimer : Int
  , error : String
  }
