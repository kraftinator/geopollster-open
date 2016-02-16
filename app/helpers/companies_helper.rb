module CompaniesHelper

  def party_name( company, index )
    index -= 1
    return 'Democrats' if company.party_order[index] == 'dem'
    return 'Republicans' if company.party_order[index] == 'rep'
    'Other'
  end
  
  def party_abbrev( company, index )
    index -= 1
    return 'Dem' if company.party_order[index] == 'dem'
    return 'Rep' if company.party_order[index] == 'rep'
    'Other'
  end
  
  def party_amount( company, index )
    index -= 1
    return company.party_breakdown.dem_amount if company.party_order[index] == 'dem'
    return company.party_breakdown.rep_amount if company.party_order[index] == 'rep'
    company.party_breakdown.other_amount
  end
  
  def party_percent( company, index )
    index -= 1
    return "(#{ sprintf( "%.0f", company.party_breakdown.dem_percent * 100 ) }%)" if company.party_order[index] == 'dem'
    return "(#{ sprintf( "%.0f", company.party_breakdown.rep_percent * 100 ) }%)" if company.party_order[index] == 'rep'
    "(#{ sprintf( "%.0f", company.party_breakdown.other_percent * 100 ) }%)"
  end
  
  def party_color( company, index )
    index -= 1
    return "#337099" if company.party_order[index] == 'dem'
    return "#DF2020" if company.party_order[index] == 'rep'
    "#555555"
  end

end
