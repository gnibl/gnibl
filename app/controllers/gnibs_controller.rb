class GnibsController < ApplicationController
  require 'base64'
  require 'open-uri'
  require 'nokogiri'
  require 'gnibl_util'
  include GniblUtil

  before_filter :signed_in_user

  def valid?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end

  def paste_content_url
    url = params[:url]
    puts "Request url content: #{url}"
    uri = URI.parse(url)
    baseurl = uri.scheme+"://"+uri.host
    @urls = ['']
    doc = Nokogiri::HTML(open(uri))
    sfinder = "/html/body//img"
    count = 0;
    doc.xpath(sfinder).each do |node|
      parturl = node.xpath("@src[not(contains(.,'footer')
		or contains(.,'logo')
		or contains(.,'spinners')
		)]").text #this is the url of an image avoid footers, ads etc
      #find if the part url is full or not
      fullurl = ""
      if valid?(parturl)
        fullurl= parturl
      else
        fullurl = baseurl+parturl
      end
      unless parturl.nil? or parturl.blank? or parturl.empty? # or valid?(fullurl)
        @urls[count] = fullurl
        count = count + 1
      end
    end
    @image_sources = ['']
    count = count -1
    count = 3
    while count > -1
      begin
        locate =URI.parse(@urls[count])
        file = open(locate,'rb').read
        @image_sources[count]  = Base64.encode64(file)
      rescue Exception => e
        @error = "some error"
      end
      count = count -1
    end

    if count > 0
      @pasted_content_url = true
    end
    respond_to do |format|
      format.js {render "gnibs/ajax_content_url_images"}
    end
  end

  def gnibstream
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    @gnib = @user.gnibs.build
    render "users/gnibstream"
  end

  def gnibpicks
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    @gnib = @user.gnibs.build
    render "users/gnibpicks"
  end
  def next_gnibstream
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @gnib = @user.gnibs.build
    @city_id = current_user.city
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).offest(page).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id)
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def next_gnibpicks
    page = params[:page]
    page = page.to_i - 1;
    page *= 10;
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("city = :city_id", :city_id => @city_id).offset(page).limit(9)
    @user = current_user
    @counts = Gnib.where("city = :city_id", :city_id => @city_id).count
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def titles
    term = params[:term]
    @gnibs = Gnib.where("title ILIKE '%"+term+"%'")
    respond_to do |format|
      format.js { render :json => @gnibs.to_json}
    end
  end

  def reportgnib
    @gnib_id = params[:gnib][:gnib_id]
    @user_id = current_user.id
    Reported.create(:reporter_id => @user_id, :gnib_id => @gnib_id)
    @gnib = Gnib.find(@gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal"}
    end
  end

  def comment
    @gnib_id = params[:gnib][:gnib_id]
    @user_id = current_user.id
    @descr = params[:comment]
    @comm = Comment.create(:user_id => @user_id, :gnib_id => @gnib_id, :description => @descr)
    if @comm
      @gnib = params[:gnib]
      notify_gnibler(@gnib_id, @comm)
    end
    @comments = Comment.where("gnib_id = #{@gnib_id}").order("created_at DESC")
    @counts = 0
    if @comments
      @counts = @comments.length
    end
    @gnib = Gnib.find(@gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal"}
    end
  end

  def upvotecomment
    @comment_id = params[:comment_id]
    @comment.update_attribute("votes",@comment.votes + 1)
    respond_to do |format|
      format.js {render "shared/gnib_modal"}
    end
  end

  def retcomment
    gnib_id = params[:gnib][:gnib_id]
    @comments = Comment.where("gnib_id = #{gnib_id}").order("created_at DESC")
    @counts = 0
    if @comments
      @counts = @comments.length
    end
    @gnib = Gnib.find(gnib_id)
    respond_to do |format|
      format.js {render "shared/gnib_modal" }
    end
  end

  def search
    term = params[:term]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").limit(9)
    @counts = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").count
    @gnib_pages = (@counts / 9).ceil;
  end
  def next_search
    term = params[:term]
    page = params[:page]
    @user = current_user
    @gnib = @user.gnibs.build
    @gnibs = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").offset(page).limit(9)
    @counts = Gnib.where("to_tsvector(description) @@ plainto_tsquery('"+term+"')").count
    @gnib_pages = (@counts / 9).ceil;
    respond_to do |format|
      format.js {render "shared/gnibs"}
    end
  end

  def create
    city_id = 0
    if current_user.city
      city_id = current_user.city.id
    end
    #retrieve title from # sign
    title = ''
    comment = params[:gnib][:description]
    unless(comment.nil?)
      pos = -1
      title = ""
      len = comment.length
      while pos = comment.index('#',pos+1)
        title = title+" "+ comment[pos+1..len].split(" ")[0]
      end
      params[:gnib][:title] = title
    end

    params[:gnib][:city] = city_id
    @gnib = current_user.gnibs.build(params[:gnib])
    @gnib.image = params[:image]
    if params[:url]
      @gnib.image = open(params[:url]
    end
    current_url = params[:current_url]
    @success = "You have successfully posted your gnib"
    flash[:notice] = @success
    puts "Image: #{@gnib.image}, url: #{params[:url]}"
    if @gnib.save
      #handle tagged people
      inform_tagged_gniblers(@gnib)
      current_user.like(@gnib.id)
      redirect_to current_url
    else
      redirect_to "/users/#{current_user.username}"
    end
  end

  def destroy
  end
end
