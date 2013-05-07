class QuestionCategoriesController < ApplicationController
  # GET /question_categories
  # GET /question_categories.json
  def index
    @question_categories = QuestionCategory.order("position_number")

    if not ((request.format == "json") and (not params[:page].present?))
      @question_categories = Kaminari.paginate_array(@question_categories).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @question_categories }
    end
  end

  # GET /question_categories/1
  # GET /question_categories/1.json
  def show
    @question_category = QuestionCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question_category }
    end
  end

  # GET /question_categories/new
  # GET /question_categories/new.json
  def new
    @question_category = QuestionCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question_category }
    end
  end

  # GET /question_categories/1/edit
  def edit
    @question_category = QuestionCategory.find(params[:id])
  end

  # POST /question_categories
  # POST /question_categories.json
  def create
    @question_category = QuestionCategory.new(params[:question_category])

    if @question_category.position_number.nil?
       @order = QuestionCategory.order("position_number")
       if @order != nil
          @last = @order.last.position_number + 1
       else
          @last = 1
       end
       @question_category.position_number = @last
    end

    respond_to do |format|
      if @question_category.save
        format.html { redirect_to @question_category, notice: 'Question category was successfully created.' }
        format.json { render json: @question_category, status: :created, location: @question_category }
      else
        format.html { render action: "new" }
        format.json { render json: @question_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /question_categories/1
  # PUT /question_categories/1.json
  def update
    @question_category = QuestionCategory.find(params[:id])

    respond_to do |format|
      if @question_category.update_attributes(params[:question_category])
        format.html { redirect_to @question_category, notice: 'Question category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /question_categories/1
  # DELETE /question_categories/1.json
  def destroy
    @question_category = QuestionCategory.find(params[:id])
    @question_category.destroy

    respond_to do |format|
      format.html { redirect_to question_categories_url }
      format.json { head :no_content }
    end
  end
end
