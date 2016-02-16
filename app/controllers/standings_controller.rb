class StandingsController < ApplicationController

  def index
    @title = 'Top Scores'
  end
  
  def democrats
    @title = 'Blue Points'
    @points = Point.eligible_dems
  end
  
  def republicans
    @title = 'Red Points'
    @points = Point.eligible_reps
  end
  
  def football
  
    @title = 'Fantasy Football'
  
    ## Load companies/teams
    @teams = []
    @teams << create_team( "New York Giants",  "MetLife Stadium", 6, 4 )
    @teams << create_team( "New York Jets",  "MetLife Stadium", 3, 6 )
    @teams << create_team( "Dallas Cowboys",  "Cowboys Stadium", 4, 5 )
    @teams << create_team( "Washington Redskins",  "FedEx Field", 3, 6 )
    @teams << create_team( "Kansas City Chiefs",  "Arrowhead Stadium", 1, 8 )
    @teams << create_team( "Denver Broncos",  "Sports Authority Field at Mile High", 6, 3 )
    @teams << create_team( "Miami Dolphins",  "Sun Life Stadium", 4, 5 )
    @teams << create_team( "Carolina Panthers",  "Bank of America Stadium", 2, 7 )
    @teams << create_team( "New Orleans Saints",  "Mercedes-Benz Superdome", 4, 5 )
    @teams << create_team( "Cleveland Browns",  "Cleveland Browns Stadium", 2, 7 )
    @teams << create_team( "Green Bay Packers",  "Lambeau Field", 6, 3 )
    @teams << create_team( "Buffalo Bills",  "Ralph Wilson Stadium", 3, 6 )
    @teams << create_team( "Atlanta Falcons",  "Georgia Dome", 8, 1 )
    @teams << create_team( "Houston Texans",  "Reliant Stadium", 8, 1 )
    @teams << create_team( "Baltimore Ravens",  "M&T Bank Stadium", 7, 2 )
    @teams << create_team( "San Diego Chargers",  "Qualcomm Stadium", 4, 5 )
    @teams << create_team( "San Francisco 49ers",  "Candlestick Park", 6, 2, 1 )
    @teams << create_team( "Philadelphia Eagles",  "Lincoln Financial Field", 3, 6 )
    @teams << create_team( "Tennessee Titans",  "LP Field", 4, 6 )
    @teams << create_team( "New England Patriots",  "Gillette Stadium", 6, 3 )
    @teams << create_team( "Jacksonville Jaguars",  "EverBank Field", 1, 8 )
    @teams << create_team( "Seattle Seahawks",  "CenturyLink Field", 6, 4 )
    @teams << create_team( "St. Louis Rams",  "Edward Jones Dome", 3, 5, 1 )
    @teams << create_team( "Tampa Bay Buccaneers",  "Raymond James Stadium", 5, 4 )
    @teams << create_team( "Cincinnati Bengals",  "Paul Brown Stadium", 4, 5 )
    @teams << create_team( "Pittsburgh Steelers",  "Heinz Field", 6, 3 )
    @teams << create_team( "Detroit Lions",  "Ford Field", 4, 5 )
    @teams << create_team( "Minnesota Vikings",  "Hubert H. Humphrey Metrodome", 6, 4 )
    @teams << create_team( "Arizona Cardinals",  "University of Phoenix Stadium", 4, 5 )
    @teams << create_team( "Oakland Raiders",  "O.co Coliseum", 3, 6 )
    @teams << create_team( "Indianapolis Colts",  "Lucas Oil Stadium", 6, 3 )
    @teams << create_team( "Chicago Bears",  "Soldier Field", 7, 2 )
    
    ## Sort!
    @teams.sort! { |a,b| a[:club] <=> b[:club] }
      
    ## Calculate standings
    dem_wins = dem_losses = dem_ties = rep_wins = rep_losses = rep_ties = np_wins = np_losses = np_ties = 0
    @teams.each do |team|
      if team[:company] and team[:company].is_democratic?
        dem_wins += team[:wins]
        dem_losses += team[:losses]
        dem_ties += team[:ties]
      elsif team[:company] and team[:company].is_republican?
        rep_wins += team[:wins]
        rep_losses += team[:losses]
        rep_ties += team[:ties]
      else
        np_wins += team[:wins]
        np_losses += team[:losses]
        np_ties += team[:ties]
      end
    end
    
    @rankings = []
    @rankings << { :name => 'Democrats', :wins => dem_wins, :losses => dem_losses, :ties => dem_ties, :pct => set_pct( dem_wins, dem_losses, dem_ties) }
    @rankings << { :name => 'Republicans', :wins => rep_wins, :losses => rep_losses, :ties => rep_ties, :pct => set_pct( rep_wins, rep_losses, rep_ties) }
    @rankings << { :name => 'Nonpartisans', :wins => np_wins, :losses => np_losses, :ties => np_ties, :pct => set_pct( np_wins, np_losses, np_ties) }
    
    ## Sort!
    @rankings.sort! { |a,b| b[:pct] <=> a[:pct] }
  
  end
  
  private
  
  def create_team( club, stadium, wins, losses, ties=0 )
    { :club => club, :stadium => stadium, :company => Company.identify( stadium ), :wins => wins, :losses => losses, :ties => ties }
  end
  
  def set_pct( wins, losses, ties )
    (wins.to_f+(ties.to_f/2))/(wins+losses+ties).to_f
  end

end
