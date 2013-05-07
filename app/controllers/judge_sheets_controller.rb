class JudgeSheetsController < ApplicationController
  # GET /judge_sheets
  # GET /judge_sheets.json
  def index

    @judge_sheets = JudgeSheet.all

    if not ((request.format == "json") and (not params[:page].present?))
      @judge_sheets = Kaminari.paginate_array(@judge_sheets).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @judge_sheets }
    end
  end

  # GET /judge_sheets/1
  # GET /judge_sheets/1.json
  def show
    @judge_sheet = JudgeSheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @judge_sheet }
    end
  end

  # GET /judge_sheets/new
  # GET /judge_sheets/new.json
  def new
    @judge_sheet = JudgeSheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @judge_sheet }
    end
  end

  # GET /judge_sheets/1/edit
  def edit
    @judge_sheet = JudgeSheet.find(params[:id])
  end

  # POST /judge_sheets
  # POST /judge_sheets.json
  def create
    @judge_sheet = JudgeSheet.new(params[:judge_sheet])

    respond_to do |format|
      if @judge_sheet.save
        format.html { redirect_to @judge_sheet, :notice => 'Judge sheet was successfully created.' }
        format.json { render :json => @judge_sheet, :status => :created, :location => @judge_sheet }
      else
        format.html { render :action => "new" }
        format.json { render :json => @judge_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /judge_sheets/1
  # PUT /judge_sheets/1.json
  def update
    @judge_sheet = JudgeSheet.find(params[:id])

    respond_to do |format|
      if @judge_sheet.update_attributes(params[:judge_sheet])
        format.html { redirect_to @judge_sheet, :notice => 'Judge sheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @judge_sheet.errors, :status=> :unprocessable_entity }
      end
    end
  end

  # DELETE /judge_sheets/1
  # DELETE /judge_sheets/1.json
  def destroy
    @judge_sheet = JudgeSheet.find(params[:id])
    @judge_sheet.destroy

    respond_to do |format|
      format.html { redirect_to judge_sheets_url }
      format.json { head :no_content }
    end
  end
end
