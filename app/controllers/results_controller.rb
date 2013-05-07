class ResultsController < ApplicationController
  # GET /results
  # GET /results.json
  def index

    @results = Result.all

    if not ((request.format == "json") and (not params[:page].present?))
      @results = Kaminari.paginate_array(@results).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @result }
    end
  end

  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @result }
    end
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
  end

  # POST /results
  # POST /results.json
  def create

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    completed = false

    if (not params[:result][:entry_id].nil?) and (not params[:result][:question_id].nil?)
      @entry = Entry.find(params[:result][:entry_id])
      @question = Question.find(params[:result][:question_id])
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result = Result.new(params[:result])
        @result.question = @question
        @result.user = @user
        @result.entry = @entry
      end

    elsif (not params[:entry_id].nil?) and (not params[:result][:question_id].nil?)
      @entry = Entry.find(params[:entry_id])
      @question = Question.find(params[:result][:question_id])
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result = Result.new(params[:result])
        @result.question = @question
        @result.user = @user
        @result.entry = @entry
      end

    elsif not params[:result][:question_id].nil?
      @result = Result.new(params[:result])
      @question = Question.find(params[:result][:question_id])
      @result.question = @question
      @result.user = @user

    elsif not params[:question_id].nil?
      @result = Result.new(params[:result])
      @question = Question.find(params[:question_id])  
      @result.question = @question
      @result.user = @user     

    elsif not params[:result][:entry_id].nil?
      @entry = Entry.find(params[:result][:entry_id])
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result = Result.new(params[:result])
        @result.entry = @entry
        @result.user = @user
      end

    elsif not params[:entry_id].nil?
      @entry = Entry.find(params[:entry_id])
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result = @entry.results.create(params[:result])
        @result.user = @user     
      end

    else
      @result = Result.new(params[:result])
      @result.user = @user

    end

    respond_to do |format|
      if not completed
        if @result.save
          if (not @entry.nil?)
            @entry.Score = TotalScore(@entry.id)
            @entry.save
          end
          format.html { redirect_to @result, notice: 'Result was successfully created.' }
          format.json { render :json => @result, :status => :created, :location => @result }
        else
          format.html { render :action => "new" }
          format.json { render :json => @result.errors, :status => :unprocessable_entity }
        end
      else
        format.html { redirect_to :back }
        format.json { render :json => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.json
  def update
    @entry = nil
    @result = Result.find(params[:id])
    completed = false

    if not params[:result][:entry_id].nil?
      @entry = Entry.find(params[:result][:entry_id])
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result.entry = @entry
      end
    end

    if not params[:result][:question_id].nil?
      @question = Question.find(params[:result][:question_id])
      @entry = @result.entry
      if not @entry.nil?
        @contest = @entry.contest
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
      end
      if not completed
        @result.question = @question
      end
    end

    respond_to do |format|
      if not completed
        if @result.update_attributes(params[:result])
          if (not @entry.nil?)
            @entry.Score = TotalScore(@entry.id)
            @entry.save
          end
          format.html { redirect_to @result, :notice => 'Result was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit"}
          format.json { render :json => @result.errors, :status => :unprocessable_entity }
        end  
      else
        format.html { render :action => "edit"}
        format.json { render :json => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @entry = @result.entry
    @result.destroy
    if not @entry.nil?
      @entry.Score = TotalScore(@entry.id)
      @entry.save
    end

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end


  private
  def TotalScore (entryId)
    @results = Result.where("entry_id = ?", entryId)
    @total = 0
    @results.each do |r|
      if r.Value != nil
        @total = @total + r.Value
      end
    end
    return @total
  end
  
end