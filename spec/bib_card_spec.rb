require 'spec_helper'

describe BibCard do
  it 'has a version number' do
    expect(BibCard::VERSION).not_to be nil
  end
  
  context "fetching serialized data for a VIAF URI" do
    before(:all) do
      config = sparql_config
      
      uri = RDF::URI.new("http://viaf.org/viaf/15873")
      stub_request(:get, uri.to_s).to_return(body: body_content("viaf/LC-n78086005.xml"), :status => 200)
      stub_sparql_queries(config, "picasso")
      
      raw = BibCard.ntriples_for_viaf(uri)
      @graph = RDF::Graph.new
      RDF::Reader.for(:ntriples).new(raw) do |reader|
        reader.each_statement {|statement| @graph << statement}
      end
    end
    
    it "has the right number of RDF statements" do
      expect(@graph.size).to eq(195)
    end
  end
  
  context "fetching serialized data for an LCNAF identifier" do
    before(:all) do
      config = sparql_config
      lcnaf_id = "n78086005"
      url = "http://viaf.org/viaf/sourceID/LC|#{lcnaf_id}"
      stub_request(:get, url).to_return(body: body_content("viaf/LC-#{lcnaf_id}.xml"), :status => 200)
      stub_sparql_queries(config, "picasso")
      
      raw = BibCard.ntriples_for_lcnaf_id(lcnaf_id)
      @graph = RDF::Graph.new
      RDF::Reader.for(:ntriples).new(raw) do |reader|
        reader.each_statement {|statement| @graph << statement}
      end
    end
    
    it "has the right number of RDF statements" do
      expect(@graph.size).to eq(195)
    end
  end
end
