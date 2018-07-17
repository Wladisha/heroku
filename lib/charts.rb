class Charts
  def create
    db = SQLite3::Database.new('data\history.sqlite')
    db.results_as_hash = true
    usd = db.execute('SELECT * FROM valute Where Valuta = "USD"')
    usdvalue = []
    usd.each{ |row|
      row["Srednji_za_devize"].sub! ',', '.'
      usdvalue << row["Srednji_za_devize"].to_f
    }

    chart = Gchart.new(
                :type => 'bar',
                :size => '1000x300',
                :bar_colors => ['0000FF'],
                :title => "USD",
                :bg => 'EFEFEF',
                :legend => ["Currency fluctuations"],
                :data => [usdvalue],
                :filename => "images/bar_chart#{Date.today}.png",
                #:grouped => true,
                :legend_position => 'bottom',
                :axis_with_labels => ['y'],
                :max_value => 7,
                :min_value => 5.5,
                )

    chart.url
  end
end
