class CustomersController < ApplicationController
  # GET /customers
  # GET /customers.json
  def index

    @customers = Customer.all

    if not ((request.format == "json") and (not params[:page].present?))
      @customers = Kaminari.paginate_array(@customers).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
    @club = @customer.club
  end

  # POST /customers
  # POST /customers.json
  def create

    if (not params[:contact_info_id].nil?) and (not params[:customer][:club_id].nil?)
      @contact_info = ContactInfo.find(params[:contact_info_id])
      @club = Club.find(params[:customer][:club_id])
      @customer = @club.customers.create(params[:customer])
      @customer.contact_info = @contact_info
      
    elsif not params[:contact_info_id].nil?
      @contact_info = ContactInfo.find(params[:contact_info_id])
      @customer = Customer.new(params[:customer])
      @customer.contact_info = @contact_info

    elsif (not params[:customer][:club_id].nil?) and (not params[:customer][:contact_info_id].nil?)
      @club = Club.find(params[:customer][:club_id])
      @contact_info = ContactInfo.find(params[:customer][:contact_info_id])
      @customer = @club.customers.create(params[:customer])
      @customer.contact_info = @contact_info

    elsif not params[:customer][:club_id].nil?
      @club = Club.find(params[:customer][:club_id])
      @customer = @club.customers.create(params[:customer])

    elsif not params[:customer][:contact_info_id].nil?
      @contact_info = ContactInfo.find(params[:customer][:contact_info_id])
      @customer = Customer.new(params[:customer])
      @customer.contact_info = @contact_info

    else
      @customer = Customer.new(params[:customer])

    end

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, :notice => 'Customer was successfully created.' }
        format.json { render :json => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.json { render :json => @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])

    if not params[:customer][:club_id].nil?
      @club = Club.find(params[:customer][:club_id])
      @customer.club = @club
    end

    if not params[:customer][:contact_info_id].nil?
      @contact_info = ContactInfo.find(params[:customer][:contact_info_id])
      @customer.contact_info = @contact_info
    end

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to @customer, :notice => 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
end
