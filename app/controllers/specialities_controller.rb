class SpecialitiesController < ApplicationController
  # GET /specialities
  # GET /specialities.json
  def index
    
    if params[:event_id].present? and params[:page].present?
      @specialities = Speciality.where("id IN(?)", getSpecialityEvents(params[:event_id])).page(params[:page]).per(10)

      @specialities.each do |sp|
        sp[:eventID] = params[:event_id]
      end
      
    elsif params[:event_id].present?
      @specialities = Speciality.where("id IN(?)", getSpecialityEvents(params[:event_id]))

      @specialities.each do |sp|
        sp[:eventID] = params[:event_id]
      end

    elsif params[:page].present?
      @specialities = Speciality.page(params[:page]).per(10)

      @specialities.each do |sp|
        sp[:eventID] = -1
      end

    else
      @specialities = Speciality.all

      @specialities.each do |sp|
        sp[:eventID] = -1
      end

    end

    if not params[:page].present? #comes from web or json and already paginate array, don't paginate again
      if not ((request.format == "json") and (not params[:page].present?)) #comes from web and ask for index then paginate array
        @specialities = Kaminari.paginate_array(@specialities).page(params[:page]).per(10)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @specialities }
    end
  end

  # GET /specialities/1
  # GET /specialities/1.json
  def show
    @speciality = Speciality.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @speciality }
    end
  end

  # GET /specialities/new
  # GET /specialities/new.json
  def new
    @speciality = Speciality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @speciality }
    end
  end

  # GET /specialities/1/edit
  def edit
    @speciality = Speciality.find(params[:id])
  end

  # POST /specialities
  # POST /specialities.json
  def create

    @speciality = Speciality.new(params[:speciality])

    respond_to do |format|
      if @speciality.save
        format.html { redirect_to @speciality, :notice => 'Speciality was successfully created.' }
        format.json { render :json => @speciality, :status => :created, :location => @speciality }
      else
        format.html { render :action => "new" }
        format.json { render :json => @speciality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /specialities/1
  # PUT /specialities/1.json
  def update
    @speciality = Speciality.find(params[:id])

    if params[:freeze].present? and params[:token].present? and (not @speciality.nil?)
      @token = Token.where("Value = ?", params[:token]).first
      @entry = Entry.where(:id => params[:freeze])

      if (not @token.nil?) and (not @entry.size == 0)
        @user = @token.user
        if is_admin(@user)
          @speciality.FreezedEntry = params[:freeze]
        end
      end
    end

    respond_to do |format|
      if @speciality.update_attributes(params[:speciality])
        format.html { redirect_to @speciality, notice: 'Speciality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @speciality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /specialities/1
  # DELETE /specialities/1.json
  def destroy
    @speciality = Speciality.find(params[:id])
    @speciality.destroy

    respond_to do |format|
      format.html { redirect_to specialities_url }
      format.json { head :no_content }
    end
  end

  def freeze

    @theparameters = JSON.parse(request.raw_post)
    @token = Token.where(:Value => @theparameters.fetch("token")).first
    @result = Hash.new
    if is_admin(@token.user)
      if @theparameters.keys.include?("map")
        @map = @theparameters.fetch("map")
        @map.each do |pair|
          @speciality_id = pair["speciality_id"]
          @entry_id = pair["entry_id"]

          @speciality = Speciality.find(@speciality_id)
          @speciality.FreezedEntry = @entry_id
          @speciality.save

          @nominated_entries = []
          @speciality.entries.each do |ne|
            if ne.id == @entry_id
              @nominatedcar = Hash.new
              @nominatedcar["entry"] = ne
              @nominatedcar["freezed"] = true
              @nominated_entries.push @nominatedcar
            else
              @nominatedcar = Hash.new
              @nominatedcar["entry"] = ne
              @nominatedcar["freezed"] = false
              @nominated_entries.push @nominatedcar
            end
          end
          @result[@speciality.Type] = @nominated_entries

        end


        render :json => @result

      else
        render :json => {error:"couldn't find required parameters"}, :status => :bad_request
      end
    else
      render :json => {error:"permission denied"}, :status => :bad_request
    end
  end
  
  private
  def is_admin(current_user)
    @roles = current_user.roles
    @roles_ids = Array.new
    if not @roles.nil?
      @roles.each do |r|
        @roles_ids.push(r.id)
      end
    end
    return @roles_ids.include?(1) || @roles_ids.include?(2)
  end

  def getSpecialityEvents(event_id)
    @event_specialities = EventSpeciality.where("event_id = ?",event_id)
    @specialities_ids = Array.new
    @event_specialities.each do |es|
      @specialities_ids.push(es.speciality_id)
    end
    return @specialities_ids
  end
end
