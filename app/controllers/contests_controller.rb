class ContestsController < ApplicationController
  # GET /contests
  # GET /contests.json
  def index

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end

    if params[:filter].present? and params[:event_id].present? and params[:page].present?
      @contests = Contest.where("ContestName LIKE ? and event_id = ?", "%#{params[:filter]}%", params[:event_id]).page(params[:page]).per(10)

    elsif params[:filter].present? and params[:event_id].present?
      @contests = Contest.where("ContestName LIKE ? and event_id = ?","%#{params[:filter]}%", params[:event_id])

    elsif params[:filter].present? and params[:page].present?
      @contests = Contest.where("ContestName LIKE ?", "%#{params[:filter]}%").page(params[:page]).per(10)

    elsif params[:event_id].present? and params[:page].present?
      @contests = Contest.where("event_id = ?", params[:event_id]).page(params[:page]).per(10)
      
    elsif params[:event_id].present?
      @contests = Contest.where("event_id = ?", params[:event_id])

    elsif params[:filter].present?
      @contests = Contest.where("ContestName LIKE ?", "%#{params[:filter]}%")

    elsif params[:page].present?
      @contests = Contest.page(params[:page]).per(10)

    else
      if is_admin(@user)
        @contests = Contest.all
      else
        @contests = Contest.where("id IN(?)", getUserContest(@user))
      end
      
    end

    if not params[:page].present? #comes from web or json and already paginate array, don't paginate again
      if not ((request.format == "json") and (not params[:page].present?)) #comes from web and ask for index then paginate array
        @contests = Kaminari.paginate_array(@contests).page(params[:page]).per(10)
      end
    end
      

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contests }
    end
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @contest = Contest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @contest }
    end
  end

  # GET /contests/new
  # GET /contests/new.json
  def new
    @contest = Contest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @contest }
    end
  end

  # GET /contests/1/edit
  def edit
    @contest = Contest.find(params[:id])
  end

  # POST /contests
  # POST /contests.json
  def create

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    create_contest_ok = is_admin_or_event_manager(@user)

    if create_contest_ok

      if (not params[:contest][:category_id].nil?) and (not params[:contest][:event_id].nil?) and (not params[:contest][:judge_sheet_id].nil?)
        @category = Category.find(params[:contest][:category_id])
        @event = Event.find(params[:contest][:event_id])
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @category.contests.create(params[:contest])
        @contest.event = @event
        @contest.judge_sheet = @judge_sheet

      elsif (not params[:contest][:category_id].nil?) and (not params[:event_id].nil?) and (not params[:contest][:judge_sheet_id].nil?)
        @category = Category.find(params[:contest][:category_id])
        @event = Event.find(params[:event_id])
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @category.contests.create(params[:contest])
        @contest.event = @event
        @contest.judge_sheet = @judge_sheet

      elsif (not params[:category_id].nil?) and (not params[:contest][:event_id].nil?) and (not params[:contest][:judge_sheet_id].nil?)
        @category = Category.find(params[:category_id])
        @event = Event.find(params[:contest][:event_id])
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @category.contests.create(params[:contest])
        @contest.event = @event
        @contest.judge_sheet = @judge_sheet

      elsif (not params[:contest][:category_id].nil?) and (not params[:contest][:event_id].nil?)
        @category = Category.find(params[:contest][:category_id])
        @event = Event.find(params[:contest][:event_id])
        @contest = @category.contests.create(params[:contest])
        @contest.event = @event

      elsif (not params[:contest][:category_id].nil?) and (not params[:contest][:judge_sheet_id].nil?)
        @category = Category.find(params[:contest][:category_id])
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @category.contests.create(params[:contest])
        @contest.judge_sheet = @judge_sheet

      elsif (not params[:contest][:event_id].nil?) and (not params[:contest][:judge_sheet_id].nil?)
        @event = Event.find(params[:contest][:event_id])
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @event.contests.create(params[:contest])
        @contest.judge_sheet = @judge_sheet

      elsif not params[:judge_sheet_id].nil?
        @judge_sheet = JudgeSheet.find(params[:judge_sheet_id])
        @contest = @judge_sheet.contests.create(params[:contest])

      elsif not params[:contest][:judge_sheet_id].nil?
        @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
        @contest = @judge_sheet.contests.create(params[:contest])

      elsif not params[:category_id].nil?
        @category = Category.find(params[:category_id])
        @contest = @category.contests.create(params[:contest])

      elsif not params[:contest][:category_id].nil?
        @category = Category.find(params[:contest][:category_id])
        @contest = @category.contests.create(params[:contest])

      elsif not params[:event_id].nil?
        @event = Event.find(params[:event_id])
        @contest = @event.contests.create(params[:contest])

      elsif not params[:contest][:event_id].nil?
        @event = Event.find(params[:contest][:event_id])
        @contest = @event.contests.create(params[:contest])

      else
        @contest = Contest.new(params[:contest])

      end
    end


    respond_to do |format|
      if create_contest_ok
        if @contest.save
          format.html { redirect_to @contest, :notice => 'Contest was successfully created.' }
          format.json { render :json => @contest, :status => :created, :location => @contest }
        else
          format.html { render :action => "new" }
          format.json { render :json => @contest.errors, :status => :unprocessable_entity }  
        end
      else
        format.html { redirect_to :back }
        format.json { render :json => @contest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contests/1
  # PUT /contests/1.json
  def update

    @contest = Contest.find(params[:id])

    if not params[:contest][:category_id].nil?
      @category = Category.find(params[:contest][:category_id])
      @contest.category = @category
    end

    if not params[:contest][:event_id].nil?
      @event = Event.find(params[:contest][:event_id])
      @contest.event = @event
    end

    if not params[:contest][:judge_sheet_id].nil?
      @judge_sheet = JudgeSheet.find(params[:contest][:judge_sheet_id])
      @contest.judge_sheet = @judge_sheet
    end

    respond_to do |format|
      if @contest.update_attributes(params[:contest])
        format.html { redirect_to @contest, :notice => 'Contest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @contest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest = Contest.find(params[:id])
    @contest.destroy

    respond_to do |format|
      format.html { redirect_to contests_url }
      format.json { head :no_content }
    end
  end

  private
  def is_admin_or_event_manager(current_user)
    return not((current_user.roles & Role.find([1, 2])).empty?)
  end

  def is_admin(current_user)
    @roles = current_user.roles
    @roles_ids = Array.new
    if not @roles.nil?
      @roles.each do |r|
        @roles_ids.push(r.id)
      end
    end
    return @roles_ids.include?(1)
  end

  def getUserContest(current_user)
    @events = current_user.events
    @contests = Array.new
    if @events != nil
      @events.each do |e|
        @event_contests = e.contests
        if @event_contests != nil
          @event_contests.each do |ec|
            @contests.push(ec.id)
          end
        end
      end
    end
    return @contests
  end

end
