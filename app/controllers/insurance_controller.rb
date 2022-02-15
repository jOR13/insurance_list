class InsuranceController < ActionController::Base
require 'csv'

    def index

       @list = CSV.read("List insurance companies.csv")
    
    end

    def create
        puts "SSSSSSSSSSSSSSSSSSSSSs"
        puts params
        if params[:zip].present?
            if params[:commit] == "Insurance Brokers"
                Scraper.new(params[:zip]).scrape_insurance_agents_brokers
            else
                Scraper.new(params[:zip]).scrape_insurance_companies
             
            end
        else
            redirect_to root_path, notice: "Please add a ZIP code for search"
        end
        
        
    end

end
