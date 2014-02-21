class CohortReport

  attr_accessor :cohorts

  def initialize(cohort_start_date, num_weeks)
    @cohort_start_date = cohort_start_date
    @num_weeks = num_weeks

    @cohorts = []

    for idx in 1..num_weeks
      start_date, end_date = week_range(cohort_start_date)
      users = User.includes(:orders).where(:created_at => start_date..end_date)
      # @cohorts << Hashie::Mash.new(:start_date => start_date, :end_date => end_date, :users => users)
      gaggle = Gaggle.new(:start_date => start_date, :end_date => end_date, :users => users)
      gaggle.init_buckets(@cohort_start_date)
      @cohorts << gaggle

      cohort_start_date = cohort_start_date - 1.week
    end

  end

  private

    def week_range(week_start_date)
      [
          week_start_date.beginning_of_day,
          (week_start_date.beginning_of_day + 6.days).end_of_day
      ]
    end

end
