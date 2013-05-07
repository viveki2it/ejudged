class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  def index

    @categories = Category.all
    if not ((request.format == "json") and (not params[:page].present?))
      @categories = Kaminari.paginate_array(@categories).page(params[:page]).per(10)
    end

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end

    if params[:event_id].present? and params[:filter].present? and params[:type].present? and params[:type] == "none"
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("ContestName LIKE ? and category_id = ? and event_id = ?", "%#{params[:filter]}%", c.id, params[:event_id])]}
      else
        @cats = @categories.map { |c| [c, Contest.where("ContestName LIKE ? and category_id = ? and event_id = ? and event_id IN(?)", "%#{params[:filter]}%", c.id, params[:event_id], get_user_events(@user))]}
      end

    elsif params[:filter].present? and params[:type].present? and params[:type] == "none"
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("ContestName LIKE ? and category_id = ?", "%#{params[:filter]}%", c.id)]}
      else
        @cats = @categories.map { |c| [c, Contest.where("ContestName LIKE ? and category_id = ? and event_id IN(?)", "%#{params[:filter]}%", c.id, get_user_events(@user))]}
      end

    elsif params[:event_id].present? and params[:type].present? and params[:type] == "none"
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id = ?", c.id, params[:event_id])]}
      else
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id = ? and event_id IN(?)", c.id, params[:event_id], get_user_events(@user))]}
      end

    elsif params[:event_id].present? and params[:type].present? and params[:type] == "score" 
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id = ?", c.id, params[:event_id]).map {|e| [e, Entry.where("contest_id = ? and id IN(?)", e.id, topfive(e.id)).order("Score DESC")] } ]} 
      else
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id = ? and event_id IN(?)", c.id, params[:event_id], get_user_events(@user)).map {|e| [e, Entry.where("contest_id = ? and id IN(?)", e.id, topfive(e.id)).order("Score DESC")] } ]} 
      end

    elsif params[:type].present? and params[:type] == "none"
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("category_id = ?", c.id)]} 
      else
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id IN(?)", c.id, get_user_events(@user))]} 
      end

    elsif params[:type].present? and params[:type] == "score"
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? ", c.id).map {|e| [e, Entry.where("contest_id = ? and id IN(?)", e.id, topfive(e.id)).order("Score DESC")] } ]} 
      else
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id IN(?)", c.id, get_user_events(@user)).map {|e| [e, Entry.where("contest_id = ? and id IN(?)", e.id, topfive(e.id)).order("Score DESC")] } ]} 
      end

    else
      if is_admin_or_event_manager(@user)
        @cats = @categories.map { |c| [c, Contest.where("category_id = ?", c.id)]} 
      else
        @cats = @categories.map { |c| [c, Contest.where("category_id = ? and event_id IN(?)", c.id, get_user_events(@user))]} 
      end

    end 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cats }
    end

  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, :notice => 'Category was successfully created.' }
        format.json { render :json => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.json { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, :notice => 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
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

  def topfive(contest_id)
    @entries = Entry.where("contest_id = ?", contest_id).order("Score DESC")
    @entry_top = Array.new
    if @entries.size > 5
      @entries_aux = Array.new
      @entries_aux = @entries
      @ok = false
      @size = @entries_aux.size
      @limit = 4
      #check if there's a tie between the fifth entry and the rest of the entries
      while (@limit < @size -1) and !@ok
        @ok = @entries_aux[@limit].Score != @entries_aux[@limit +1].Score
        @limit = @limit + 1
      end
      if @ok
        @limit = @limit - 1
        while(@limit < @size-1)
          @entries_aux.pop
          @limit = @limit + 1
        end
      end

      @entries = @entries_aux
    end
     @entries.each do |e|
       @entry_top.push(e.id)
     end
    return @entry_top 
  end

end
