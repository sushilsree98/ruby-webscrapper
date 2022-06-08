class Api::GenerateController < ApplicationController
    before_action :getScrap, only: [:updateScrap, :deleteScrap, :showScrap]

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
        data = Scrap.new(scrapParams)
        if data.save()
            render json: data, status: :ok
        else
            render json: {message:"Unable to fetch data"}, status: :unprocessable_entity
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
            params.permit(:url, :title, :description, :price);
        end

        def getScrap
            @scrap = Scrap.where(url: params[:url])
        end
end
