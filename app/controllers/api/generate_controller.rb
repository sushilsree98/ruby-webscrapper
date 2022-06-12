require "date"
class Api::GenerateController < ApplicationController
    before_action :getScrap, only: [:updateScrap, :deleteScrap, :showScrap, :addData]

    # GET
    def getData
        scrap = Scrap.all
        if scrap
            render json:scrap, status: :ok
        else
            render json: {msg: "No scraped data found!"},  status: :unprocessable_entity
        end
    end

    # POST
    def addData
        if !params[:url].start_with?('https://www.flipkart.com')
            render json: {message:"invalid URL"}, status: :ok
        end
        if @scrap.length > 0
            data = @scrap
            # To Check if created date is before expiry date and update the changes
            t1 = Date.parse(data[0][:created_at].to_s)
            t2 = Date.today()
            if t1 < t2-7
                unparsed_page = HTTParty.get(params[:url])
                parsed_page = Nokogiri::HTML(unparsed_page)
                title = parsed_page.css('span.B_NuCI').text
                price = parsed_page.css('div._16Jk6d').text
                description = parsed_page.css('div._1AN87F').text
                if title == ""  
                    render json: {message:"invalid URL"}, status: :ok
                else
                    updated_data = @scrap.update(url: params[:url], title: title, price: price, description: description)
                    if updated_data
                        puts "successfully updated"
                    else
                        puts "Update failed!"
                    end
                end
                
            end
            render json: {message:"Already present", data: @scrap}, status: :ok
        else
            url = params[:url]
            unparsed_page = HTTParty.get(url)
            parsed_page = Nokogiri::HTML(unparsed_page)
            title = parsed_page.css('span.B_NuCI').text
            price = parsed_page.css('div._16Jk6d').text
            description = parsed_page.css('div._1AN87F').text
            if title == ""  
                render json: {message:"invalid URL"}, status: :ok
            else
                data = Scrap.new(url:url, title: title, price: price, description: description)
                if data.save()
                    render json: {message:"Created Successfully!", data: [data]}, status: :ok
                else
                    render json: {message:"Unable to fetch data"}, status: :unprocessable_entity
                end
            end
            
        end
    end

    #GET scrap
    def showScrap
        if @scrap
            render json: @scrap, status: :ok
        else
            render json: {msg: "Scraped data not found"}, status: :unprocessable_entity
        end
    end

    #PUT
    def updateScrap
        if @scrap
            if @scrap.update(scrapParams)
                render json: @scrap, status: :ok
            else
                render json: {msg:"Update failed!"}, status: :unprocessable_entity
            end
        else
            render json: {msg: "Scraped data not found"}, status: :unprocessable_entity
        end
    end

    #DELETE
    def deleteScrap
        if @scrap
            if @scrap.destroy()
                render json: {msg:"Deleted Successfully"}, status: :ok
            else
                render json: {msg:"Error occurred while deleting!"}, status: :unprocessable_entity
            end
        else
            render json: {msg: "Scraped data not found"}, status: :unprocessable_entity
        end
    end

    private
        def scrapParams
            params.permit(:url);
        end

        def getScrap
            if !params[:url].start_with?('https://www.flipkart.com')
                render json: {message:"invalid URL"}, status: :ok
            end
            @scrap = Scrap.where(url: params[:url])
        end
end
