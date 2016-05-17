class Pickup < ActiveRecord::Base
  belongs_to :day
  
  validates :donor_last_name,     presence: { message: "is required." }
  validates :donor_phone,         presence: { message: "number is required." } 
  validates :donor_address_line1, presence: { message: "is required." } 
  validates :donor_city,          presence: { message: "is required." } 
  validates :donor_zip,           presence: { message: "is required." } 
  validates :donor_dwelling_type, presence: { message: "is required." } 
  validates :number_of_items,     presence: { message: "is required." }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :donor_email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }
  
  #Function that builds csv file with donor info. Called in reports controller.
  def self.to_donor_csv
    headers = ["FIRST", "SPOUSE", "LAST", "ADDRESS", "TOWN", 
    "STATE", "ZIP", "E-MAIL","DATE DONATED", "ITEMS DONATED"]
    
    #Creates array with given values.
    attributes = %w{donor_first_name donor_first_name donor_last_name address
    donor_city state donor_zip donor_email date item_notes}
    
    #Generates csv
    CSV.generate(headers: true) do |csv|
      
      #Add headers
      csv << headers
      
      #For each pickup, a new row is added and the columns are filled with the
      #values specified in the attributes array
      all.each do |donor|
        csv << attributes.map{ |attr| donor.send(attr) }
      end
    end
  end
  
  #Function that builds csv files with pickup info. Called in reports controller. 
  def self.to_routes_csv
    headers = ["Street","City","State","Zip","Country","Notes"]
    
    #Creates array with given values. 
    attributes = %w{address donor_city state donor_zip country donor_notes}
    
    #Generate csv file
    CSV.generate(headers: true) do |csv|
      
      #Add headers
      csv << headers
      
      #For each pickup, a new row is added and the columns are filled with the 
      #values specified in the attributes array
      all.each do |pickup|
        csv << attributes.map{ |attr| pickup.send(attr) }
      end
    end
  end
  
  #Function that builds pdf with pickup info. Called in reports controller. Takes a 
  #string specifying a date as a parameter. 
  def self.to_pdf(day)
    pickupdate = Date.parse(day)
    pdf = Prawn::Document.new
    
    #Adds sharing connections logo to pdf
    pdf.image "#{Rails.root}/app/assets/images/SC_logo.png", :width => 200, :position => :right
    pdf.move_down 10
    
    #Adds title to pdf.
    pdf.text  pickupdate.strftime("Pickup Schedule for %A %b %d, %Y") , 
                    :align => :center, :style => :bold, :size => 14
    pdf.move_down 10
    
    #Data that will be used to generate our table. First row contains the headers. 
    data = [["", "<b>Name/Contact</b>", "<b>Address</b>", "<b>Donor Items/Notes</b>"]]
    i = 1;
    
    #For each pickup we add a new row and specify the data that will be included in each column. 
    all.each do |pickup|
      data += [[i,"#{pickup.donor_first_name}\n#{pickup.donor_phone}",
                  "#{pickup.donor_address_line1}\n#{pickup.donor_address_line2}\n#{pickup.donor_city}, IL #{pickup.donor_zip}",
                  "#{pickup.item_notes}\nDonor: '#{pickup.donor_notes}'"]]
      i += 1
    end
    
    #Adds table to pdf
    pdf.table(data, :header => true, :cell_style => { :size => 10, :inline_format => true},
                    :position => :center, :column_widths => [15,130,135,240])
    pdf.render
  end

  #Helper private functions
  private
  
  def date
   Day.find(day_id).date
  end
  
  def state
    "IL"
  end
  
  def country
    "US"
  end
  
  def address
    "#{donor_address_line1}, #{donor_address_line2}"
  end
end
