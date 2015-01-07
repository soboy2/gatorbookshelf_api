require 'sinatra'
require 'json'

get '/search/:keyword' do
  content_type :json
  keyword = params[:keyword]
  results = ''
  if(keyword == 'lord of the rings')
    results = [
      {
        author: "R Tolkein",
        title: "Lord of the rings: The hobbit",
        last_update: "2015-01-05T11:30:00Z",
        description: "Looks great",
        listing_id: 1,
        owner_id: 2,
        listing_price: 33
      },
      {
        author: "R Tolkein",
        title: "Lord of the rings: Fellowship of the Ring",
        last_update: "2015-02-06T10:30:00Z",
        description: "Looks great",
        listing_id: 2,
        owner_id: 3,
        listing_price: 30
      }
    ]

  else
    results = {error: 'no matches found'}
  end
  results.to_json
end
