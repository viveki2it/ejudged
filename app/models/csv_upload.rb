require 'csv'

class CsvUpload < ActiveRecord::Base
  belongs_to :company
  attr_accessible :Type, :csv_file, :filename, :csv_errors
  attr_accessible :company_id, :presence => true
  validates :filename, :presence => true
  validates_format_of :filename, :with => %r{\.(csv|txt)$}i, :message => "extension is invalid"

	def uploadCSVFile(csvfile)
		if (csvfile.original_filename.match(%r{\.(csv|txt)$}i)) != nil
	  		File.open(Rails.root.join('public', csvfile.original_filename ), 'wb') do |file|	  	
	    		file.write(csvfile.read)
	    	end
	  	end
	end
	
	#returns the existing fields in database of Contact Info table
	def getContactInfoFields()
		@contact_info_fields = ContactInfo.column_names
		@result = Array.new
		@itemAux = Array.new
		@itemAux2 = Array.new
		@itemAux.push("",-1)
		@itemAux2.push("CustomerID",-2)
		@result.push(@itemAux)
		@result.push(@itemAux2)		
		index = 0
		@contact_info_fields.each do |c_i|
			if (c_i != "id") and (c_i != "updated_at") and (c_i != "created_at")
				@item = Array.new
				@item.push(c_i,index)
				@result.push(@item)
			end
			index = index +1
		end

		return @result
	end

	#returns the existing fields in database of Entry table
	def getEntryFields()
		@entry_fields = Entry.column_names
		@result = Array.new
		@itemAux = Array.new
		@itemAux2 = Array.new
		@itemAux3 = Array.new
		@itemAux.push("",-1)
		@itemAux2.push("CustomerID",-2)
		@itemAux3.push("ContestID",-3)
		@result.push(@itemAux)
		@result.push(@itemAux2)
		@result.push(@itemAux3)		
		index = 0
		@entry_fields.each do |e|
			if (e != "id") and (e != "updated_at") and (e != "created_at") and (e != "Score") and (e != "club_id") and (e != "customer_id") and (e != "user_id") and (e != "Created") and (e != "company_id") and (e != "contest_id")
				@item = Array.new
				@item.push(e,index)
				@result.push(@item)
			end
			index = index +1
		end

		return @result
	end

	#returns the field name corresponding to the option selected that references a Contact Info field
	def getContactInfoOption(value)
		if value == -2
			return "CustomerID"
		elsif value == -1
			return "nothing"
		else
			@contact_info_fields = ContactInfo.column_names
			return @contact_info_fields[value]
		end
	end

	#returns the field name corresponding to the option selected that references an Entry field
	def getEntryOption(value)
		if value == -2
			return "CustomerID"
		elsif value == -1
			return "nothing"
		elsif value == -3
			return "ContestID"
		else
			@entry_fields = Entry.column_names
			return @entry_fields[value]
		end
	end

	#return the headers of the csv file
	def listHeaders()

		#final code for this section
		table = CSV.read("public/" + self.filename,  {:converters => :numeric, :header_converters => :symbol})
  		return table[0]	

		# first = false
		#@return = Array.new
		# table = CSV.read("public/customers.csv",  {:converters => :numeric, :header_converters => :symbol})
		# table.each do |row|
		# 	if first
		# 		index = 0
		# 		row.each do |r|
		# 			contact_field = getContactInfoOption(index)
		# 			@contact = ContactInfo.new
		# 			@contact[contact_field] = r
		# 			@return.push(r)
		# 			@contact.save
		# 			index = index +1
		# 		end
		# 	else
		# 		first = true
		# 	end
		# end
		# return @return	
	end



	# ########################################Testing###############################################

	# def csvAlg(*args)#(csv, contact_info_field_0, contact_info_field_1, contact_info_field_2, contact_info_field_3, contact_info_field_4)
	# #arrays for returns 
 #      @errors = Array.new
 #      @result = Array.new #for save contact_infos
 #      campos = Array.new
 #       (0..4).each do |i|
 #       	 #campos.push csv.getContactInfoOption(contact_info_field_0)
 #         #campos.push "contact_info_field_#{i}".to_i
 #         campos.push args[0]
 #       end

 #      # if csv.Type == "Customer"                
 #      #   @res_customers = Array.new #for save customers
 #      #   table = CSV.read("public/" + csv.filename,  {:converters => :numeric, :header_converters => :symbol})     
 #      #   first = false #ignore the headers
 #      #   indexTable = 0
 #      #   table.each do |row|
 #      #     if first
 #      #       index = 0
 #      #       customer_exists = false #control if the customer for the selected company already exist
 #      #       customer_ok = false #control if the external customerID is present on each row
 #      #       first_name_ok = false #control if the required fields (first and last name) exists on each row
 #      #       last_name_ok = false
 #      #       @contact = ContactInfo.new #create a new customer and contact_info for each row
 #      #       @customer = Customer.new
            

 #      #       #the algorithm runs throw each row reading each field and inserting the values into customer field
 #      #       #using the mapping selected in the previous step. Besides, is controlled the data consistence, checking if
 #      #       #the required fields and the external ID is seted and exists on each row, otherwise data won't be saved.
 #      #       #the algorithm returns two arrays containing a report for each row that will show on other page
 #      #       #if the insertion is sucessfull or not, displaying the error in the last case
 #      #       row.each do |value|
 #      #         contact_field = csv.getContactInfoOption("contact_info_field_#{index}".to_i) #return the string that corresponds to the number option on ContactInfos table 
 #      #         if contact_field != "nothing" #non matching field
 #      #           if contact_field == "CustomerID" #the external id of the customer
 #      #             if (Customer.where("company_id = ? and external_id = ?", csv.company_id, value.to_s).size > 0) 
 #      #               customer_exists = true #the customer already exists
 #      #               customer_ok = true                    
 #      #             else
 #      #               if value.to_s.match(/^[+]?[0-9]+$/) != nil #control that external customerID is a valid number
 #      #                 @customer.external_id = value.to_s
 #      #                 customer_ok = true
 #      #               end
 #      #             end
 #      #           else
 #      #             @contact[contact_field] = value.to_s
 #      #             if (contact_field == "FirstName") and (value.to_s != "")
 #      #               first_name_ok = true
 #      #             end
 #      #             if (contact_field == "LastName") and (value.to_s != "")
 #      #               last_name_ok = true
 #      #             end
 #      #           end
 #      #         end
 #      #         index = index + 1
 #      #       end

 #      #       if customer_ok and first_name_ok and last_name_ok
 #      #         if not customer_exists
 #      #           @customer.club = Club.first #assign the club N/A as default 
 #      #           @customer.company = csv.company #assing the company owner of csv file
 #      #           @customer.contact_info = @contact
 #      #           @customer.updated_at = DateTime.now
 #      #           @customer.created_at = DateTime.now
 #      #           @contact.updated_at = DateTime.now
 #      #           @contact.created_at = DateTime.now
 #      #           @res_customers.push(@customer)
 #      #           @result.push(@contact)
 #      #         else
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The customer already exists for this company")
 #      #           @errors.push(@item)
 #      #         end
 #      #       elsif !customer_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The customer id cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif !first_name_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The first name cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif !last_name_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The last name cannot be empty")
 #      #           @errors.push(@item)
 #      #       end

 #      #     else
 #      #       first = true
 #      #     end
 #      #     indexTable = indexTable + 1
 #      #   end

 #      #   #save the data correctly added
 #      #   @result.each do |res|
 #      #     res.save
 #      #   end
 #      #   @res_customers.each do |rc|
 #      #     rc.save
 #      #   end

 #      # elsif csv.Type == "Entry"

 #      #   #the algorithm for the entries is almost equal to the customers; the difference is on the required fields checking
 #      #   #and there's no control if the entry already exists because it is assumed that no id is provided for an entry 
 #      #   table = CSV.read("public/" + csv.filename,  {:converters => :numeric, :header_converters => :symbol})
 #      #   first = false #ignore the headers        
 #      #   indexTable = 0
 #      #   table.each do |row|
 #      #     if first
 #      #       index = 0
 #      #       customer_ok = false
 #      #       year_ok = false
 #      #       make_ok = false
 #      #       model_ok = false
 #      #       bad_reg_or_score = false
 #      #       @entry = Entry.new
 #      #       @customer = nil
 #      #       row.each do |value|
 #      #         entry_field = csv.getEntryOption("entry_field_#{index}".to_i)            
 #      #         if entry_field != "nothing"  #non matching field
 #      #           if entry_field == "CustomerID" #the external id of the customer
 #      #             @customer = Customer.where("external_id = ? and company_id = ?", value.to_s, csv.company_id).first
 #      #             customer_ok = true
 #      #           else
 #      #             #check numericality of RegistrationNumber and Score.. if they have null values then default is zero for both
 #      #             if ((entry_field == "RegistrationNumber") or (entry_field == "Score")) and ((value.to_s.match(/^[+]?[0-9]+$/) == nil) and value.to_s != "")# or ((entry_field != RegistrationNumber) and (entry_field != Score))
 #      #               bad_reg_or_score = true
 #      #             else
 #      #               @entry[entry_field] = value.to_s                  
 #      #               if (entry_field == "Year") and (value.to_s != "")
 #      #                 year_ok = true
 #      #               end
 #      #               if (entry_field == "Make") and (value.to_s != "")
 #      #                 make_ok = true
 #      #               end
 #      #               if (entry_field == "Model") and (value.to_s != "")
 #      #                 model_ok = true
 #      #               end
 #      #             end
 #      #           end
 #      #         end              
 #      #         index = index + 1
 #      #       end
 #      #       if customer_ok and year_ok and model_ok and make_ok and (not bad_reg_or_score)                     
 #      #         if @customer != nil
 #      #           @entry.customer = @customer
 #      #           @entry.club = @customer.club
 #      #           @entry.company = csv.company
 #      #           if @entry.Score == nil
 #      #             @entry.Score = 0
 #      #           end
 #      #           @entry.created_at = DateTime.now
 #      #           @entry.updated_at = DateTime.now
 #      #           if @entry.RegistrationNumber == nil
 #      #             @entry.RegistrationNumber = 0
 #      #           end
 #      #           @result.push(@entry)
 #      #         else
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The entry customer doesn't exists for the selected company")
 #      #           @errors.push(@item)
 #      #         end
 #      #       elsif !customer_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The customer id cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif !year_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The entry year cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif !make_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The entry make cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif !model_ok
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The entry model cannot be empty")
 #      #           @errors.push(@item)
 #      #       elsif bad_reg_or_score
 #      #           @item = Array.new
 #      #           @item.push(indexTable,"The Score and Registration Number must be numbers")
 #      #           @errors.push(@item)      
 #      #       end

 #      #     else
 #      #       first = true
 #      #     end
 #      #     indexTable = indexTable + 1
 #      #   end
 #      #   @result.each do |res|
 #      #     res.save
 #      #   end        
 #      # end
 #       @return = Array.new
 #       @return.push(@result, @errors, campos)
 #       return @return
	# end

end
