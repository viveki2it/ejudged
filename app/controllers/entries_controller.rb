class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end

    if params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
        end

      else
          @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("Score DESC").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("customer_id").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("customer_id").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("customer_id").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("RegistrationNumber").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("RegistrationNumber").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("RegistrationNumber").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:filter].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:contest_id].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_entry_specialities(params[:speciality_id])).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:contest_id].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], @entry_results, get_user_entries(@user)).order("Score DESC")
        end

      else
          @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("customer_id")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id")
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("customer_id")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")     
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")     
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("RegistrationNumber")     
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("RegistrationNumber")     
      end

    elsif params[:speciality_id].present? and params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC")      
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")      
      end


    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif (params[:type].present? and params[:type] == "mine") and params[:filter].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("Score DESC").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("customer_id").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("customer_id").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("customer_id").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("RegistrationNumber").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("RegistrationNumber").page(params[:page]).per(8)
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("RegistrationNumber").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:contest_id].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        end
      else
        @entries = []
      end
      ###############################changed#################################
    elsif (params[:type].present? and params[:type] == "mine") and params[:contest_id].present? and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("contest_id = ? ", params[:contest_id]).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
        end
      else
        @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC").page(params[:page]).per(8)
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).order("Score DESC").page(params[:page]).per(8)
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).order("Score DESC").page(params[:page]).per(8)
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("customer_id")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("customer_id")
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).page(params[:page]).per(8).order("customer_id")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).page(params[:page]).per(8).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("RegistrationNumber")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("RegistrationNumber")
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).page(params[:page]).per(8).order("RegistrationNumber")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).page(params[:page]).per(8).order("RegistrationNumber")
      end

    elsif params[:speciality_id].present? and params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:contest_id].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_entry_specialities(params[:speciality_id])).order("Score DESC")
        else
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
        end
      else
        @entries = []
      end

    elsif (params[:type].present? and params[:type] == "mine") and params[:contest_id].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("contest_id = ? and (id IN(?))", params[:contest_id], @entry_results).order("Score DESC")
        else
          @entries = Entry.where("contest_id = ? and (id IN(?)) and (id IN(?))", params[:contest_id], @entry_results, get_user_entries(@user)).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("customer_id")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id")
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).order("customer_id")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).order("RegistrationNumber")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).order("RegistrationNumber")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:filter].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_entry_specialities(params[:speciality_id])).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif (params[:type].present? and params[:type] == "mine") and params[:filter].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results).order("Score DESC")
        else
          @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and (id IN(?)) and (id IN(?))", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", @entry_results, get_user_entries(@user)).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("Score DESC")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("customer_id")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id")
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("customer_id")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine") and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("id IN(?) and id IN(?)", @entry_results, get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("id IN(?) and id IN(?) and id IN(?)", @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
        end
      else
          @entries = []
      end

     elsif (params[:order].present? and params[:order] == "reg") and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("RegistrationNumber")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("RegistrationNumber")
      end

     elsif params[:filter].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:speciality_id].present? and params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?) and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end


    elsif params[:filter].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id]).order("Score DESC")      
      else
        @entries = Entry.where("(Model LIKE ? or Make LIKE ? or Year LIKE ?) and contest_id = ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", params[:contest_id], get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present? and params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?) and id IN(?)", params[:contest_id], get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    elsif params[:speciality_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      end


    elsif (params[:type].present? and params[:type] == "mine") and params[:page].present?
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("id IN(?)", @entry_results).page(params[:page]).per(8).order("Score DESC")
        else
          @entries = Entry.where("id IN(?) and id IN(?)", @entry_results, get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
        end
      else
        @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "score") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("customer_id")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("customer_id")
      end

    elsif params[:contest_id].present? and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "owner") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.page(params[:page]).per(8).order("customer_id")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).page(params[:page]).per(8).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("RegistrationNumber")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).page(params[:page]).per(8).order("RegistrationNumber")
      end

    elsif (params[:order].present? and params[:order] == "reg") and params[:page].present?
      if is_admin(@user)
        @entries = Entry.page(params[:page]).per(8).order("RegistrationNumber")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).page(params[:page]).per(8).order("RegistrationNumber")
      end

    elsif params[:speciality_id].present? and (params[:type].present? and params[:type] == "mine")
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.where("id IN(?) and id IN(?)", @entry_results, get_entry_specialities(params[:speciality_id])).order("Score DESC")
        else
          @entries = Entry.where("id IN(?) and id IN(?) and id IN(?)", @entry_results, get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
        end
      else
        @entries = []
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "score")
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    elsif (params[:order].present? and params[:order] == "score")
      if is_admin(@user)
        @entries = Entry.order("Score DESC")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "owner")
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).order("customer_id")
      else
        @entries = Entry.where("id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("customer_id")
      end

    elsif (params[:order].present? and params[:order] == "owner")
      if is_admin(@user)
        @entries = Entry.order("customer_id")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).order("customer_id")
      end

    elsif params[:speciality_id].present? and (params[:order].present? and params[:order] == "reg")
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      else
        @entries = Entry.where("id IN(?) and id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("RegistrationNumber")
      end

    elsif (params[:order].present? and params[:order] == "reg")
      if is_admin(@user)
        @entries = Entry.order("RegistrationNumber")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).order("RegistrationNumber")
      end

    elsif params[:contest_id].present?
      if is_admin(@user)
        @entries = Entry.where("contest_id = ?", params[:contest_id]).order("Score DESC")
      else
        @entries = Entry.where("contest_id = ? and id IN(?)", params[:contest_id], get_user_entries(@user)).order("Score DESC")
      end

    elsif (params[:type].present? and params[:type] == "mine")
      if (not @user.nil?)
        @user_results = Result.where("user_id = ?", @user.id)
        @entry_results = Array.new
        @user_results.each do |ur|
          @entry_results.push(ur.entry_id)
        end
        if is_admin(@user)
          @entries = Entry.order("Score DESC")
        else
          @entries = Entry.where("id IN(?) and id IN(?)", @entry_results, get_user_entries(@user)).order("Score DESC")
        end
      else
          @entries = []
      end

    elsif params[:page].present?
      if is_admin(@user)
        @entries = Entry.page(params[:page]).per(8).order("Score DESC")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).page(params[:page]).per(8).order("Score DESC")
      end

    elsif params[:filter].present?
      if is_admin(@user)
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ?", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%").order("Score DESC")
      else
        @entries = Entry.where("Model LIKE ? or Make LIKE ? or Year LIKE ? and id IN(?)", "%#{params[:filter]}%", "%#{params[:filter]}%", "%#{params[:filter]}%", get_user_entries(@user)).order("Score DESC")
      end

    elsif params[:speciality_id].present?
      if is_admin(@user)
        @entries = Entry.where("id IN(?)", get_entry_specialities(params[:speciality_id])).order("Score DESC")
      else
        @entries = Entry.where("id IN(?) and id IN(?)", get_user_entries(@user), get_entry_specialities(params[:speciality_id])).order("Score DESC")
      end

    else
      if is_admin(@user)
        @entries = Entry.order("Score DESC")
      else
        @entries = Entry.where("id IN(?)", get_user_entries(@user)).order("Score DESC")
      end

    end

    if not params[:page].present? #comes from web or json and already paginate array, don't paginate again
      if not ((request.format == "json") and (not params[:page].present?)) #comes from web and ask for index then paginate array
        @entries = Kaminari.paginate_array(@entries).page(params[:page]).per(10)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @entry}
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create

    completed = false
    create_ok = false

    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    create_ok = not((@user.roles & Role.find([1, 2])).empty?)
    
    if create_ok
      if (not params[:entry][:club_id].nil?) and (not params[:entry][:customer_id].nil?) and (not params[:entry][:contest_id].nil?)
        @customer = Customer.find(params[:entry][:customer_id])
        @contest = Contest.find(params[:entry][:contest_id])
        @club = Club.find(params[:entry][:club_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
          @entry.customer = @customer
          @entry.contest = @contest
          @entry.club = @club
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif (not params[:entry][:club_id].nil?) and (not params[:entry][:customer_id].nil?) and (not params[:contest_id].nil?)
        @customer = Customer.find(params[:entry][:customer_id])
        @contest = Contest.find(params[:contest_id])
        @club = Club.find(params[:entry][:club_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
          @entry.customer = @customer
          @entry.contest = @contest
          @entry.club = @club
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif (not params[:entry][:club_id].nil?) and (not params[:customer_id].nil?) and (not params[:entry][:contest_id].nil?)
        @customer = Customer.find(params[:customer_id])
        @contest = Contest.find(params[:entry][:contest_id])
        @club = Club.find(params[:entry][:club_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
          @entry.customer = @customer
          @entry.contest = @contest
          @entry.club = @club
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif (not params[:entry][:club_id].nil?) and (not params[:entry][:customer_id].nil?)
        @customer = Customer.find(params[:entry][:customer_id])
        @club = Club.find(params[:entry][:club_id])
        @entry = Entry.new(params[:entry])
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end
        @entry.customer = @customer
        @entry.club = @club
        #@entry.user = @user
        #@entry.Created = DateTime.now

      elsif (not params[:entry][:contest_id].nil?) and (not params[:entry][:customer_id].nil?)
        @customer = Customer.find(params[:entry][:customer_id])
        @contest = Contest.find(params[:entry][:contest_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
          @entry.customer = @customer
          @entry.contest = @contest
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif (not params[:entry][:club_id].nil?) and (not params[:entry][:contest_id].nil?)
        @contest = Contest.find(params[:entry][:contest_id])
        @club = Club.find(params[:entry][:club_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
          @entry.contest = @contest
          @entry.club = @club
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif not params[:club_id].nil?
        @club = Club.find(params[:club_id])
        @entry = Entry.new(params[:entry])
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end
        @entry.club = @club
        #@entry.user = @user

      elsif not params[:entry][:club_id].nil?
        @club = Club.find(params[:entry][:club_id])
        @entry = Entry.new(params[:entry])
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end
        @entry.club = @club
        #@entry.user = @user
        #@entry.Created = DateTime.now

      elsif not params[:customer_id].nil?
        @customer = Customer.find(params[:customer_id])
        @entry = Entry.new(params[:entry])
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end
        @entry.customer = @customer
        #@entry.user = @user
        #@entry.Created = DateTime.now

      elsif not params[:entry][:customer_id].nil?
        @customer = Customer.find(params[:entry][:customer_id])
        @entry = Entry.new(params[:entry])
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end
        @entry.customer = @customer
        #@entry.user = @user
        #@entry.Created = DateTime.now

      elsif not params[:contest_id].nil?
        @contest = Contest.find(params[:contest_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          @entry.contest = @contest
          #@entry.user = @user
          #@entry.Created = DateTime.now
        end

      elsif not params[:entry][:contest_id].nil?
        @contest = Contest.find(params[:entry][:contest_id])
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry = Entry.new(params[:entry])
          @entry.contest = @contest
          #@entry.user = @user
          #@entry.Created = DateTime.now
          if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
          end
        end

      else
        @entry = Entry.new(params[:entry])
        #@entry.user = @user
        #@entry.Created = DateTime.now
        if params[:entry][:photo].present?
            @photo = Photo.new(:photo => params[:entry][:photo])
            @photo.save
            @entry.photos.push(@photo)
        end

      end

    end #end if create_ok


    respond_to do |format|
      if (not completed) and create_ok
        if @entry.save
          format.html { redirect_to @entry, :notice => 'Entry was successfully created.' }
          format.json { render :json => @entry, :status => :created, :location => @entry }
        else
          format.html { render :action => "new" }
          format.json { render :json => @entry.errors, :status => :unprocessable_entity }
        end
      else
        format.html { redirect_to :back, :notice => 'Entry can not be created' }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update

    @entry = Entry.find(params[:id])

    #check user's permission
    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    @cont = @entry.contest
    upload_ok = false
    admin_or_event_manager = false
    completed = false

    if (@user.roles & Role.find([1, 2])).empty?
      if not @cont.nil?
         @ev = @cont.event
         if not @ev.nil?
           upload_ok = UserEvent.where("user_id = ? and event_id = ?", @user.id, @ev.id).size > 0
         end
      end
    else
      upload_ok = true
      admin_or_event_manager = true
    end 

    @contest = @entry.contest
    if not @contest.nil?
        @event = @contest.event
        if not @event.nil?
          completed = @event.Completed
        end
    end

    #if event for this entry is complete, entry locked.
    #if user haven't permission for update the entry, entry locked.
    if (not completed) and (upload_ok or admin_or_event_manager)
      
      if not params[:entry][:speciality_ids].nil?
        @entry_specialities = @entry.entry_specialities
        @entry_specialities.each do |es|
          es.delete
        end
        params[:entry][:speciality_ids].each do |specialityId|
          if not specialityId.empty?
            @speciality = Speciality.find(specialityId)
            @entry_speciality = EntrySpeciality.new(:speciality_id => specialityId, :entry_id => @entry.id, :user_id => @user.id)
            @user.entry_specialities.push(@entry_speciality)
            @entry.entry_specialities.push(@entry_speciality)
            @speciality.entry_specialities.push(@entry_speciality)
            @speciality.save
          end
        end
      end
    
      if (not params[:entry][:customer_id].nil?) and admin_or_event_manager
        @customer = Customer.find(params[:entry][:customer_id])
        if not completed     
          @entry.customer = @customer
        end
      end

      if not params[:entry][:contest_id].nil?
        @contest = Contest.find(params[:entry][:contest_id])
        #check if the new contest belongs to a completed event
        if not @contest.nil?
          @event = @contest.event
          if not @event.nil?
            completed = @event.Completed
          end
        end
        if not completed
          @entry.contest = @contest
        end
      end

      if not params[:entry][:club_id].nil?
        @club = Club.find(params[:entry][:club_id])
        if not completed
          @entry.club = @club
        end
      end


      if params[:entry][:photo].present?
        @photo = Photo.new(:photo => params[:entry][:photo])
        @photo.save
        @entry.photos.each do |p|
          p.delete
        end

        @entry.photos.push(@photo)
        @entry.save
        @entry = Entry.find(params[:id])
      end

    end 


    respond_to do |format|
      if (not completed) and (upload_ok)
        if @entry.update_attributes(params[:entry])
          format.html { redirect_to @entry, :notice => 'Entry was successfully updated.' }
          format.json { render :json => @entry}
        else
          format.html { render :action => "edit" }
          format.json { render :json => @entry.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "edit" }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy

    create_ok = false
    if params[:token].present?
      @token = Token.where("Value = ?", params[:token]).first
      @user = @token.user
    else
      @user = session[:currentUser]
    end
    create_ok = not((@user.roles & Role.find([1, 2])).empty?)

    if create_ok 
      @entry = Entry.find(params[:id])
      @entry.destroy
    end

    respond_to do |format|
      if create_ok
        format.html { redirect_to entries_url }
        format.json { head :no_content }
      else
        format.html { redirect_to :back }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
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
    return @roles_ids.include?(1)
  end

  def get_user_entries(current_user)
    @entry_events = Array.new   
    @user_events = current_user.events

    if not @user_events.nil?
      @user_events.each do |ue|
        @contests = ue.contests
        if not @contests.nil?
          @contests.each do |c|
            @ent = c.entries
            if not @ent.nil?
              @ent.each do |e|
                @entry_events.push(e.id)
              end
            end
          end
        end
      end
    end
    return @entry_events
  end

  def get_entry_specialities(specialityID)
    @entry_sp = Array.new
    @sp = EntrySpeciality.where("speciality_id = ?", specialityID)
    @sp.each do |s|
      @entry_sp.push(s.entry_id)
    end
    return @entry_sp
  end

end
