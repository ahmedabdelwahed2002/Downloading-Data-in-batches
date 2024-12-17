require 'csv'

class ReportsController < ApplicationController
  def index
    headers.delete('Content-Length')
    headers['Cache-Control'] = 'no-cache'
    headers['Content-Type'] = 'text/csv'
    headers['Content-Disposition'] = 'attachment; filename="report.csv"'
    headers['X-Accel-Buffering'] = 'no'

    response.status = 200

    self.response_body = csv_enumerator
  end

  private

  def csv_enumerator
    Enumerator.new do |yielder|
      # Add a CSV header row
      yielder << CSV.generate_line(%w[ID Name Total])

      # Stream each record
      Report.find_each(batch_size: 500) do |report|
        sleep(0.9) # 100ms delay between records
        yielder << CSV.generate_line([
                                       report.id,
                                       report.name,
                                       report.total
                                     ])
      end
    end
  end
end

# call http://localhost:3000/reports
