require 'custom_bitly'

module ApplicationHelper

  def shorten_url( url )
    CustomBitly.shorten( URI.escape( url ) )
  end
  
  def display_score( score )
    output = ''
    if score == 1
      output = "#{ score } point"
    else
      output = "#{ score } points"
    end
    output
  end
  
  def random_quote
    text = author = ''
    case rand(6)+1
    when 1
      text = "Democracy cannot prosper without informed and engaged Foursquare users."
      author = "Thomas Paine"
    when 2
      text = "Let every sluice of knowledge be opened and set a-flowing."
      author = "John Adams"
    when 3
      text = "The degeneration of the US free-market system into crony capitalism should anger any person who loves freedom and democracy."
      author = "Luigi Zingales"
    when 4
      text = "I get elected by voters, I get financed by contributors. Voters don't care about this, contributors do."
      author = "Unnamed congressman"
    when 5
      text = "Secrecy is the keystone to all tyranny."
      author = "Robert Heinlein"
    when 6
      text = "Publicity is justly commended as a remedy for social and industrial diseases."
      author = "Louis Brandeis"
    else
      text = "Secrecy is the keystone to all tyranny."
      author = "Robert Heinlein"
    end
    return text, author
  end

end
