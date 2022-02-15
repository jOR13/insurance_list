require "selenium-webdriver"
require 'csv'
class Scraper

    def initialize(zip)
        @zip = zip

    end

    def scrape_insurance_companies
        driver = Selenium::WebDriver.for :chrome
        driver.navigate.to "https://interactive.web.insurance.ca.gov/apex_extprd/f?p=400:50"
        element = driver.find_element(:id, "P50_ZIP")
        element.send_keys @zip
        btnSubmit = driver.find_element(:id, "B66921415930572593")
        btnSubmit.click
        sleep 3
        16.times do
            driver.find_elements(xpath: "//*[@id='report_R251401784479545440']/div/div[1]/table/tbody/tr").each.with_index(1) do |_,index|
                driver.find_elements(:xpath, "//*[@id='report_R251401784479545440']/div/div[1]/table/tbody/tr[#{index}]/td[1]").each do |td|
                    value = td.text.gsub("Company Profile", "")
                    value.split("\n").join(" ")
                    CSV.open("List insurance companies.csv", "a+") do |csv|
                        csv << [value]
                    end
                end
            end
            begin
                if driver.find_element(:xpath, "//*[@id='report_R251401784479545440']/div/table[2]/tbody/tr/td/table/tbody/tr/td[4]/a").displayed?
                    nextBtn = driver.find_element(:xpath, "//*[@id='report_R251401784479545440']/div/table[2]/tbody/tr/td/table/tbody/tr/td[4]/a")
                    nextBtn.click
                end
            rescue => exception
                puts "No more pages"
                driver.quit
                return
            end
            sleep 1
        end
    end

    def scrape_insurance_agents_brokers
        driver = Selenium::WebDriver.for :chrome
        driver.navigate.to "https://interactive.web.insurance.ca.gov/apex_extprd/f?p=400:50:1648538187974::NO:RP:P50_ACTION,P50_LARGE:AGENTS,HO_FIRE"
        element = driver.find_element(:id, "P50_ZIP")
        element.send_keys @zip
        btnSubmit = driver.find_element(:id, "B66921782583572594")
        btnSubmit.click
        sleep 25
        pages = driver.find_element(:class, "a-IRR-pagination-label").text.split("of").last.strip.to_i / 5
        pages.times do
            driver.find_elements(xpath: "//*[@id='164011617385680979_orig']/tbody/tr").each.with_index(2) do |_,index|
                driver.find_elements(:xpath, "//*[@id='164011617385680979_orig']/tbody/tr[#{index}]/td[2]").each do |td|
                    value = td.text.gsub("Company Profile", "")
                        CSV.open("List insurance brokers.csv", "a+") do |csv|
                            csv << [value]
                        end   
                end
            end
            begin
                if driver.find_element(:xpath, "//*[@id='R164011470624680978_data_panel']/div[2]/ul/li[3]/button").displayed?
                    nextBtn = driver.find_element(:xpath, "//*[@id='R164011470624680978_data_panel']/div[2]/ul/li[3]/button")
                    nextBtn.click
                end
            rescue => exception
                puts "No more pages"
            end
            sleep 3
        end
    end

end