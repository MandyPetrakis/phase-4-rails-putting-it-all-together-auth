class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
    def index
        if session[:user_id]
            recipes = Recipe.all
            render json: recipes, include: :user, status: :created
        else 
            render json: {errors: ["Please log in"]}, status: :unauthorized
        end
    end

    def create 
        if session[:user_id]
            user = User.find(session[:user_id])
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, include: :user, status: :created
        else
            render json: {errors: ["Please log in"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def render_invalid
        render json: {errors: ["invalid data"]}, status: :unprocessable_entity
    end


end
