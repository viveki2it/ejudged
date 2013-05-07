class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end

    if (params[:type].present? and params[:type] == "speciality") and params[:filter].present? and params[:serie_id].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?)", "%#{params[:filter]}%", params[:serie_id], has_speciality()).page(params[:page]).per(10)
      else
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", params[:serie_id], get_user_events(@user), has_speciality()).page(params[:page]).per(10)
      end

    elsif params[:filter].present? and params[:serie_id].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and serie_id = ?", "%#{params[:filter]}%", params[:serie_id]).page(params[:page]).per(10)
      else
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?)", "%#{params[:filter]}%", params[:serie_id], get_user_events(@user)).page(params[:page]).per(10)
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:serie_id].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("serie_id = ? and id IN(?)", params[:serie_id], has_speciality()).page(params[:page]).per(10)
      else
        @events = Event.where("serie_id = ? and id IN(?) and id IN(?)", params[:serie_id], get_user_events(@user), has_speciality()).page(params[:page]).per(10)
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:filter].present? and params[:serie_id].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?)", "%#{params[:filter]}%", params[:serie_id], has_speciality())
      else
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", params[:serie_id], get_user_events(@user), has_speciality())
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:filter].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and id IN(?)", "%#{params[:filter]}%").page(params[:page], has_speciality()).per(10)
      else
        @events = Event.where("EventName LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", get_user_events(@user), has_speciality()).page(params[:page]).per(10)
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:serie_id].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("serie_id = ? and id IN(?)", params[:serie_id], has_speciality())
      else
        @events = Event.where("serie_id = ? and id IN(?) and id IN(?)", params[:serie_id], get_user_events(@user), has_speciality())
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("id IN(?)", has_speciality()).page(params[:page]).per(10)
      else
        @events = Event.where("id IN(?) and id IN(?)", get_user_events(@user), has_speciality()).page(params[:page]).per(10)
      end

    elsif (params[:type].present? and params[:type] == "speciality") and params[:filter].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and id IN(?)", "%#{params[:filter]}%", has_speciality())
      else
        @events = Event.where("EventName LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", get_user_events(@user), has_speciality())
      end

    elsif params[:serie_id].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("serie_id = ?", params[:serie_id]).page(params[:page]).per(10)
      else
        @events = Event.where("serie_id = ? and id IN(?)", params[:serie_id], get_user_events(@user)).page(params[:page]).per(10)
      end

    elsif params[:filter].present? and params[:serie_id].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and serie_id = ?", "%#{params[:filter]}%", params[:serie_id])
      else
        @events = Event.where("EventName LIKE ? and serie_id = ? and id IN(?)", "%#{params[:filter]}%", params[:serie_id], get_user_events(@user))
      end

    elsif params[:filter].present? and params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ?", "%#{params[:filter]}%").page(params[:page]).per(10)
      else
        @events = Event.where("EventName LIKE ? and id IN(?)", "%#{params[:filter]}%", get_user_events(@user)).page(params[:page]).per(10)
      end

    elsif params[:serie_id].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("serie_id = ?", params[:serie_id])
      else
        @events = Event.where("serie_id = ? and id IN(?)", params[:serie_id], get_user_events(@user))
      end
      
    elsif params[:page].present?
      if is_admin_or_event_manager(@user)
        @events = Event.page(params[:page]).per(10)
      else
        @events = Event.where("id IN(?)", get_user_events(@user)).page(params[:page]).per(10)
      end

    elsif params[:filter].present?
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ?", "%#{params[:filter]}%")
      else
        @events = Event.where("EventName LIKE ? and id IN(?)", "%#{params[:filter]}%", get_user_events(@user))
      end

    elsif params[:type].present? and params[:type] == "speciality"
      if is_admin_or_event_manager(@user)
        @events = Event.where("EventName LIKE ? and id IN(?)", "%#{params[:filter]}%", has_speciality())
      else
        @events = Event.where("EventName LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", get_user_events(@user), has_speciality())
      end

    else
      if is_admin_or_event_manager(@user)
        @events = Event.all 
      else
        @events = Event.where("id IN (?)", get_user_events(@user)) 
      end
    end

    if not params[:page].present? #comes from web or json and already paginate array, don't paginate again
      if not ((request.format == "json") and (not params[:page].present?)) #comes from web and ask for index then paginate array
        @events = Kaminari.paginate_array(@events).page(params[:page]).per(10)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @series = @event.serie
  end

  # POST /events
  # POST /events.json
  def create
    if not params[:serie_id].nil?
      @serie = Serie.find(params[:serie_id])
      @event = @serie.events.create(params[:event])

    elsif not params[:event][:serie_id].nil?
      @serie = Serie.find(params[:event][:serie_id])
      @event = @serie.events.create(params[:event])

    else
      @event = Event.new(params[:event])

    end

    respond_to do |format|
      if @event.save
        serie_complete(@event.serie)
        format.html { redirect_to @event, :notice => "Event was successfully created." }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    @serie_before = @event.serie
    @serie_change = false

    if not params[:event][:serie_id].nil?
      @serie = Serie.find(params[:event][:serie_id])
      if @serie.id != @serie_before.id
        @serie_change = true
      end
      @event.serie = @serie
    end

    if not params[:event][:speciality_ids].nil?
        @event_specialities = @event.event_specialities
        @event_specialities.each do |es|
          es.delete
        end
        params[:event][:speciality_ids].each do |specialityId|
          if not specialityId.empty?
            @speciality = Speciality.find(specialityId)
            @event_speciality = EventSpeciality.new(:speciality_id => specialityId, :event_id => @event.id)
            @event.event_specialities.push(@event_speciality)
            @speciality.event_specialities.push(@event_speciality)
            @speciality.save
          end
        end
      end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        #checking if series are now completed
        serie_complete(@serie_before)
        if @serie_change
          serie_complete(@serie)
        end
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @serie_before = @event.serie
    @event.destroy
    serie_complete(@serie_before)

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
  def is_admin_or_event_manager(current_user)
    return not((current_user.roles & Role.find([1, 2])).empty?)
  end

  def get_user_events(current_user)
    @events = Array.new   
    @user_events = current_user.events

    if not @user_events.nil?
      @user_events.each do |ue|
        @events.push(ue.id)
      end
    end
    return @events
  end

  def has_speciality
    @sp = EntrySpeciality.select("event_id")
    @result = Array.new
    @sp.each do |s| 
      @result.push(s.event_id)
    end
    return @result
  end

  def serie_complete(serie)
    if not serie.nil?
      @serie_events = serie.events
      @completed = (Event.where("serie_id = ? and Completed = true", serie.id).size == @serie_events.size) 
      if @completed
        serie.Completed = true
        serie.save
      else
        serie.Completed = false
        serie.save
      end
    end
  end
end
