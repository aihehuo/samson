# frozen_string_literal: true
class JobsController < ApplicationController
  include CurrentProject

  skip_before_action :require_project, only: [:enabled]

  before_action :authorize_project_admin!, only: [:new, :create]
  before_action :authorize_project_deployer!, only: [:new, :create, :destroy]
  before_action :find_job, only: [:show, :destroy]

  def index
    @jobs = @project.jobs.non_deploy.page(params[:page])
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_project.jobs.build(
      user: current_user,
      command: command,
      commit: job_params[:commit]
    )

    if @job.save
      JobExecution.start_job(JobExecution.new(@job.commit, @job))
      redirect_to [@project, @job]
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.text do
        datetime = @job.updated_at.strftime("%Y%m%d_%H%M%Z")
        send_data @job.output,
          type: 'text/plain',
          filename: "#{@project.permalink}-#{@job.id}-#{datetime}.log"
      end
    end
  end

  def enabled
    if JobExecution.enabled
      head :no_content
    else
      head :accepted
    end
  end

  def destroy
    if @job.can_be_stopped_by?(current_user)
      @job.stop!
      flash[:notice] = "Cancelled!"
    else
      flash[:error] = "You are not allowed to stop this job."
    end

    redirect_back_or [@project, @job]
  end

  private

  def job_params
    params.require(:job).permit(:commit, :command)
  end

  def command_params
    if commands = params[:commands]
      commands.permit(ids: [])
    else
      {ids: []}
    end
  end

  def command
    command_ids = command_params[:ids].select(&:present?).map(&:to_i)
    commands = Command.find(command_ids).sort_by { |c| command_ids.index(c.id) }.map(&:command)
    if command = job_params[:command].strip.presence
      commands << command
    end
    commands.join("\n")
  end

  def find_job
    @job = current_project.jobs.find(params[:id])
  end
end
