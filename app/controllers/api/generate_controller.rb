require_relative "logic"
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
        if @scrap.length > 0
            data = @scrap
            logic = Scrapper.new(params[:url], data[0])
            if logic.get_date
                title = logic.title
                price = logic.price
                description = logic.description
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
            logic = Scrapper.new(params[:url])
            title = logic.title
            price = logic.price
            description = logic.description
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
            @scrap = Scrap.where(url: params[:url])
        end
end
