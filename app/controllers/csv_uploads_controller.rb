class CsvUploadsController < ApplicationController
  # GET /csv_uploads
  # GET /csv_uploads.json
  def index
    @csv_uploads = CsvUpload.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @csv_uploads }
    end
  end

  # GET /csv_uploads/1
  # GET /csv_uploads/1.json
  def show
    @csv_upload = CsvUpload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @csv_upload }
    end
  end

  # GET /csv_uploads/new
  # GET /csv_uploads/new.json
  def new
    @csv_upload = CsvUpload.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @csv_upload }
    end
  end

  # GET /csv_uploads/1/edit
  def edit
    @csv_upload = CsvUpload.find(params[:id])
  end

  # POST /csv_uploads
  # POST /csv_uploads.json
  def create

    @csv_upload = CsvUpload.new
    @csv_upload.Type = params[:Type]

    if params[:csv_upload][:csv_file].present?            
      @csv_upload.uploadCSVFile(params[:csv_upload][:csv_file])      
      @csv_upload.filename = params[:csv_upload][:csv_file].original_filename
    end

    if not params[:csv_upload][:company_id].nil?
      @company = Company.find(params[:csv_upload][:company_id])
      @csv_upload.company = @company
    end

    respond_to do |format|
      if @csv_upload.save
        format.html { redirect_to edit_csv_upload_path(@csv_upload)}
        format.json { render json: @csv_upload, status: :created, location: @csv_upload }
      else
        format.html { render action: "new" }
        format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /csv_uploads/1
  # PUT /csv_uploads/1.json
  def update

    @csv_upload = CsvUpload.find(params[:id])

    #parsing and processing the file
    begin

      #arrays for returns 
      @errors = Array.new
      @result = Array.new #for save contact_infos

      if @csv_upload.Type == "Customer"                
        @res_customers = Array.new #for save customers
        table = CSV.read("public/" + @csv_upload.filename,  {:converters => :numeric, :header_converters => :symbol})     
        first = false #ignore the headers
        indexTable = 0
        table.each do |row|
          if first
            index = 0
            customer_exists = false #control if the customer for the selected company already exist
            customer_ok = false #control if the external customerID is present on each row
            first_name_ok = false #control if the required fields (first and last name) exists on each row
            last_name_ok = false
            @contact = ContactInfo.new #create a new customer and contact_info for each row
            @customer = Customer.new

            #the algorithm runs throw each row reading each field and inserting the values into customer field
            #using the mapping selected in the previous step. Besides, is controlled the data consistence, checking if
            #the required fields and the external ID is seted and exists on each row, otherwise data won't be saved.
            #the algorithm returns two arrays containing a report for each row that will show on other page
            #if the insertion is sucessfull or not, displaying the error in the last case
            row.each do |value|
              contact_field = @csv_upload.getContactInfoOption(params["contact_info_field_#{index}"].to_i) #return the string that corresponds to the number option on ContactInfos table 
              if contact_field != "nothing" #non matching field
                if contact_field == "CustomerID" #the external id of the customer
                  if (Customer.where("company_id = ? and external_id = ?", @csv_upload.company_id, value.to_s).size > 0) 
                    customer_exists = true #the customer already exists
                    customer_ok = true                    
                  else
                    if value.to_s.match(/^[+]?[0-9]+$/) != nil #control that external customerID is a valid number
                      @customer.external_id = value.to_s
                      customer_ok = true
                    end
                  end
                else
                  @contact[contact_field] = value.to_s
                  if (contact_field == "FirstName") and (value.to_s != "")
                    first_name_ok = true
                  end
                  if (contact_field == "LastName") and (value.to_s != "")
                    last_name_ok = true
                  end
                end
              end
              index = index + 1
            end

            if customer_ok and first_name_ok and last_name_ok
              if not customer_exists
                @customer.club = Club.first #assign the club N/A as default 
                @customer.company = @csv_upload.company #assing the company owner of csv file
                @customer.contact_info = @contact
                @customer.updated_at = DateTime.now
                @customer.created_at = DateTime.now
                @contact.updated_at = DateTime.now
                @contact.created_at = DateTime.now
                @customer.save
                @contact.save
                @res_customers.push(@customer)
                @result.push(@contact)
              else
                @item = Array.new
                @item.push(indexTable,"The customer already exists for this company")
                @errors.push(@item)
              end
            elsif !customer_ok
                @item = Array.new
                @item.push(indexTable,"The customer id cannot be empty")
                @errors.push(@item)
            elsif !first_name_ok
                @item = Array.new
                @item.push(indexTable,"The first name cannot be empty")
                @errors.push(@item)
            elsif !last_name_ok
                @item = Array.new
                @item.push(indexTable,"The last name cannot be empty")
                @errors.push(@item)
            end

          else
            first = true
          end
          indexTable = indexTable + 1
        end

        #save the data correctly added
        # @result.each do |res|
        #   res.save
        # end
        # @res_customers.each do |rc|
        #   rc.save
        # end

      elsif @csv_upload.Type == "Entry"

        #the algorithm for the entries is almost equal to the customers; the difference is on the required fields checking
        #and there's no control if the entry already exists because it is assumed that no id is provided for an entry 
        table = CSV.read("public/" + @csv_upload.filename,  {:converters => :numeric, :header_converters => :symbol})
        first = false #ignore the headers        
        indexTable = 0
        table.each do |row|
          if first
            index = 0
            customer_ok = false
            year_ok = false
            make_ok = false
            model_ok = false
            bad_reg = false
            contest_ok = false
            @entry = Entry.new
            @customer = nil
            @contest = nil
            row.each do |value|
              entry_field = @csv_upload.getEntryOption(params["entry_field_#{index}"].to_i)            
              if entry_field != "nothing"  #non matching field
                if entry_field == "CustomerID" #the external id of the customer
                  @customer = Customer.where("external_id = ? and company_id = ?", value.to_s, @csv_upload.company_id).first
                  customer_ok = true
                elsif entry_field == "ContestID" #the contest ID 
                  @contest = Contest.where("id = ?", value.to_s).first
                else
                  #check numericality of RegistrationNumber... if they have null values then default is zero for both
                  if (entry_field == "RegistrationNumber") and ((value.to_s.match(/^[+]?[0-9a-zA-Z]+$/) == nil) and value.to_s != "")# or ((entry_field != RegistrationNumber) and (entry_field != Score))
                    bad_reg = true
                  else
                    @entry[entry_field] = value.to_s                  
                    if (entry_field == "Year") and (value.to_s != "")
                      year_ok = true
                    end
                    if (entry_field == "Make") and (value.to_s != "")
                      make_ok = true
                    end
                    if (entry_field == "Model") and (value.to_s != "")
                      model_ok = true
                    end
                  end
                end
              end              
              index = index + 1
            end
            if customer_ok and year_ok and model_ok and make_ok and (not bad_reg)                     
              if @customer != nil
                @entry.customer = @customer
                @entry.club = @customer.club
                @entry.company = @csv_upload.company
                if @contest != nil
                  @entry.contest = @contest
                end               
                @entry.Score = 0                
                @entry.created_at = DateTime.now
                @entry.updated_at = DateTime.now
                if @entry.RegistrationNumber == nil
                  @entry.RegistrationNumber = 0
                end
                @result.push(@entry)
              else
                @item = Array.new
                @item.push(indexTable,"The entry customer doesn't exists for the selected company")
                @errors.push(@item)
              end
            elsif !customer_ok
                @item = Array.new
                @item.push(indexTable,"The customer id cannot be empty")
                @errors.push(@item)
            elsif !year_ok
                @item = Array.new
                @item.push(indexTable,"The entry year cannot be empty")
                @errors.push(@item)
            elsif !make_ok
                @item = Array.new
                @item.push(indexTable,"The entry make cannot be empty")
                @errors.push(@item)
            elsif !model_ok
                @item = Array.new
                @item.push(indexTable,"The entry model cannot be empty")
                @errors.push(@item)
            elsif bad_reg
                @item = Array.new
                @item.push(indexTable,"The RegistrationNumber must be a number")
                @errors.push(@item)      
            end

          else
            first = true
          end
          indexTable = indexTable + 1
        end
        @result.each do |res|
          res.save
        end       
      end

    rescue Exception => e
      #if any exception occurs, then redirect to a custom error page
      render :template => "csv_uploads/error.html.erb" 
      #render :text => {error:"Error processing CSV file", err_description: e.message}, :status => :unprocessable_entity 
    else

      respond_to do |format|
        if @csv_upload.update_attributes(params[:csv_upload])
          format.html { redirect_to @csv_upload , :flash => { :csv_errors => @errors , :csv_sucessfull => @result}, notice: '' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /csv_uploads/1
  # DELETE /csv_uploads/1.json
  def destroy
    @csv_upload = CsvUpload.find(params[:id])
    @csv_upload.destroy

    respond_to do |format|
      format.html { redirect_to csv_uploads_url }
      format.json { head :no_content }
    end
  end
end
