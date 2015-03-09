class AccomodationsController < ApplicationController

  before_filter :login_required

  respond_to :html

  def index
    @accomodations = Accomodation.all
  end

  def student_profile

  end

  def show
    # GET /accomodations/vezi_cerere
    if @current_user.accomodation.nil?
      redirect_to root_path
    else

        @dorms = Dorm.all
        @accomodation = @current_user.accomodation

        # this makes the inputs editable or not
        @editable = (@accomodation.state == 'saved') ? '' : 'disabled'
      end
  end

  def new
    # GET /accomodations/creeaza_cerere
    @dorms = Dorm.all
    # if !@current_user.accomodation.nil?
     #   @current_user.accomodation.destroy
     # end
    @accomodation = Accomodation.new
  end

  def create
    # POST /accomodations
    #if !@current_user.accomodation.nil?
     #   @current_user.accomodation.destroy
      #end
    @accomodation = Accomodation.new

    # step 3
    @accomodation.last_dorm = params[:last_dorm] || nil
    @accomodation.last_room = params[:last_room] || nil
    @accomodation.is_continuity = params[:is_continuity] || nil
    @accomodation.is_social = params[:is_social] || nil
    @accomodation.dorm_pref_1 = params[:dorm_pref_1] || nil
    @accomodation.dorm_pref_2 = params[:dorm_pref_2] || nil
    @accomodation.dorm_pref_3 = params[:dorm_pref_3] || nil
    @accomodation.roommate_pref = params[:roommate_pref] || nil

    

    if (params[:sent])
      @accomodation.state = 'sent'
    else
      @accomodation.state = 'saved'
    end


    # save everything
    if (@accomodation.save)
      # upload all documents from step 2
      if params[:documents]
        params[:documents].each do |document|
          @accomodation.documents.create({'name' => document.original_filename})

          # create directories if they don't exist
          Dir.mkdir(File.join("public/uploads")) unless Dir.exists?(File.join("public/uploads"))
          Dir.mkdir(File.join("public/uploads", @current_user.uid.to_s)) unless Dir.exists?(File.join("public/uploads", @current_user.uid.to_s))

          path = File.join("public/uploads", @current_user.uid.to_s, document.original_filename)
          File.open(path, "wb") { |f| f.write(document.read) }
        end
      end

      # destroy the old accomodation request. this should never happen, but just in case
    

      @current_user.accomodation = @accomodation
      @current_user.save

      redirect_to '/vezi_cerere'
      return
    end

    redirect_to root_path
  end

  def update
    @accomodation = @current_user.accomodation

    # step 3
    @accomodation.last_dorm = params[:last_dorm] || nil
    @accomodation.last_room = params[:last_room] || nil
    @accomodation.is_continuity = params[:is_continuity] || nil
    @accomodation.is_social = params[:is_social] || nil
    @accomodation.dorm_pref_1 = params[:dorm_pref_1] || nil
    @accomodation.dorm_pref_2 = params[:dorm_pref_2] || nil
    @accomodation.dorm_pref_3 = params[:dorm_pref_3] || nil
    @accomodation.roommate_pref = params[:roommate_pref] || nil
    if (params[:sent])
      @accomodation.state = 'sent'
    else
      @accomodation.state = 'saved'
    end


    # save everything
    if (@accomodation.save)
      # upload all documents from step 2
      if params[:documents]
        params[:documents].each do |document|
          @accomodation.documents.create({'name' => document.original_filename})

          # create directories if they don't exist
          Dir.mkdir(File.join("public/uploads")) unless Dir.exists?(File.join("public/uploads"))
          Dir.mkdir(File.join("public/uploads", @current_user.uid.to_s)) unless Dir.exists?(File.join("public/uploads", @current_user.uid.to_s))

          path = File.join("public/uploads", @current_user.uid.to_s, document.original_filename)
          File.open(path, "wb") { |f| f.write(document.read) }
        end
      end

      redirect_to '/creeaza_cerere'
      return
    end

    redirect_to root_path
  end

  def destroy
    # DELETE /accomodations/id

    Accomodation.find(params[:id]).destroy

    respond_to do |format|
      format.html
      format.json { render :json => { 'data' => '/creeaza_cerere' } }
    end
  end

  def verified_results

  end

  def decision

  end

end
