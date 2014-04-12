class PiosenkasController < ApplicationController
  before_action :set_piosenka, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :new]
  before_action :signed_in_mod, only: [:edit]
  before_action :signed_in_admin, only: [:destroy]

  # GET /piosenkas
  # GET /piosenkas.json
  def index
    if (!session[:spiewnik].present?) 
      session[:spiewnik] = Array.new
      @piosenkiDodane = Hash.new
    else
      idPiosenek = session[:spiewnik].join(',')
      conditions = 'active = 1 AND id IN (' + idPiosenek + ')'
      @piosenkiDodane = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
    end
    @piosenkas = Piosenka.find(:all, :conditions => "active = 1", :order => "tytul asc")
    @spis = Hash.new { |hash, key| hash[key] = Hash.new { |hash2, key2| hash2[key2] = Hash.new }}
    @piosenkas.each do |piosenka|
      litera = piosenka.tytul[0]
      @spis[litera][piosenka.id][:tytul] = piosenka.tytul
      @spis[litera][piosenka.id][:tekst] = piosenka.tekst
      @spis[litera][piosenka.id][:akordy] = piosenka.akordy
    end
    if current_user != nil
      @zalogowany = true
    else 
      @zalogowany = false
    end 
  end

  def show
    begin
      @piosenka = Piosenka.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid entry #{params[:id]}"
      redirect_to piosenka_url, :notice => 'Invalid entry'
    else
      listaAkordow = @piosenka.piosenka_akords
      @obrazkiAkordow = Hash.new
      listaAkordow.each do |a|
        akord = Akord.find(a.akord_id)
        @obrazkiAkordow[akord.nazwa] = akord.obrazek
      end
      respond_to do |format|
        format.html {render :layout => false}
      end
    end
  end
  
  def add_to_pdf
    if (!session[:spiewnik].include?(params[:id]))
      session[:spiewnik] << params[:id]
    end
    idPiosenek = session[:spiewnik].join(',')
    conditions = 'id IN (' + idPiosenek + ')'
    @piosenki = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
    render :lista_piosenek, layout: false
  end
  
  def remove_from_pdf
    if (session[:spiewnik].include?(params[:id]))
      session[:spiewnik].delete_if {|id| id == params[:id] } 
    end
    if !session[:spiewnik].empty? 
      idPiosenek = session[:spiewnik].join(',')
      conditions = 'id IN (' + idPiosenek + ')'
      @piosenki = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
    else
      @piosenki = Hash.new
    end
    render :lista_piosenek, layout: false
  end

  def new
    @piosenka = Piosenka.new
    render :layout => "piosenka"
  end

  def edit
    render :layout => "piosenka"
  end

  # POST /piosenkas
  # POST /piosenkas.json
  def create
    @piosenka = Piosenka.new(piosenka_params)

    respond_to do |format|
      if @piosenka.save
        uzupelnij_akordy(@piosenka)
        Mailer.nowa_piosenka(@current_user.name,@piosenka.tytul,@piosenka.id).deliver
        redirect = '/edit/' + @piosenka.id.to_s
        format.html { redirect_to redirect, notice: 'Piosenka została dodana.' }
        format.json { render action: 'show', status: :created, location: @piosenka }
      else
        format.html { render action: 'new' }
        format.json { render json: @piosenka.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /piosenkas/1
  # PATCH/PUT /piosenkas/1.json
  def update
    respond_to do |format|
      if @piosenka.update(piosenka_params)
        usun_akordy(@piosenka)
        uzupelnij_akordy(@piosenka)
        redirect = '/edit/' + @piosenka.id.to_s
        format.html { redirect_to redirect, notice: 'Piosenka została zmieniona.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @piosenka.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /piosenkas/1
  # DELETE /piosenkas/1.json
  def destroy
    @piosenka.destroy
    respond_to do |format|
      format.html { redirect_to piosenkas_url }
      format.json { head :no_content }
    end
  end
  
  def generuj_pdf
    obrazek = Rails.root.join('app','assets','images','blacha.jpg')
    prawnto :prawn => { :page_size => 'A4', 
               :left_margin => 40,    
               :right_margin => 20,   
               :top_margin => 50,    
               :bottom_margin => 20,
               :background => obrazek
            }, 
            :filename => 'SpiewnikSKPBLublin.pdf'
    idPiosenek = session[:spiewnik].join(',')
    conditions = 'id IN (' + idPiosenek + ')'
    @piosenki = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
    @spis = Hash.new { |hash, key| hash[key] = Hash.new}
    @piosenki.each_with_index do |p, index|
      tekstTab = p.tekst.split("\n").each_slice(45).to_a
      listaAkordow = p.piosenka_akords
      if p.akordy.count("\n") > 37 
        p.akordy = ''
        obrazkiAkordow = ''
      else
        obrazkiAkordow = Hash.new
        listaAkordow.each do |a|
          akord = Akord.find(a.akord_id)
          obrazkiAkordow[akord.nazwa] = akord.obrazek
        end
      end
      @spis[p.id][:tytul] = p.tytul
      @spis[p.id][:tekst] = tekstTab
      @spis[p.id][:akordy] = p.akordy
      @spis[p.id][:obrazki_akordow] = obrazkiAkordow
      if index == @piosenki.length - 1
        @spis[p.id][:ostatnia] = true
      else 
        @spis[p.id][:ostatnia] = false
      end
    end
  end
  
  def add_to_list
    idPiosenek = session[:spiewnik].join(',')
    conditions = 'id IN (' + idPiosenek + ')'
    @piosenki = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
  end
  
  def remove_from_list
    idPiosenek = session[:spiewnik].join(',')
    conditions = 'id IN (' + idPiosenek + ')'
    @piosenki = Piosenka.find(:all, :conditions => conditions, :order => 'tytul')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_piosenka
      @piosenka = Piosenka.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def piosenka_params
      params.require(:piosenka).permit(:tytul, :tekst, :akordy, :wykonawca, :obrazek)
    end
    
    def uzupelnij_akordy(piosenka) 
      akordy = piosenka.akordy.squish.gsub(/[()]/i,'')
      akordyTab = akordy.split(' ')
      akordyTmp = Array.new
      akordyTab.each do |nazwa|
        unless akordyTmp.include?(nazwa)
          akordyTmp << nazwa
          if Akord.exists?(:nazwa => nazwa)
            akord = Akord.find(:first, :conditions => { :nazwa => nazwa })
            if !PiosenkaAkord.exists?(:piosenka_id=>piosenka.id, :akord_id=>akord.id) 
              piosenka.piosenka_akords.create(:piosenka_id=>piosenka.id, :akord_id=>akord.id)
            end
          end
        end
      end
    end
    
    def usun_akordy(piosenka) 
      piosenka.piosenka_akords.where(:piosenka_id => piosenka.id).delete_all
    end
end
