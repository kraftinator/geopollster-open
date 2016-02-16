def tally( item, create_power_change=true )

  parties = Party.all
  parties.each { |p| p['total'] = 0 }
    
  ## Get polling results. Set cache to false.
  results = item.polling( false )
  
  vote_total = 0
  results.each do |r|
    vote_total += r.total.to_i
    parties.each do |p|
      if p == r.party
        p.total = r.total.to_i
        next
      end
    end
  end
  
  parties.each do |p|
    vc = VoteCount.find_by_object_id_and_object_type_and_party_id( item, item.class.name, p )        
    if vc
      if vc.total.to_s != p.total
        vc.update_attributes( :total => p.total )
      end
    elsif p.total > 0
      vc = VoteCount.new( :object => item, :party => p, :total => p.total )
      vc.save
    end
  end
  
  if create_power_change
  
    parties.sort! { |a,b| b.total <=> a.total }
    winning_party = nil
    power_change = false
  
    for p in parties
      if winning_party.nil?
        break if p == item.party
        winning_party = p
      else
        if p.total != winning_party.total
          power_change = true
          break
        else
          break if p == item.party
        end
      end
    end
    
    if power_change
      losing_party = item.party
      item.update_attribute( :party, winning_party )
      PowerChange.create( :object => item, :winning_party => winning_party, :losing_party => losing_party )
    else
      total_votes = VoteCount.find( :first, :conditions => ["object_type = ? and object_id = ?", item.class.name, item.id], :select => 'sum(vote_counts.total) as total')
      item.update_attribute( :party_id, nil ) if total_votes.total == 0     
    end
  
  end

end
  
if ARGV[0] == 'states'
  ## Tally state votes
  states = State.all
  states.each { |s| tally( s ) }
elsif ARGV[0] == 'countries'
  ## Tally country votes
  tally( Country.find_by_code( 'US' ) )
elsif ARGV[0] == 'categories'
  ## Tally category votes
  categories = Category.find_all_by_eligible( true )
  categories.each { |c| tally( c ) }
elsif ARGV[0] == 'genders'
  ## Tally gender votes
  tally( Gender.find_by_abbrev( 'F' ), false )
  tally( Gender.find_by_abbrev( 'M' ), false )
elsif ARGV[0] == 'mobile_devices'
  ## Tally mobile device votes
  mobile_devices = MobileDevice.find_all_by_eligible( true )
  mobile_devices.each { |m| tally( m, false ) }
end
