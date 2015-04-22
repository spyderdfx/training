class SearchController < ApplicationController
  def index
  end

  def upload
    Datafile.save_file(params[:upload][:datafile])              # сейвим файл
    @search_word = params[:upload][:search_word]                # слово для поиска
    @file_name = params[:upload][:datafile].original_filename   # название файла

    search_job_id = SearchJob.create(file_name: @file_name, search_word: @search_word)
    session[:search_job_id] = search_job_id
    session[:status] = Resque::Plugins::Status::Hash.get(session[:search_job_id])
    @session_status = session[:status]
    redirect_to :action => 'index'
  end

  def status
    session[:status] = Resque::Plugins::Status::Hash.get(session[:search_job_id])
    @session_status = session[:status]
    render 'index'
  end
end
