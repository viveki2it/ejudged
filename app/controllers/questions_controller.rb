class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    
    @questions = Question.all

    if not ((request.format == "json") and (not params[:page].present?))
      @questions = Kaminari.paginate_array(@questions).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create

    if (not params[:question][:question_type_id].nil?) and (not params[:question][:question_category_id].nil?) and (not params[:question][:judge_sheet_id].nil?)
      @question_category = QuestionCategory.find(params[:question][:question_category_id])
      @judge_sheet = JudgeSheet.find(params[:question][:judge_sheet_id])
      @question_type = QuestionType.find(params[:question][:question_type_id])
      @question = @question_category.questions.create(params[:question])
      @question.judge_sheet = @judge_sheet
      @question.question_type = @question_type

    elsif (not params[:question][:question_category_id].nil?) and (not params[:question][:judge_sheet_id].nil?)
      @question_category = QuestionCategory.find(params[:question][:question_category_id])
      @judge_sheet = JudgeSheet.find(params[:question][:judge_sheet_id])
      @question = @question_category.questions.create(params[:question])
      @question.judge_sheet = @judge_sheet
    
    elsif (not params[:question_category_id].nil?) and (not params[:question][:judge_sheet_id].nil?)
      @question_category = QuestionCategory.find(params[:question_category_id])
      @judge_sheet = JudgeSheet.find(params[:question][:judge_sheet_id])
      @question = @question_category.questions.create(params[:question])
      @question.judge_sheet = @judge_sheet

    elsif (not params[:question][:question_category_id].nil?) and (not params[:judge_sheet_id].nil?)
      @question_category = QuestionCategory.find(params[:question][:question_category_id])
      @judge_sheet = JudgeSheet.find(params[:judge_sheet_id])
      @question = @question_category.questions.create(params[:question])
      @question.judge_sheet = @judge_sheet

    elsif not params[:judge_sheet_id].nil?
      @judge_sheet = JudgeSheet.find(params[:judge_sheet_id])
      @question = @judge_sheet.questions.create(params[:question])

    elsif not params[:question][:judge_sheet_id].nil?
      @judge_sheet = JudgeSheet.find(params[:question][:judge_sheet_id])
      @question = @judge_sheet.questions.create(params[:question])

    elsif not params[:question_category_id].nil?
      @question_category = QuestionCategory.find(params[:question_category_id])
      @question = @question_category.questions.create(params[:question])

    elsif not params[:question][:question_category_id].nil?
      @question_category = QuestionCategory.find(params[:question][:question_category_id])
      @question = @question_category.questions.create(params[:question])

    elsif not params[:question_type_id].nil?
      @question_type = QuestionType.find(params[:question_type_id])
      @question = @question_type.questions.create(params[:question])

    elsif not params[:question][:question_type_id].nil?
      @question_type = QuestionType.find(params[:question][:question_type_id])
      @question = @question_type.questions.create(params[:question])

    else
      @question = Question.new(params[:question])

    end

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, :notice => 'Question was successfully created.' }
        format.json { render :json => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update

    @question = Question.find(params[:id])

    if not params[:question][:question_category_id].nil?
      @question_category = QuestionCategory.find(params[:question][:question_category_id])
      @question.question_category = @question_category
    end

    if not params[:question][:judge_sheet_id].nil?
      @judge_sheet = JudgeSheet.find(params[:question][:judge_sheet_id])
      @question.judge_sheet = @judge_sheet
    end

    if not params[:question][:question_type_id].nil?
      @question_type = QuestionType.find(params[:question][:question_type_id])
      @question.question_type = @question_type
    end

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, :notice => 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
