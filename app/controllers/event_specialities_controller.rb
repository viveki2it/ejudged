class EventSpecialitiesController < ApplicationController

  def index

    @event_specialities = EventSpeciality.all

    if not ((request.format == "json") and (not params[:page].present?))
      @event_specialities = Kaminari.paginate_array(@event_specialities).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @event_specialities }
    end
  end

  def show
    @event_speciality = EventSpeciality.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event_speciality }
    end
  end


  def new
    @event_speciality = EventSpeciality.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event_speciality }
    end
  end

  def edit
    @event_speciality = EventSpeciality.find(params[:id])
  end

  def create

    @event_speciality = EventSpeciality.new(params[:event_speciality])

    respond_to do |format|
        if @club.save
          format.html { redirect_to @event_speciality, :notice => 'Event-Speciality was successfully created.' }
          format.json { render :json => @event_speciality, :status => :created, :location => @event_speciality }
        else
          format.html { render :action => "new" }
          format.json { render :json => @event_speciality.errors, :status => :unprocessable_entity }  
        end
    end
  end


  def update
    @event_speciality = EventSpeciality.find(params[:id])

    respond_to do |format|
      if @event_speciality.update_attributes(params[:event_speciality])
        format.html { redirect_to @event_speciality, :notice => 'Freezing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event_speciality.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event_speciality = EventSpeciality.find(params[:id])
    @event_speciality.destroy

    respond_to do |format|
      format.html { redirect_to event_specialities_url }
      format.json { head :no_content }
    end
  end

end

