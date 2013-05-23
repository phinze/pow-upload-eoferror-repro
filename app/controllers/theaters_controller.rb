class TheatersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    theater = Theater.new(theater_params)
    theater.save!

    render json: {
      ok: true,
      url: theater.movie.url,
      filename: theater.movie.identifier,
    }
  end

  def theater_params
    params.require(:theater).permit(:movie)
  end
end
